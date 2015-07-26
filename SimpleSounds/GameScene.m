//
//  GameScene.m
//  SimpleSounds
//
//  Created by Robert Anderson on 07/03/2015.
//  Copyright (c) 2015 Rob Anderson. All rights reserved.
//

#import "GameScene.h"
#import "SimpleSoundPlayer.h"
#import "SoundFile.h"

#define kAudioRange				210.0f
#define kSoundInterval			0.7f

@implementation GameScene {
	
	SKEmitterNode *_emitter;
	SKNode *_ship;
	CFTimeInterval _nextSoundTime;
	
	BOOL _touchMoved;
	BOOL _loaded;
	
	StopLoopBlock _stopLoop;
}

#pragma mark - Scene Lifecycle
- (void)didMoveToView:(SKView *)view {
	
	_touchMoved = NO;
	_loaded = NO;
	
	
	// Create the ship's body
	SKSpriteNode *body = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
	[body setScale:0.2f];
	
	
	// Annotate it's audible range (how far it can hear)
	SKShapeNode *circle = [SKShapeNode shapeNodeWithCircleOfRadius:kAudioRange];
	circle.fillColor = [SKColor clearColor];
	circle.strokeColor = [SKColor yellowColor];
	
	
	// Add the circle & body to the ship node & center it
	_ship = [SKNode node];
	[_ship addChild:body];
	[_ship addChild:circle];
	_ship.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
	
	
	
	// Load an emitter from the particle file
	NSString *emitterPath = [[NSBundle mainBundle] pathForResource:@"Effect" ofType:@"sks"];
	_emitter = (SKEmitterNode *)[NSKeyedUnarchiver unarchiveObjectWithFile:emitterPath];
	_emitter.position = _ship.position;
	[_emitter setTargetNode:self];
    
	
	
	// Add the ship & emitter to the scene
	[self addChild:_ship];
	[self addChild:_emitter];
	
	
	
	
	
	// - - - - - - - - - - - - - - - - - - - - - 
	// Sound Player Setup
	// - - - - - - - - - - - - - - - - - - - - - 
	
	
	// Set the Target & range
	[[SimpleSoundPlayer sharedPlayer] setTarget:_ship];
	[[SimpleSoundPlayer sharedPlayer] setAudibleRange:kAudioRange];
	
	
	// Create the sounds we want & give each an identifier (the key)
	NSDictionary *sounds = @{
		@"Blaster" : [SoundFile effectWithName:@"Blaster"],
		@"Laser" : [SoundFile effectWithName:@"Laser"]
	};
	
	
	// Load The sounds
	[[SimpleSoundPlayer sharedPlayer] loadSounds:sounds withCompletion:^{
		
		_loaded = YES;
	}];
}

- (void)willMoveFromView:(SKView *)view {
	
	[[SimpleSoundPlayer sharedPlayer] cleanup];
}



#pragma mark - Touches
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
	// When a touch drags, move the emitter
    for (UITouch *touch in touches) {
        
		_emitter.position = [touch locationInNode:self];
    }
	
	_touchMoved = YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	// If a tap occured, move the ship there
	if ( ! _touchMoved) {
		
		for (UITouch *touch in touches) {
			
			_ship.position = [touch locationInNode:self];
		}
	}
	
	/*
	if (_stopLoop) {
		
		_stopLoop();
		_stopLoop = nil;
	}
	else {
		
		_stopLoop = [[SimpleSoundPlayer sharedPlayer] playSound:@"Laser" loops:YES];
	}
	 */
	
	_touchMoved = NO;
}


#pragma mark - Scene Tick
- (void)update:(CFTimeInterval)currentTime {
	
	if (currentTime > _nextSoundTime && _loaded) {
		
		// Update when to next play a sound
		_nextSoundTime = currentTime + kSoundInterval;
		
		
		// Play Sound At the location of the emitter
		[[SimpleSoundPlayer sharedPlayer] playSound:@"Blaster" fromPosition:_emitter.position];
	}
	
}

@end
