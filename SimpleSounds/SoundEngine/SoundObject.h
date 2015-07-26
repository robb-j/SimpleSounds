//
//  SoundObject.h
//  SimpleSounds
//
//  Created by Robert Anderson on 16/03/2015.
//  Copyright (c) 2015 Rob Anderson. All rights reserved.
//

@import Foundation;
@import CoreGraphics.CGGeometry;
@import OpenAL.AL;

#import "SimpleSoundTypes.h"

@class SKNode;


/** An internal state-machined object that represents the playing of a single sound */
@interface SoundObject : NSObject


/** Creates a sound with a given OpenAL sourc & its duration */
+ (instancetype)soundWithSource:(ALuint)source duration:(float)duration;

/** Cleans up any OpenAL mess its made */
- (void)cleanup;




/** Play the sound */
- (void)play;

/** Stop the sound */
- (void)stop;

/** Pause the sound */
- (void)pause;

/** Resume the sound (when its been paused) */
- (void)resume;




/** Set the position of the sound, relative to the SimpleSoundPlayer.target's parent */
- (void)setPosition:(CGPoint)position;

/** Set how far away the sound can be heard from, in points */
- (void)setAudibleRange:(CGFloat)range;

/** Set the volume of the sound */
- (void)setVolume:(CGFloat)volume;

/** Add a callback for when thia sound finishes */
- (void)addCallback:(SoundCallback)callback;

/** Tell the sound how many times to loop, -1 for infinate loops */
- (StopLoopBlock)setLooping:(BOOL)shouldLoop;





/** How long, in seconds, the sound lasts */
@property (nonatomic, readonly) float duration;


@end
