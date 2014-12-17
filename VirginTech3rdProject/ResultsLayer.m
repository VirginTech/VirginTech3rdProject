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

CCLabelTTF* pJudgLbl;
CCLabelTTF* eJudgLbl;

+ (ResultsLayer *)scene
{
    return [[self alloc] init];
}

- (id)initWithWinner:(bool)flg
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    winSize=[[CCDirector sharedDirector]viewSize];
    
    CCButton* titleButton = [CCButton buttonWithTitle:@"[タイトル]" fontName:@"Verdana-Bold" fontSize:15.0f];
    titleButton.positionType = CCPositionTypeNormalized;
    titleButton.position = ccp(0.5f, 0.3f); // Top Right of screen
    [titleButton setTarget:self selector:@selector(onTitleClicked:)];
    [self addChild:titleButton];
    
    //=================
    //勝利判定ラベル
    //=================
    
    pJudgLbl=[CCLabelTTF labelWithString:@"" fontName:@"Verdana-Bold" fontSize:50];
    eJudgLbl=[CCLabelTTF labelWithString:@"" fontName:@"Verdana-Bold" fontSize:50];
    
    if([GameManager getMatchMode]==0)//シングル
    {
        if(flg){
            pJudgLbl.string=@"勝利！";
        }else{
            pJudgLbl.string=@"敗北！";
        }
        pJudgLbl.position=ccp(winSize.width/2,winSize.height/2);
        [self addChild:pJudgLbl];
        
    }
    else if([GameManager getMatchMode]==1)//２人対戦
    {
        if(flg){
            pJudgLbl.string=@"勝利！";
            eJudgLbl.string=@"敗北！";
        }else{
            pJudgLbl.string=@"敗北！";
            eJudgLbl.string=@"勝利！";
        }
        pJudgLbl.position=ccp(winSize.width/2,winSize.height/2-50);
        [self addChild:pJudgLbl];
        eJudgLbl.position=ccp(winSize.width/2,winSize.height/2+50);
        eJudgLbl.rotation=180;
        [self addChild:eJudgLbl];
        
    }
    else//ネット対戦
    {
        if(flg){
            if([GameManager getHost]){
                pJudgLbl.string=@"勝利！";
                pJudgLbl.position=ccp(winSize.width/2,winSize.height/2);
                [self addChild:pJudgLbl];
            }else{
                eJudgLbl.string=@"敗北！";
                eJudgLbl.position=ccp(winSize.width/2,winSize.height/2);
                [self addChild:eJudgLbl];
            }
        }else{
            if([GameManager getHost]){
                pJudgLbl.string=@"敗北！";
                pJudgLbl.position=ccp(winSize.width/2,winSize.height/2);
                [self addChild:pJudgLbl];
            }else{
                eJudgLbl.string=@"勝利！";
                eJudgLbl.position=ccp(winSize.width/2,winSize.height/2);
                [self addChild:eJudgLbl];
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

@end
