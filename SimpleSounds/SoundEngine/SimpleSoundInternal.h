//
//  SimpleSoundInternal.h
//  SimpleSounds
//
//  Created by Robert Anderson on 18/03/2015.
//  Copyright (c) 2015 Rob Anderson. All rights reserved.
//


/*
 * An import for internal use only!
 */


#import "SimpleSoundPlayer.h"
#import "SoundFile.h"
#import "SoundObject.h"

@interface SimpleSoundPlayer (internal)
- (SoundObject *)nextSoundForEffect:(NSString *)effectName;
@end


@interface SoundFile (internal)
- (void)loadSound;
- (void)cleanup;

- (SoundObject *)nextSound;
- (NSArray *)allSounds;
@end