//
//  SoundObject.m
//  SimpleSounds
//
//  Created by Robert Anderson on 16/03/2015.
//  Copyright (c) 2015 Rob Anderson. All rights reserved.
//

#import "SoundObject.h"

@import SpriteKit;

#define kDefaultHeight		0.0f


/** The state a sound can be in */
typedef NS_ENUM(NSUInteger, SoundState) {
	SoundStateStopped,
	SoundStatePlaying,
	SoundStatePaused,
};



@implementation SoundObject {
	
	ALuint _source;
	SoundCallback _callback;
	SoundState _state;
}


#pragma mark - Sound Lifecycle
+ (instancetype)soundWithSource:(ALuint)source duration:(float)duration {
	
	return [[self alloc] initWithSoundSource:source duration:duration];
}

- (instancetype)initWithSoundSource:(ALuint)source duration:(float)duration {
	
	self = [super init];
	
	if (self) {
		
		// Store properties
		_source = source;
		_duration = duration;
		_state = SoundStateStopped;
	}
	return self;
}

- (void)cleanup {
	
	// Delete our source
	alDeleteSources(1, &_source);
}


#pragma mark - Sounds
- (void)play {
	
	// If we can't play, first stop ourself
	if (_state != SoundStateStopped) {
		
		[self stop];
	}
	
	
	// Only play if we're stopped
	if (_state == SoundStateStopped) {
		
		// Play with OpenAL
		alSourcePlay(_source);
		
		
		// Call finished when done
		[self performSelector:@selector(finished) withObject:nil afterDelay:_duration];
		
		
		// Update our state
		_state = SoundStatePlaying;
	}
}

- (void)stop {
	
	// Stop with OpenAL
	alSourceStop(_source);
	
	
	// Remove the callback
	_callback = nil;
	
	
	// Cancel any delayed calls to `finish`
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	
	
	// Update our state
	_state = SoundStateStopped;
}

- (void)pause {
	
	// If we're playing, pause ourself
	if (_state == SoundStatePlaying) {
		
		// Pause with openAL
		alSourcePause(_source);
		
		
		// Cancel any delay calls to `finish`
		[NSObject cancelPreviousPerformRequestsWithTarget:self];
		
		
		// Update our state
		_state = SoundStatePaused;
	}
}

- (void)resume {
	
	// If we're paused, play again
	if (_state == SoundStatePaused) {
		
		// Play with OpenAL
		alSourcePlay(_source);
		
		
		// Call `finished` when we actully finished (duration - time elapsed)
		float elapsed; alGetSourcef(_source, AL_SEC_OFFSET, &elapsed);
		[self performSelector:@selector(finished) withObject:nil afterDelay:_duration - elapsed];
		
		
		// Update our state
		_state = SoundStatePlaying;
	}
}

- (void)finished {
	
	// Keep a reference of the callback (`stop` deletes it)
	SoundCallback callback = _callback;
	
	
	// Stop ourseld
	[self stop];
	
	
	// If there is a callback, run it
	if (callback) {
		callback();
	}
}


#pragma mark - Setters
- (void)setPosition:(CGPoint)position {
	
	float posAL[] = {position.x, kDefaultHeight, position.y};
	alSourcefv(_source, AL_POSITION, posAL);
}

- (void)setAudibleRange:(CGFloat)range {
	
	alSourcef(_source, AL_MAX_DISTANCE, range);
}

- (void)setVolume:(CGFloat)volume {
	
	alSourcef(_source, AL_GAIN, volume);
}

- (void)addCallback:(SoundCallback)callback {
	
	_callback = callback;
}


@end
