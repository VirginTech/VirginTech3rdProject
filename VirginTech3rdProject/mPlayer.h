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
    
    int objId;
    int group;//青軍:0
    int mode;//0:通常 1:逃避 2:追跡 3:戦闘
    float targetAngle;
    CGPoint nextPos;
    float velocity;
    bool stopFlg;
    int nearPlayerCnt;
    int ability;
    int itemNum;
    
    int time1;
    int time2;
    
    CCSprite* lifeGauge1;
    CCSprite* lifeGauge2;
    float maxLife;
    float nowRatio;
    
    //デバッグ用
    //CCLabelTTF* energyLabel;
}

@property int objId;
@property int group;
@property int itemNum;
@property int ability;
@property int mode;
@property float targetAngle;
@property bool stopFlg;
@property int nearPlayerCnt;

+(id)createPlayer:(int)numId pos:(CGPoint)pos;

@end
