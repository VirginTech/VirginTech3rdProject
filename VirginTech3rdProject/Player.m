//
//  Player.m
//  VirginTech3rdProject
//
//  Created by VirginTech LLC. on 2014/11/11.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "Player.h"
#import "GameManager.h"
#import "BasicMath.h"

@implementation Player

@synthesize ability;
@synthesize nearPlayerCnt;
@synthesize mode;
@synthesize targetAngle;
@synthesize stopFlg;

-(void)move_Schedule:(CCTime)dt
{
    nextPos=CGPointMake(self.position.x+velocity*cosf(targetAngle),self.position.y+velocity*sinf(targetAngle));
    self.rotation=[BasicMath getAngle_To_Degree:self.position ePos:nextPos];

    if(!stopFlg){
        self.position=nextPos;
    }
    
    if(mode==1){//回避タイム測定
        time1++;
        if(time1>100)mode=0;//回避解除
    }else{
        time1=0;
    }
    
    if(mode==2){//追跡タイム測定
        time2++;
        if(time2>300)mode=0;//追跡解除
    }else{
        time2=0;
    }
}

-(id)initWithPlayer:(CGPoint)pos
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"object_default.plist"];
     
    if(self=[super initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"player.png"]])
    {
        self.position=pos;
        self.scale=0.7;
        
        ability=10;
        mode=0;//通常モード
        stopFlg=false;
        velocity=0.2;
        nextPos=ccp(self.position.x,self.position.y+velocity);
        targetAngle=[BasicMath getAngle_To_Radian:self.position ePos:nextPos];

        [self schedule:@selector(move_Schedule:)interval:0.01];
    }
    return self;
}

+(id)createPlayer:(CGPoint)pos
{
    return [[self alloc] initWithPlayer:pos];
}

@end
