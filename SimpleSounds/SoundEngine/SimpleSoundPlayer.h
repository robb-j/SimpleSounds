//
//  AudioManager.h
//  SimpleSounds
//
//  Created by Robert Anderson on 07/03/2015.
//  Copyright (c) 2015 Rob Anderson. All rights reserved.
//

@import SpriteKit;
@import AVFoundation.AVAudioPlayer;

#import "SimpleSoundTypes.h"

/** The star of the show! A singleton object for you play sounds with.
 @Warning You can't play sounds if the target isn't set */
@interface SimpleSoundPlayer : NSObject




/** The singleton method to access the shared instance of this class
 @Warning never call `alloc` or `new` on this class */
+ (instancetype)sharedPlayer;




/** Use this to load all the sounds you'll be using in your app / game.
 @param soundFiles This is a dictionary of identifier -> SoundFile of each sound you want to load
 @param completion This is an optional block that'll get called once the sounds have been loaded*/
- (void)loadSounds:(NSDictionary *)soundFiles withCompletion:(LoadSoundCompletion)completion;

/** Call this when you're finished playing sounds
 @Warning not calling this will lead to memory leaks :( */
- (void)cleanup;




/** Play a sound
 @param name The identifier of the sound you want to play (the key from loadSounds:withCompletion's soundFiles */
- (void)playSound:(NSString *)name;

/** Play a sound
 @param name The identifier of the sound you want to play (the key from loadSounds:withCompletion's soundFiles
 @param completion A block that'll get called when the sound finished playing */
- (void)playSound:(NSString *)name completion:(SoundCallback)completion;

/** Play a sound with a gien volume
 @param name The identifier of the sound you want to play (the key from loadSounds:withCompletion's soundFiles 
 @param volume How load you want the sound to play, 0.0 to 1.0 */
- (void)playSound:(NSString *)name volume:(float)volume;

/** Play a sound with a gien volume
 @param name The identifier of the sound you want to play (the key from loadSounds:withCompletion's soundFiles 
 @param volume How load you want the sound to play, 0.0 to 1.0
 @param completion A block that'll get called when the sound finished playing */
- (void)playSound:(NSString *)name volume:(float)volume completion:(SoundCallback)completion;

/** Play a sound with a gien position
 @param name The identifier of the sound you want to play (the key from loadSounds:withCompletion's soundFiles 
 @param volume Where you want the sound to come from, relative to the target's parent */
- (void)playSound:(NSString *)name fromPosition:(CGPoint)position;

/** Play a sound with a gien position
 @param name The identifier of the sound you want to play (the key from loadSounds:withCompletion's soundFiles 
 @param volume Where you want the sound to come from, relative to the target's parent
 @param completion A block that'll get called when the sound finished playing */
- (void)playSound:(NSString *)name fromPosition:(CGPoint)position completion:(SoundCallback)completion;




/** Stop every sound that is playing */
- (void)stopAllSounds;

/** Stop every sound for a given track number, see `SoundTrack` in SimpleSoundTypes.h */
- (void)stopTrack:(SoundTrack)track;

/** Pause every sound that is playing */
- (void)pauseAllSounds;

/** Pause every sound for a given track number, see `SoundTrack` in SimpleSoundTypes.h */
- (void)pauseTrack:(SoundTrack)track;

/** Resume every sound that is paused */
- (void)resumeAllSounds;

/** Resume every sound for a given track number, see `SoundTrack` in SimpleSoundTypes.h */
- (void)resumeTrack:(SoundTrack)track;



/** The node that is listening to sounds, when given a position all sounds will be played relative to this node.
 @Warning You cannot play sounds without specifying a target */
@property (nonatomic, weak) SKNode *target;

/** How far, in points, the target can hear */
@property (nonatomic) double audibleRange;

/** A Global volume for all sounds 
 @Todo have individual volumes for each track*/
@property (nonatomic) double globalVolume;


/** How the music player interacts with the device's music */
//@property (nonatomic) MusicInteractionType musicInteraction;


@end
