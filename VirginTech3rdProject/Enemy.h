//
//  Enemy.h
//  VirginTech3rdProject
//
//  Created by VirginTech LLC. on 2014/11/11.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Enemy : CCSprite
{    
    NSMutableArray* frameArray;
    int animeCnt;
    
    int mode;//0:通常 1:逃避 2:追跡 3:戦闘
    float targetAngle;
    CGPoint nextPos;
    float velocity;
    int time1;
    int time2;
    bool stopFlg;
    int nearEnemyCnt;
    int ability;
    
    CCSprite* lifeGauge1;
    CCSprite* lifeGauge2;
    float maxLife;
    float nowRatio;

    //デバッグ用
    //CCLabelTTF* modeLabel;
    //CCLabelTTF* energyLabel;
}

@property int ability;
@property int nearEnemyCnt;
@property bool stopFlg;
@property int mode;
@property float targetAngle;

+(id)createEnemy:(CGPoint)pos;

@end
