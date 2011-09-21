//
//  MPGamePad.m
//  MPGamePad
//
//  Created by hli on 9/15/11.
//  Copyright 2011 DEV. All rights reserved.
//

#import "MPGamePad.h"
#import "MPGamePadBall.h"
#import "MPGamePadDock.h"

@interface MPGamePad ()

- (void)touchTerminated;
- (void)updateSignal;
- (void)updateFromTouchPoint:(CGPoint)pt;

@end

@implementation MPGamePad
@synthesize delegate = mDelegate;
@synthesize power = mPower;
@synthesize angle = mAngle;
@synthesize direction = mDirection;
@synthesize accDirectionMask = mAccDirectionMask;
@synthesize activeRadius = mActiveRadius;
@synthesize padRadius = mPadRadius;
@synthesize pointRadius = mPointRadius;
@synthesize isTouched = mIsTouched;
@synthesize padSprite = mPadSprite;
@synthesize pointSprite = mPointSprite;
@synthesize continuousSignal = mContinuousSignal;
@synthesize padMode = mPadMode;

#pragma mark - Initialization
- (id)init {
    if ((self = [super init]))
    {
        mPointSprite = [[MPGamePadBall alloc] init];
        mPointRadius = mPointSprite.radius;
        mPointSprite.position = ccp(0,0);
        [self addChild:mPointSprite];
        
        mPadSprite = [[MPGamePadDock alloc] init];
        mPadRadius = mPadSprite.radius;
        mPadSprite.position = ccp(0,0);
        [self addChild:mPadSprite];
        
        mActiveRadius = 100.0f;
        
        self.padMode = MPGamePadModeOrthogonality;
        self.accDirectionMask = MPGamePadDirectionAll;
        self.continuousSignal = YES;
    }
    return self;
}

- (void)dealloc {
    [mPadSprite release];
    [mPointSprite release];
    [super dealloc];
}

- (void) onEnter  
{  
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];  
    [super onEnter];  
}  

- (void) onExit  
{  
    [[CCTouchDispatcher sharedDispatcher] removeDelegate:self];  
    [super onExit];  
}  

#pragma mark - CCTargetedTouchDelegate
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    //< Check if the Touch Point is Inside the mPadRadius
    CGPoint pt = [touch locationInView:[touch view]];
    pt = [[CCDirector sharedDirector] convertToGL:pt];
     
    if (ccpDistance(pt, [self.parent convertToWorldSpace:self.position]) < mActiveRadius) {
        [self updateFromTouchPoint:pt];
        
        if ([self.delegate respondsToSelector:@selector(onPadBegin:)])
        {
            [self.delegate onPadBegin:self];
        }
        
        if (self.continuousSignal)
        {
            [self schedule:@selector(updateSignal)];
        }
        
        return YES;
    }

    return NO;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event  
{  
	CGPoint touchPoint = [touch locationInView:[touch view]];
	touchPoint = [[CCDirector sharedDirector] convertToGL:touchPoint];
	
	if (self.isTouched) {
		[self updateFromTouchPoint:touchPoint];
	}
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event  
{
	if (self.isTouched) {
		mIsTouched = NO;

        if ([self.delegate respondsToSelector:@selector(onPadEnd:)])
        {
            [self.delegate onPadBegin:self];
        }
     
        [self touchTerminated];
    }
}

- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {
	if (self.isTouched) {
		mIsTouched = NO;
	
        if ([self.delegate respondsToSelector:@selector(onPadEnd:)])
        {
            [self.delegate onPadBegin:self];
        }

        [self touchTerminated];
    }
}

#pragma mark - Methods
- (void)updateFromTouchPoint:(CGPoint)pt {
    CGPoint spos = [self.parent convertToWorldSpace:self.position];
    float deltaRadius = (mPadRadius - mPointRadius);
    if (ccpDistance(pt, spos) > deltaRadius)
    {
        pt = ccpMult(ccpNormalize(ccpSub(ccp(pt.x-spos.x,pt.y-spos.y), ccp(0,0))), deltaRadius);
    }
    else 
    {
        pt = ccp(pt.x-spos.x,pt.y-spos.y);
    }
    
    mAngle = atan2(abs(pt.y), abs(pt.x));
    if (pt.x < 0 && pt.y > 0)
    {
        mAngle = M_PI - mAngle;
    }
    else if (pt.x < 0 && pt.y < 0)
    {
        mAngle += M_PI;
    }
    else if (pt.x > 0 && pt.y < 0)
    {
        mAngle = 2*M_PI - mAngle;
    }
    mPower = ccpDistance(pt, ccp(0,0))/deltaRadius;
    
    float directionDelta = M_PI/8.0f;
    int index = (int)floor(mAngle/directionDelta);
    if (self.padMode == MPGamePadModeEight)
    {
        index = (index + 1) % 16;
        mDirection = 1 << (int)floor(index/2.0f);    
    }
    else
    {
        index = (index + 2) % 16;
        mDirection = 1 << (int)floor(index/4.0f)*2;
    }

    NSLog(@"%f - %f - %d - %@", mPower, mAngle, index, [self nameForDirection:self.direction]);
    
    mIsTouched = YES;
    
    [self updateSignal];
    
    mPointSprite.position = pt;
}

- (void)updateSignal {
    if (self.direction & self.accDirectionMask)
    {
        if ([self.delegate respondsToSelector:@selector(onPadTapped:withDirection:)])
        {
            [self.delegate onPadTapped:self withDirection:self.direction];
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(onPadTapped:withAngle:withPower:)])
    {
        [self.delegate onPadTapped:self withAngle:self.angle withPower:self.power];
    }    
}

- (void)touchTerminated {
    if (self.continuousSignal)
    {
        [self unschedule:@selector(updateSignal)];
    }
    mPointSprite.position = ccp(0,0);    
}

- (void)setContinuousSignal:(BOOL)continuousSignal {
    mContinuousSignal = continuousSignal;
    if (!continuousSignal)
    {
        [self unschedule:@selector(updateSignal)];
    }
}

- (NSString *)nameForDirection:(MPGamePadDirection)direction {
    NSString *name = nil;
    switch (direction) {
        case MPGamePadDirectionLeft:
            name = @"Left";
            break;
        case MPGamePadDirectionUpLeft:
            name = @"UpLeft";
            break;
        case MPGamePadDirectionUp:
            name = @"Up";
            break;
        case MPGamePadDirectionUpRight:
            name = @"UpRight";
            break;
        case MPGamePadDirectionRight:
            name = @"Right";
            break;
        case MPGamePadDirectionDownLeft:
            name = @"DownLeft";
            break;
        case MPGamePadDirectionDown:
            name = @"Down";
            break;
        case MPGamePadDirectionDownRight:
            name = @"DownRight";
            break;
        default:
            break;
    }
    return name;
}

@end
