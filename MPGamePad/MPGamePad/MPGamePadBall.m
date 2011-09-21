//
//  MPGamePadBall.m
//  MPGamePad
//
//  Created by hli on 9/15/11.
//  Copyright 2011 DEV. All rights reserved.
//

#import "MPGamePadBall.h"


@implementation MPGamePadBall
@synthesize radius = mRadius;

- (id)init {
    if ((self = [super init]))
    {
        mRadius = 20.0f;
    }
    return self;
}

- (void)draw {

    glLineWidth(1.0f);
	glColor4ub(0, 255, 0, 255);
    ccDrawCircle(ccp(0,0), self.radius, 0, 360, NO);

}

@end
