//
//  mPlayer.m
//  VirginTech3rdProject
//
//  Created by VirginTech LLC. on 2014/11/29.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "mPlayer.h"
#import "BasicMath.h"
#import "GameManager.h"

@implementation mPlayer

@synthesize objId;
@synthesize group;
@synthesize itemNum;
@synthesize ability;
@synthesize mode;
@synthesize targetAngle;
@synthesize stopFlg;
@synthesize nearPlayerCnt;

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

-(void)status_Schedule:(CCTime)dt
{
    //デバッグ用
    energyLabel.string=[NSString stringWithFormat:@"%d",ability];
}

-(id)initWithPlayer:(int)numId pos:(CGPoint)pos
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"object_default.plist"];
    
    if(self=[super initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"player.png"]])
    {
        objId=numId;
        group=0;
        self.position=pos;
        self.scale=0.7;
        velocity=0.2f;
        ability=10;
        mode=0;//通常モード
        stopFlg=false;
        itemNum=[GameManager getItem];//アイテム取得(0)
        
        if([GameManager getHost]){
            nextPos=ccp(self.position.x,self.position.y+velocity);
        }else{
            nextPos=ccp(self.position.x,self.position.y-velocity);
        }
        
        targetAngle=[BasicMath getAngle_To_Radian:self.position ePos:nextPos];
        
        [self schedule:@selector(move_Schedule:)interval:0.01];
        [self schedule:@selector(status_Schedule:)interval:0.1];
        
        energyLabel=[CCLabelTTF labelWithString:
                     [NSString stringWithFormat:@"%d",ability]fontName:@"Verdana-Bold" fontSize:15];
        energyLabel.position=ccp(self.contentSize.width/2,self.contentSize.height/2);
        energyLabel.color=[CCColor whiteColor];
        [self addChild:energyLabel];
        
    }
    return self;
}

+(id)createPlayer:(int)numId pos:(CGPoint)pos
{
    return [[self alloc] initWithPlayer:numId pos:pos];
}

@end
