//
//  Fortress.m
//  VirginTech3rdProject
//
//  Created by VirginTech LLC. on 2014/11/11.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "Fortress.h"
#import "GameManager.h"

@implementation Fortress

@synthesize ability;

-(void)status_Schedule:(CCTime)dt
{
    //ライフゲージ
    nowRatio=(100/maxLife)*ability;
    lifeGauge2.scaleX=nowRatio*0.01;
    lifeGauge2.position=CGPointMake((nowRatio*0.01)*(lifeGauge2.contentSize.width/2), lifeGauge2.contentSize.height/2);
    
    //デバッグ用
    //energyLabel.string=[NSString stringWithFormat:@"%d",ability];
}

-(void)start_Animation
{
    if(animeCnt==0){
        [self schedule:@selector(animation_Schedule:)interval:0.15 repeat:1 delay:0.0f];
    }
}

-(void)animation_Schedule:(CCTime)dt
{
    if(animeCnt%2==0){
        self.position=ccp(self.position.x+5,fPos.y);
        animeCnt++;
    }else{
        self.position=ccp(fPos.x,fPos.y);
        animeCnt=0;
    }
}

-(id)initWithFortress:(CGPoint)pos type:(int)type
{
    [[CCSpriteFrameCache sharedSpriteFrameCache]removeSpriteFrames];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"fortress_default.plist"];
    
    NSString* fileName;
    NSString* fileName2;
    if(type==0){//我
        fileName=@"fortress_01.png";//青
        fileName2=@"lifegauge3.png";
    }else{//敵
        fileName=@"fortress_00.png";//赤
        fileName2=@"lifegauge2.png";
    }

    if(self=[super initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:fileName]])
    {
        fPos=pos;
        self.position=pos;
        ability=500;
        animeCnt=0;
        
        //体力ゲージ描画
        maxLife=ability;
        lifeGauge1=[CCSprite spriteWithSpriteFrame:
                    [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"lifegauge1.png"]];
        lifeGauge1.position=CGPointMake(self.contentSize.width/2, self.contentSize.height/2);
        lifeGauge1.scale=0.7;
        [self addChild:lifeGauge1];
        
        lifeGauge2=[CCSprite spriteWithSpriteFrame:
                    [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:fileName2]];
        nowRatio=(100/maxLife)*ability;
        lifeGauge2.scaleX=nowRatio*0.01;
        lifeGauge2.position=CGPointMake((nowRatio*0.01)*(lifeGauge2.contentSize.width/2), lifeGauge2.contentSize.height/2);
        [lifeGauge1 addChild:lifeGauge2];
        
        [self schedule:@selector(status_Schedule:)interval:0.1];
        
        /*/デバッグ用
        energyLabel=[CCLabelTTF labelWithString:
                     [NSString stringWithFormat:@"%d",ability]fontName:@"Verdana-Bold" fontSize:15];
        energyLabel.position=ccp(self.contentSize.width/2,self.contentSize.height/2);
        energyLabel.color=[CCColor whiteColor];
        [self addChild:energyLabel];*/
        
    }
    return self;
}

+(id)createFortress:(CGPoint)pos type:(int)type
{
    return [[self alloc] initWithFortress:pos type:type];
}

@end
