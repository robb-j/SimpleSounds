//
//  SKAction+SimpleSounds.m
//  SimpleSounds
//
//  Created by Robert Anderson on 18/03/2015.
//  Copyright (c) 2015 Rob Anderson. All rights reserved.
//




// Possible issues:
// 	- Where SKAction.wait clashes with the manual pauseTrack:
// 	- Where same action is performed at the same time



#import "SKAction+SimpleSounds.h"
#import "SimpleSoundInternal.h"

@implementation SKAction (SimpleSounds)

+ (instancetype)playSoundEffectWithTarget:(NSString *)effectName {
	
	SoundObject *sound = [[SimpleSoundPlayer sharedPlayer] nextSoundForEffect:effectName];
	
	if (sound == nil) {
		
		// Some sort of error
		NSLog(@"Error: Effect does not exist: %@", effectName);
		return [SKAction waitForDuration:0.0f];
	}
	
	SKAction *play = [SKAction runBlock:^{
		
		[sound play];
	}];
	
	__block SKNode *target;
	
	SKAction *update = [SKAction customActionWithDuration:sound.duration actionBlock:^(SKNode *node, CGFloat elapsedTime) {
		
		// Update position, converted to the correct node space
		target = [[SimpleSoundPlayer sharedPlayer] target];
		[sound setPosition:[node.parent convertPoint:node.position toNode:target.parent]];
		
		// Apply doppler?
	}];
	
	return [SKAction sequence:@[play, update]];
}

+ (instancetype)playSoundEffect:(NSString *)effectName volume:(double)volume {
	
	// Get the sound object to play
	SoundObject *sound = [[SimpleSoundPlayer sharedPlayer] nextSoundForEffect:effectName];
	
	
	// If nil, warn the user
	if (sound == nil) {
		
		// Some sort of error
		NSLog(@"Error: Effect does not exist: %@", effectName);
		return [SKAction waitForDuration:0.0f];
	}
	
	
	// An Action that plays the sound
	SKAction *play = [SKAction runBlock:^{
		
		[sound play];
	}];
	
	
	// An Action that waits until the sound is done
	SKAction *wait = [SKAction waitForDuration:sound.duration];
	
	
	// Return a sequence of the two actions
	return [SKAction sequence:@[play, wait]];
}

@end
