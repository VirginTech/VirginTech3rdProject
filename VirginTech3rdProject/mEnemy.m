//
//  mEnemy.m
//  VirginTech3rdProject
//
//  Created by VirginTech LLC. on 2014/11/29.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "mEnemy.h"
#import "BasicMath.h"
#import "GameManager.h"

@implementation mEnemy

@synthesize objId;
@synthesize group;
@synthesize ability;
@synthesize mode;
@synthesize targetAngle;
@synthesize stopFlg;
@synthesize nearEnemyCnt;

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

-(id)initWithEnemy:(int)numId pos:(CGPoint)pos
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"object_default.plist"];
    
    if(self=[super initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"enemy.png"]])
    {
        objId=numId;
        group=1;
        self.position=pos;
        self.scale=0.7;
        velocity=0.2;
        ability=10;
        mode=0;//通常モード
        stopFlg=false;
        
        if([GameManager getHost]){
            nextPos=ccp(self.position.x,self.position.y-velocity);
        }else{
            nextPos=ccp(self.position.x,self.position.y+velocity);
        }
        
        targetAngle=[BasicMath getAngle_To_Radian:self.position ePos:nextPos];
        
        [self schedule:@selector(move_Schedule:)interval:0.01];
    }
    return self;
}

+(id)createEnemy:(int)numId pos:(CGPoint)pos
{
    return [[self alloc] initWithEnemy:numId pos:pos];
}

@end
