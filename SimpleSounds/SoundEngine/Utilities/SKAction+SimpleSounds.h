//
//  SKAction+SimpleSounds.h
//  SimpleSounds
//
//  Created by Robert Anderson on 18/03/2015.
//  Copyright (c) 2015 Rob Anderson. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SKAction (SimpleSounds)

+ (instancetype)playSoundEffectWithTarget:(NSString *)effectName;
+ (instancetype)playSoundEffect:(NSString *)effectName volume:(double)volume;

@end
