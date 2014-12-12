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
        self.position=pos;
        ability=1000;
        
        //体力ゲージ描画
        maxLife=ability;
        lifeGauge1=[CCSprite spriteWithSpriteFrame:
                    [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"lifegauge1.png"]];
        lifeGauge1.position=CGPointMake(self.contentSize.width/2, self.contentSize.height/2);
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
