//
//  SimpleSoundsTests.m
//  SimpleSoundsTests
//
//  Created by Robert Anderson on 07/03/2015.
//  Copyright (c) 2015 Rob Anderson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <SpriteKit/SpriteKit.h>

#import "SimpleSoundPlayer.h"



#define kTestAudibleRange			200.0f



@interface SimpleSoundPlayerTests : XCTestCase 
@end

@implementation SimpleSoundPlayerTests {
	
	SimpleSoundPlayer *_testPlayer;
	SKNode *_testTarget;
}

- (void)setUp {
    [super setUp];
    
	_testTarget = [SKNode node];
	_testPlayer = [SimpleSoundPlayer new];
	[_testPlayer setTarget:_testTarget];
	[_testPlayer setAudibleRange:kTestAudibleRange];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void)testCreation {
	
	XCTAssertNotNil(_testPlayer);
}





@end
