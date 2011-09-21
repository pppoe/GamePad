//
//  HelloWorldLayer.m
//  MPGamePad
//
//  Created by Haoxiang on 9/15/11.
//  Copyright DEV 2011. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import "MPGamePad.h"
#import "MPGamePadBall.h"

@interface HelloWorldLayer () <MPGamePadDelegate>
@end

// HelloWorldLayer implementation
@implementation HelloWorldLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		
        mGamePad = [[MPGamePad alloc] init];
        mGamePad.delegate = self;
        mGamePad.position = ccp(100, 100);        
		[self addChild:mGamePad];
        
        self.isTouchEnabled = YES;
        
        CGSize sz = [[CCDirector sharedDirector] winSize];
        
        mTestBall = [[MPGamePadBall alloc] init];
        mTestBall.position = ccp(sz.width/2.0f, sz.height/2.0f);
        [self addChild:mTestBall];
	}
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
    [mGamePad release];
    [mTestBall release];
	[super dealloc];
}

#pragma mark - MPGamePadDelegate
- (void)onPadTapped:(MPGamePad *)gamePad withAngle:(float)angle withPower:(float)power {
    
}

- (void)onPadTapped:(MPGamePad *)gamePad withDirection:(MPGamePadDirection)padDirection {
    CGPoint pt = mTestBall.position;
    switch (padDirection) {
        case MPGamePadDirectionUp:
            pt = ccp(pt.x, pt.y + gamePad.power);
            break;
        case MPGamePadDirectionDown:
            pt = ccp(pt.x, pt.y - gamePad.power);
            break;
        case MPGamePadDirectionLeft:
            pt = ccp(pt.x - gamePad.power, pt.y);
            break;
        case MPGamePadDirectionRight:
            pt = ccp(pt.x + gamePad.power, pt.y);
            break;            
        default:
            break;
    }
    CGSize sz = [[CCDirector sharedDirector] winSize];
    pt.x = (pt.x < 0 ? sz.width : (pt.x > sz.width ? 0 : pt.x));
    pt.y = (pt.y < 0 ? sz.height : (pt.y > sz.height ? 0 : pt.y));
    mTestBall.position = pt;
}

- (void)onPadBegin:(MPGamePad *)gamePad {
    
}

- (void)onPadEnd:(MPGamePad *)gamePad {
    
}

@end
