 //
//  AudioManager.m
//  SimpleSounds
//
//  Created by Robert Anderson on 07/03/2015.
//  Copyright (c) 2015 Rob Anderson. All rights reserved.
//

#import "SimpleSoundPlayer.h"
#import "SimpleSoundInternal.h"

#import "OpenALSupport.h"
#import "SoundFile.h"
#import "SoundObject.h"

@import OpenAL.alc;
@import AVFoundation.AVAudioSession;
@import MediaPlayer;
@import UIKit;

#define kMaxVolume 			1.0f
#define kDefaultRange		300.0f



@implementation SimpleSoundPlayer {
	
	NSDictionary *_allSoundFiles;
	
	ALCdevice *_audioDevice;
	ALCcontext *_audioContext;
	
	NSMutableArray *_allCallbackWaits;
	
	BOOL _isLoaded;
}




#pragma mark - Player Lifecycle
static SimpleSoundPlayer *_sharedInstance;

+ (instancetype)sharedPlayer {
	
	@synchronized(self) {
		if (_sharedInstance == nil) {
			_sharedInstance = [self new];
		}
	}
	return _sharedInstance;
}

- (instancetype)init {
	
	self = [super init];
	
	if (self) {
		
		// Setup locals
		_allSoundFiles = [NSDictionary new];
		_globalVolume = 1.0f;
		_isLoaded = NO;
		_audibleRange = kDefaultRange;
		
		
		// Listen for music player changes
		//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(musicPlayerChanged:) name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:nil];
		//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appBecameActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
		//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
		//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillTerminate:) name:UIApplicationWillTerminateNotification object:nil];
		
	}
	return self;
}

- (void)setupOpenAL {
	
	// Get the audio device
	_audioDevice = alcOpenDevice(NULL);
	
	if (_audioDevice != NULL) {
		
		
		// Get the context
		_audioContext = alcCreateContext(_audioDevice, 0);
		
		if (_audioContext != NULL) {
			
			
			// Set the context & choose the audio distance mode
			alcMakeContextCurrent(_audioContext);
			alDistanceModel(AL_LINEAR_DISTANCE_CLAMPED);
		}
	}
}

- (void)loadSounds:(NSDictionary *)soundFiles withCompletion:(LoadSoundCompletion)completion {
	
	if (_isLoaded) {
		
		NSLog(@"Warning: SimpleSoundPlayer is already loaded!");
		return;
	}
	
	
	// Setup the Audio Session
	[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];
	[[AVAudioSession sharedInstance] setActive:YES error:nil];
	
	
	// Setup OpenAL
	[self setupOpenAL];
	
	
	// Run this in a background thread
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		
		
		// Get the files from the generator
		NSMutableDictionary *files = [NSMutableDictionary dictionaryWithDictionary:soundFiles];
		NSMutableArray *toRemove = [NSMutableArray array];
		
		
		// Loop each key/value provided
		for (NSString *key in files) {
			
			// Make sure the keys are strings & the objects are SoundFiles
			if ( ! [key isKindOfClass:[NSString class]] || ![files[key] isKindOfClass:[SoundFile class]]) {
				
				[toRemove addObject:key];
			}
			
			// If ok, load the sound
			else {
				
				[files[key] loadSound];
			}
		}
		
		
		// Remove the incorrect objects with their keys
		if (toRemove.count > 0) {
			[files removeObjectsForKeys:toRemove];
		}
		
		
		// Store as a immutable copy locally
		_allSoundFiles = [NSDictionary dictionaryWithDictionary:files];
		
		
		// Go back to the main thread
		dispatch_async(dispatch_get_main_queue(), ^{
			
			// Re-set the listener & range now OpenAL is setup
			[self setAudibleRange:_audibleRange];
			[self setListenerPosition:_target.position];
			
			
			// Rememeber that we're loaded
			_isLoaded = YES;
			
			
			// Run the completion, letting the caller know we're done
			if (completion) {
				completion();
			}
		});
	});
}

- (void)cleanup {
	
	// Remove the target
	[self setTarget:nil];
	
	
	// Clean up each file
	[_allSoundFiles enumerateKeysAndObjectsUsingBlock:^(NSString *name, SoundFile *file, BOOL *stop) {
		
		[file cleanup];
	}];
	
	
	// Close down OpenAL
	alcCloseDevice(_audioDevice);
	alcDestroyContext(_audioContext);
	
	
	// Remove observations
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	
	// We are now un loaded
	_isLoaded = NO;
}


#pragma mark - Music Player Management
- (void)musicPlayerChanged:(NSNotification *)notif {
	
	NSLog(@"Changed: %@", notif.object);
}

- (void)appResignActive:(NSNotification *)notif {
	
}

- (void)appBecameActive:(NSNotification *)notif {
	
}

- (void)appWillTerminate:(NSNotification *)notif {
	
}



#pragma mark - Listener Position
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	
	// Listen for the position of the target changing
	if ([keyPath isEqualToString:@"position"] && object == _target) {
		
		//[self setListenerPosition:[change[NSKeyValueChangeNewKey] CGPointValue]];
	}
}

- (void)setListenerPosition:(CGPoint)position {
	
	// Convert to OpenAL and set the it
	float listenerPosAL[] = {position.x, 0., position.y};
	alListenerfv(AL_POSITION, listenerPosAL);
}


#pragma mark - User Variables
- (void)setTarget:(SKNode *)target {
	
	if (_target) {
		
		// If we already have a target, stop listening to it
		//[_target removeObserver:self forKeyPath:@"position"];
	}
	
	
	// Set the new target
	_target = target;
	
	
	if (_target) {
		
		// If we still have a target, listen for its position & update the listener
		//[target addObserver:self forKeyPath:@"position" options:NSKeyValueObservingOptionNew context:nil];
		[self setListenerPosition:target.position];
	}
	else {
		
		
		// If we no longer have a target, reset the listening position
		[self setListenerPosition:CGPointZero];
	}
}

- (void)setAudibleRange:(double)range {
	
	_audibleRange = range;
	
	
	// Update all sound objects' range
	[_allSoundFiles enumerateKeysAndObjectsUsingBlock:^(NSString *name, SoundFile *file, BOOL *stop) {
		
		for (SoundObject *object in [file allSounds]) {
			
			[object setAudibleRange:range];
		}
	}];
}


#pragma mark - Audio Interface
- (void)playSound:(NSString *)name {
	
	[self playSound:name volume:1.0f];
}

- (void)playSound:(NSString *)name completion:(SoundCallback)completion {
	
	[self playSound:name volume:1.0f completion:completion];
}

- (void)playSound:(NSString *)name volume:(float)volume {
	
	[self playSoundNamed:name volume:volume position:_target.position completion:nil loops:false];
}

- (void)playSound:(NSString *)name volume:(float)volume completion:(SoundCallback)completion {
	
	[self playSoundNamed:name volume:volume position:_target.position completion:completion loops:false];
}

- (void)playSound:(NSString *)name fromPosition:(CGPoint)position {
	
	[self playSoundNamed:name volume:1.0f position:position completion:nil loops:false];
}

- (void)playSound:(NSString *)name fromPosition:(CGPoint)position completion:(SoundCallback)completion {
	
	[self playSoundNamed:name volume:1.0f position:position completion:completion loops:false];
}

- (StopLoopBlock)playSound:(NSString *)name loops:(NSInteger)loops {
	
	return [self playSoundNamed:name volume:1.0 position:_target.position completion:nil loops:loops];
}

- (StopLoopBlock)playSoundNamed:(NSString *)name volume:(CGFloat)volume position:(CGPoint)position completion:(SoundCallback)completion loops:(BOOL)loops {
	
	// If we haven't loaded, inform the user
	if ( ! _isLoaded) {
		
		NSLog(@"Warning: This player has not been loaded, remember to call loadSoundsWithCompletion:");
		return nil;
	}
	
	
	// Get the File to be play
	SoundFile *soundFile = _allSoundFiles[name];
	
	
	// If we have a sound file we want to play
	if (soundFile) {
		
		// Get a Sound Object to play
		SoundObject *sound = [soundFile nextSound];
		
		
		// Update the sound's properties
		[sound setVolume:volume * _globalVolume];
		[sound setPosition: CGPointMake(position.x - _target.position.x, position.y - _target.position.y)];
		StopLoopBlock stopper = [sound setLooping:loops];
		
		
		// If we have a callback, set that too
		if (completion) {
			
			[sound addCallback:completion];
		}
		
		
		// Finally play the sound
		[sound play];
		
		return stopper;
	}
	
	return nil;
}



#pragma mark - Stopping Sounds
- (void)stopAllSounds {
	
	// Just call stopTrack with the 'All' option
	[self stopTrack:SoundTrackAll];
}

- (void)stopTrack:(NSUInteger)track {
	
	// Loop every sound
	[_allSoundFiles enumerateKeysAndObjectsUsingBlock:^(NSString *name, SoundFile *file, BOOL *stop) {
		
		if (track == SoundTrackAll || file.track == track) {
			
			// If we want to stop this track, stop the it
			for (SoundObject *sound in [file allSounds]) {
    			
				[sound stop];
			}
		}
	}];
}

- (void)pauseAllSounds {
	
	// Just call pauseTrack with the 'All' option
	[self pauseTrack:SoundTrackAll];
}

- (void)pauseTrack:(NSUInteger)track {
	
	// Loop every sound
	[_allSoundFiles enumerateKeysAndObjectsUsingBlock:^(NSString *name, SoundFile *file, BOOL *stop) {
		
		if (track == SoundTrackAll || file.track == track) {
			
			// If we want to pause this track, pause it
			for (SoundObject *sound in [file allSounds]) {
				
				[sound pause];
			}
		}
	}];
}

- (void)resumeAllSounds {
	
	// Just call resumeTrack with 'All' option
	[self resumeTrack:SoundTrackAll];
}

- (void)resumeTrack:(NSUInteger)track {
	
	// Loop every sound
	[_allSoundFiles enumerateKeysAndObjectsUsingBlock:^(NSString *name, SoundFile *file, BOOL *stop) {
		
		if (track == SoundTrackAll || file.track == track) {
			
			// If we want to resume this track, resume it
			for (SoundObject *sound in [file allSounds]) {
				
				[sound resume];
			}
		}
	}];
}


#pragma mark - Internal
- (SoundObject *)nextSoundForEffect:(NSString *)effectName {
	
	if ( ! _isLoaded) {
		
		NSLog(@"Warning: This player has not been loaded, remember to call loadSoundsWithCompletion:");
	}
	else {
		
		SoundFile *file = _allSoundFiles[effectName];
		
		if (file) {
			
			return [file nextSound];
		}
	}
	
	return nil;
}



@end
