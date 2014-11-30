//
//  mPlayer.h
//  VirginTech3rdProject
//
//  Created by VirginTech LLC. on 2014/11/29.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface mPlayer : CCSprite {
    
    float targetAngle;
    CGPoint nextPos;
    float velocity;
}

+(id)createPlayer:(CGPoint)pos;

@end
