# Another OpenAL Sound Framework (Work In Progress)
- Rob Anderson
- robb-j
- March 2015

## Features
- Play positional sounds, relative to an SKNode
- Sounds don't cancel out iPod music
- Play a sound multiple times at the same time (overlapping)
- Simple to use singleton to play sounds
- You don't have to do any low level C programming

## Coming Soon
- Sound looping
- Sound-music interaction
- Unique track volumes
- Integration with SKActions to link with nodes and play in Action sequencss & groups


## Instructions For Setup
#### Using Submodules (Best)
1. Open Terminal
2. Type: `cd to/your/project` (where your .xcodeproj is)
3. Type: `git submodule add git@github.com:robb-j/SimpleSounds.git`
4. Open your project in Xcode
5. Import the files in SimpleSounds/SoundEngine to your project, make sure to uncheck 'Copy items if needed'
6. Wherever you need the Scheduler use `#import "SimpleSound.h"`

#### Manually (Dirty)
1. Download the repository
2. Open Xcode
3. Add the files in SimpleSounds/SoundEngine to your project


## Usage
### Loading Sounds & Setup
First we create a dictionary of all the sounds you will be playing. The key is the identifier you'll use to play the sound and the value is a SoundFile object.

```objc
NSDictionary *sounds = @{
	@"Blaster" : [SoundFile effectWithName:@"Blaster"],
};
```

Now we have the sounds we have to tell SimpleSounds to load them. You access the singleton player and tell it to load your sounds. You can also pass an optional block of code that will be run after everything is loaded. For example in a game you could have a loading view which loads the assets, so in the block you could load the next set of assets or move to the game view.

```objc
[[SimpleSoundPlayer sharedPlayer] loadSounds:sounds withCompletion:^{
	
	// Something when the sounds are loaded
}];
```

Next we need to tell SimpleSounds which SKNode is listening to sounds, so all positional sounds will be played around this node. Here we set the target to a variable called `ship`. Once the above block has been called and the target is set, you can play sounds!

```objc
[[SimpleSoundPlayer sharedPlayer] setTarget:ship];
```

Optionally you can tweek the audible range property. This is the distance, in points, that your target SKNode can hear. Sounds played beyond that distance will not be heard. This could be useful if your character got in a vehicle they might need to be able to hear further that when they were just on foot. This property can be changed at anytime and doesn't have to be at the start.

```objc
[[SimpleSoundPlayer sharedPlayer] setAudibleRange:500.0f];
```



### Playing a sound
Playing a sound is ... simple and you have a few ways of doing it!

#### Just Playing a Sound
This is the simplest way to play a sound:

```objc
[[SimpleSoundPlayer sharedPlayer] playSound:@"Blaster"];
```
#### Specify a Volume
You can also just play a sound and specify how load you want it to be, where the volume is a float from 0.0 - 1.0

```objc
[[SimpleSoundPlayer sharedPlayer] playSound:@"Blaster" volume:0.7f];
```

#### Specify a Position
You can tell SimpleSounds to play a sound at a specific position. The position should be in the same node-space as the target. For example if the target was at x:100 y:200 and you played a sound at x:300 y:200, then the sound would play asif its 200 pixels to the right of the target. Here's how to do it:

```objc
[[SimpleSoundPlayer sharedPlayer] playSound:@"Blaster" fromPosition:CGPointMake(300, 200)];
```

#### Waiting for completion
Sometimes you want to know when your sound has finished playing, for example if the sound was dialog you'd want to know when they finished speaking so you can play the next bit. This can easily for be accomplished with these methods, where you replace ... with the code you want to be executed.

```objc
[[SimpleSoundPlayer sharedPlayer] playSound:@"Blaster" completion:^{ ... }];
[[SimpleSoundPlayer sharedPlayer] playSound:@"Blaster" volume:0.7f completion:^{ ... }];
[[SimpleSoundPlayer sharedPlayer] playSound:@"Blaster" fromPosition:CGPointMake(300, 200) completion:^{ ... }];
```

### Stopping, Pausing & Resuming Sounds
There are 3 simple methods to pause, resume & stop sounds. Stopping will terminate playback and rewind the sound back to the beginning, pausing will halt sounds and resuming will continue paused sounds where they left off. You can target specific sounds using tracks which will be covered below.

```objc
[[[SimpleSoundPlayer sharedPlayer] stopAllSounds];
[[[SimpleSoundPlayer sharedPlayer] pauseAllSounds];
[[[SimpleSoundPlayer sharedPlayer] resumeAllSounds];
```

### Cleaning Up
There'll come a time when you no longer need to play sounds, when this happens you need to tell SimpleSounds to clean itself up. This is done easily with this one-liner:

```objc
[[SimpleSoundPlayer sharedPlayer] cleanup];
```



## Sound Files & Tracks
[Coming Soon]



## Tips
- All the public functions of SimpleSoundPlayer have AppleDoc info, so you can do a 3 finger tap to learn about the function and its parameters.
