//
//  SoundFile.h
//  SimpleSounds
//
//  Created by Robert Anderson on 07/03/2015.
//  Copyright (c) 2015 Rob Anderson. All rights reserved.
//

@import Foundation;
@import OpenAL.al;

@class SoundObject;


#define SoundTrackAll					0
#define SoundTrackEffects				1

/*
#define SoundTrackPlayer				2
#define SoundTrackRobot					3
#define SoundTrackEnviroment			4
...
*/


/** An object that represents a sound you want to play */
@interface SoundFile : NSObject



/** A simple constructor that creates a sound with a given name
 @Warning Assumes the file is a caf & is in the main bundle 
 @Warning Will raise an exception if the file doesn't exist */
+ (instancetype)effectWithName:(NSString *)name;

/** A More complex constructor allowing you to specify more info
 @param name The filename of the the sound file
 @param extension The extension the file has
 @param instances How many of this sound can be played at the same time
 @param track The group this sonud belongs to
 @Warning Will raise an exception if the file doesn't exist */
- (instancetype)initWithName:(NSString *)name ofType:(NSString *)type instances:(NSUInteger)instances track:(NSUInteger)track;




/** The track this sound belongs to */
@property (nonatomic, readonly) NSUInteger track;

/** How long, in seconds, this sound lasts */
@property (nonatomic, readonly) float duration;



@end
