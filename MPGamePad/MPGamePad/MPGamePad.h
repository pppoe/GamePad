//
//  MPGamePad.h
//  MPGamePad
//
//  Created by Haoxiang on 9/15/11.
//  Copyright 2011 DEV. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class MPGamePad;
@class MPGamePadBall;
@class MPGamePadDock;

typedef enum {
    MPGamePadDirectionRight     = 1 << 0,  
    MPGamePadDirectionUpRight   = 1 << 1,  
    MPGamePadDirectionUp        = 1 << 2,  
    MPGamePadDirectionUpLeft    = 1 << 3,  
    MPGamePadDirectionLeft      = 1 << 4,  
    MPGamePadDirectionDownLeft  = 1 << 5,  
    MPGamePadDirectionDown      = 1 << 6,  
    MPGamePadDirectionDownRight = 1 << 7,
    MPGamePadDirectionOrthogonality = MPGamePadDirectionUp | MPGamePadDirectionDown 
                                    | MPGamePadDirectionLeft | MPGamePadDirectionRight,
    MPGamePadDirectionAll = MPGamePadDirectionOrthogonality | MPGamePadDirectionUpLeft 
                            | MPGamePadDirectionUpRight | MPGamePadDirectionDownLeft | MPGamePadDirectionDownRight
} MPGamePadDirection;

typedef enum {
    MPGamePadModeOrthogonality,
    MPGamePadModeEight
} MPGamePadMode;

@protocol MPGamePadDelegate <NSObject>

@optional
- (void)onPadTapped:(MPGamePad *)gamePad withAngle:(float)angle withPower:(float)power;
- (void)onPadTapped:(MPGamePad *)gamePad withDirection:(MPGamePadDirection)padDirection;
- (void)onPadBegin:(MPGamePad *)gamePad;
- (void)onPadEnd:(MPGamePad *)gamePad;

@end

@interface MPGamePad : CCSprite <CCTargetedTouchDelegate> {
  
    MPGamePadMode mPadMode;
    int mAccDirectionMask; //< Accepted Directions
    id<MPGamePadDelegate> mDelegate;
    
    float   mPower;
    float   mAngle;
    CGPoint mPoint;
    MPGamePadDirection mDirection;
    
    float mActiveRadius;    //< Active Radius
    float mPadRadius;       //< Pad Radius
    float mPointRadius;     //< Touch Point Radius
    BOOL mIsTouched;
    
    //< Appearance
    MPGamePadDock *mPadSprite;
    MPGamePadBall *mPointSprite;
    
    BOOL mContinuousSignal; //< Keep Sending Direction Signal
}

@property (nonatomic, assign) MPGamePadMode padMode;
@property (nonatomic, assign) id<MPGamePadDelegate> delegate;
@property (nonatomic, readonly) float power;
@property (nonatomic, readonly) float angle; //< In Rad
@property (nonatomic, readonly) MPGamePadDirection direction;
@property (nonatomic, assign) int accDirectionMask;
@property (nonatomic, assign) float activeRadius;   //< Maximum, for touch detection
@property (nonatomic, assign) float padRadius;      //< As displayed
@property (nonatomic, assign) float pointRadius;    //< Minimum, as displayed
@property (nonatomic, readonly) BOOL isTouched;
@property (nonatomic, assign) BOOL continuousSignal;

@property (nonatomic, readonly) CCSprite *padSprite;
@property (nonatomic, readonly) CCSprite *pointSprite;

- (NSString *)nameForDirection:(MPGamePadDirection)direction;

@end
