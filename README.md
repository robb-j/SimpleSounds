# Another OpenAL Sound Framework (Work In Progress)
- Rob Anderson
- robb-j
- March 2015

## Features
- Play positional sounds, relative to an SKNode
- Sounds don't cancel out iPod music
- Play a sound multiple times at the same time (overlapping)
- Simple to use singleton to play sounds
- Integrates with SKActions to link with nodes and play in Action sequencss & groups
- You don't have to do any low level C programming

## Todo
- Sound looping
- Sound-music interaction
- Unique track volumes


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

```
NSDictionary *sounds = @{
	@"Blaster" : [SoundFile effectWithName:@"Blaster"],
};
```

Now we have the sounds we have to tell SimpleSounds to load them. You access the singleton player and tell it to load your sounds. You can also pass an optional block of code that will be run after everything is loaded. For example in a game you could have a loading view which loads the assets, so in the block you could load the next set of assets or move to the game view.

```
[[SimpleSoundPlayer sharedPlayer] loadSounds:sounds withCompletion:^{
	
	// Something when the sounds are loaded
}];
```

Next we need to tell SimpleSounds which SKNode is listening to sounds, so all positional sounds will be played around this node. Here we set the target to a variable called `ship`. Once the above block has been called and the target is set, you can play sounds!

```
[[SimpleSoundPlayer sharedPlayer] setTarget:ship];
```

Optionally you can tweek the audible range property. This is the distance, in points, that your target SKNode can hear. Sounds played beyond that distance will not be heard. This could be useful if your character got in a vehicle they might need to be able to hear further that when they were just on foot.

```
[[SimpleSoundPlayer sharedPlayer] setAudibleRange:500.0f];
```

### Playing a sound

### Playing a sound with position


## Tips
- A Tip
