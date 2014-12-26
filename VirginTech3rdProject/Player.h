//
//  Player.h
//  VirginTech3rdProject
//
//  Created by VirginTech LLC. on 2014/11/11.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Player : CCSprite
{    
    NSMutableArray* frameArray;
    int animeCnt;

    int mode;//0:通常 1:逃避 2:追跡 3:戦闘 4:陣地攻撃
    float targetAngle;
    CGPoint nextPos;
    float velocity;
    int time1;
    int time2;
    bool stopFlg;
    int nearPlayerCnt;
    int ability;
    int itemNum;
    
    CCSprite* lifeGauge1;
    CCSprite* lifeGauge2;
    float maxLife;
    float nowRatio;
    
    id targetObject;
    
    //パーティクル
    CCParticleSystem* shieldParticle;
    CCParticleSystem* speedupParticle;
    
    //デバッグ用
    //CCLabelTTF* modeLabel;
    //CCLabelTTF* energyLabel;
    
}

@property id targetObject;
@property float velocity;
@property int itemNum;
@property int ability;
@property int nearPlayerCnt;
@property bool stopFlg;
@property int mode;
@property float targetAngle;

+(id)createPlayer:(CGPoint)pos;

//-(void)setTargetEnemy:(id)_enemy;

@end
