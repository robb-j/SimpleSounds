//
//  SimpleSoundTypes.h
//  SimpleSounds
//
//  Created by Robert Anderson on 17/03/2015.
//  Copyright (c) 2015 Rob Anderson. All rights reserved.
//

/*
 * A Place for common types accross SimpleSounds
 */


/** A block to be called when a Sound finished playing */
typedef void(^SoundCallback)();


/** A block to be called when all the sounds were loaded */
typedef void(^LoadSoundCompletion)();


/** A number that represents a group of SoundFiles.
 * It is specified when you create a SoundFile, the default being SoundTrackEffect.
 * You can implement more by specifying the track when you create a SoundFile.
 @Warning track 0 is reserved for the SoundTrackAll constant which represents every track */
typedef NSUInteger SoundTrack;


/** How the sound player will cope with music being played */
typedef NS_ENUM(NSUInteger, MusicInteractionType) {
	MusicInteractionNoMusic,
	MusicInteractionPlayBoth
};