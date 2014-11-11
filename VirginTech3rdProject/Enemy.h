//
//  Enemy.h
//  VirginTech3rdProject
//
//  Created by VirginTech LLC. on 2014/11/11.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Enemy : CCSprite {
    
    CGPoint targetPos;
    float targetAngle;
    float targetDistance;
    CGPoint nextPos;
    float velocity;
}

@property CGPoint targetPos;

+(id)createEnemy:(CGPoint)pos;

@end
