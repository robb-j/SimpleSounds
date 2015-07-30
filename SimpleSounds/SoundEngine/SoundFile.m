//
//  SoundFile.m
//  SimpleSounds
//
//  Created by Robert Anderson on 07/03/2015.
//  Copyright (c) 2015 Rob Anderson. All rights reserved.
//

#import "SoundFile.h"

@import AudioToolbox;

#import "OpenALSupport.h"
#import "SoundObject.h"

@import AVFoundation.AVAsset;


@implementation SoundFile {
	
	ALuint _buffer;
	NSUInteger _numInstances;
	
	int _nextSound;
	NSArray *_allSounds;
	
	NSURL *_url;
}


#pragma mark - Sound Lifecycle
+ (instancetype)effectWithName:(NSString *)name {
	
	return [[self alloc] initWithName:name ofType:@"caf" instances:3 track:SoundTrackEffects];
}

- (instancetype)initWithName:(NSString *)name ofType:(NSString *)type instances:(NSUInteger)instances track:(NSUInteger)track {
	
	self = [super init];
	
	if (self) {
		
		// Store properties
		_numInstances = instances;
		_track = track;
		
		
		// See if the file exists
		_url = [[NSBundle mainBundle] URLForResource:name withExtension:type];
		
		
		// Find the duration of this sound file
		AVURLAsset *asset = [AVURLAsset assetWithURL:_url];
		_duration = CMTimeGetSeconds(asset.duration);
		
		
		// Error if
		if ( ! _url) {
			
			[NSException raise:@"Failed to open audio file" format:@"File: %@.%@", name, type];
		}
		
	}
	return self;
}

- (void)loadSound {
	
	// Get information about the audio file, using the support C file
	ALsizei size; ALenum format; ALsizei sampleRate;
	void *audioData = getOpenALAudioData((__bridge CFURLRef)_url, &size, &format, &sampleRate);
	
	
	// Create a buffer to play the sound
	alGenBuffers(1, &_buffer);
	alBufferDataStaticProc(_buffer, format, audioData, size, sampleRate);
	
	
	// Store the sources in SoundObjects
	NSMutableArray *allSources = [NSMutableArray arrayWithCapacity:_numInstances];
	ALuint newSource = 0;
	
	for (int i = 0; i < _numInstances; i++) {
		
		// Generate a source, set its buffer
		alGenSources(1, &newSource);
		alSourcei(newSource, AL_BUFFER, _buffer);
		
		
		// Create a buffer with it
		[allSources addObject:[SoundObject soundWithSource:newSource duration:_duration]];
	}
	
	
	// Store an immutable copy to stop it being modified
	_allSounds = [NSArray arrayWithArray:allSources];
}

- (void)cleanup {
	
	// Delete the buffer
	alDeleteBuffers(1, &_buffer);
	
	
	// Delete the sources
	for (SoundObject *sound in _allSounds) {
		
		[sound cleanup];
	}
}


#pragma mark - Internal Sound Usage
- (SoundObject *)nextSound {
	
	// Get the sound to return
	ALuint current = _nextSound;
	
	
	// Increment & loop round the counter
	_nextSound = (_nextSound + 1) % (_numInstances);
	
	
	// Return the current sound
	return _allSounds[current];
}

- (NSArray *)allSounds {
	
	return _allSounds;
}



@end
