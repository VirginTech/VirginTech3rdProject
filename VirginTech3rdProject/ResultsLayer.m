//
//  ResultsLayer.m
//  VirginTech3rdProject
//
//  Created by VirginTech LLC. on 2014/12/17.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "ResultsLayer.h"
#import "GameManager.h"
#import "TitleScene.h"

@implementation ResultsLayer

CGSize winSize;

CCSprite* victorySpr;
CCSprite* defeatSpr;

+ (ResultsLayer *)scene
{
    return [[self alloc] init];
}

- (id)initWithWinner:(bool)flg
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    self.userInteractionEnabled = YES;
    winSize=[[CCDirector sharedDirector]viewSize];
    
    // Create a colored background (Dark Grey)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:0.5f]];
    [self addChild:background];
    
    CCButton* titleButton = [CCButton buttonWithTitle:@"[タイトル]" fontName:@"Verdana-Bold" fontSize:15.0f];
    titleButton.positionType = CCPositionTypeNormalized;
    titleButton.position = ccp(0.5f, 0.3f); // Top Right of screen
    [titleButton setTarget:self selector:@selector(onTitleClicked:)];
    [self addChild:titleButton];
    
    //=================
    //勝利判定ラベル
    //=================
    
    //画像読込み
    [[CCSpriteFrameCache sharedSpriteFrameCache]removeSpriteFrames];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"results_default.plist"];
    
    victorySpr=[CCSprite spriteWithSpriteFrame:
                        [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"victory_jp.png"]];
    
    defeatSpr=[CCSprite spriteWithSpriteFrame:
                        [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"defeat_jp.png"]];
    victorySpr.visible=false;
    defeatSpr.visible=false;
    
    if([GameManager getMatchMode]==0)//シングル
    {
        if(flg){
            victorySpr.visible=true;
            victorySpr.position=ccp(winSize.width/2,winSize.height/2);
            [self addChild:victorySpr];
        }else{
            defeatSpr.visible=true;
            defeatSpr.position=ccp(winSize.width/2,winSize.height/2);
            [self addChild:defeatSpr];
        }
    }
    else if([GameManager getMatchMode]==1)//２人対戦
    {
        victorySpr.visible=true;
        defeatSpr.visible=true;
        
        if(flg){
            victorySpr.position=ccp(winSize.width/2,winSize.height/2-50);
            [self addChild:victorySpr];
            
            defeatSpr.position=ccp(winSize.width/2,winSize.height/2+50);
            defeatSpr.rotation=180;
            [self addChild:defeatSpr];
        }else{
            defeatSpr.position=ccp(winSize.width/2,winSize.height/2-50);
            [self addChild:defeatSpr];
            
            victorySpr.position=ccp(winSize.width/2,winSize.height/2+50);
            victorySpr.rotation=180;
            [self addChild:victorySpr];
        }
        
    }
    else//ネット対戦
    {
        if(flg){
            if([GameManager getHost]){
                victorySpr.visible=true;
                victorySpr.position=ccp(winSize.width/2,winSize.height/2);
                [self addChild:victorySpr];
            }else{
                defeatSpr.visible=true;
                defeatSpr.position=ccp(winSize.width/2,winSize.height/2);
                [self addChild:defeatSpr];
            }
        }else{
            if([GameManager getHost]){
                defeatSpr.visible=true;
                defeatSpr.position=ccp(winSize.width/2,winSize.height/2);
                [self addChild:defeatSpr];
            }else{
                victorySpr.visible=true;
                victorySpr.position=ccp(winSize.width/2,winSize.height/2);
                [self addChild:victorySpr];
            }
        }
    }
    return self;
}

- (void)onTitleClicked:(id)sender
{
    // back to intro scene with transition
    [[CCDirector sharedDirector] replaceScene:[TitleScene scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];
}

-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
}

-(void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
}

-(void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
}

@end
