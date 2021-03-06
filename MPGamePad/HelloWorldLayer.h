//
//  HelloWorldLayer.h
//  MPGamePad
//
//  Created by Haoxiang on 9/15/11.
//  Copyright DEV 2011. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

@class MPGamePad;
@class MPGamePadBall;

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer
{
    MPGamePad *mGamePad;
    MPGamePadBall *mTestBall;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
