# Another OpenAL Sound Framework
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
- Some sort of music integration


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
### Something


## Tips
- A Tip
