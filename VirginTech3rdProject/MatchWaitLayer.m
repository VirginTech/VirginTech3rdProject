//
//  MatchWaitLayer.m
//  VirginTech3rdProject
//
//  Created by VirginTech LLC. on 2014/12/09.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "MatchWaitLayer.h"
#import "TitleScene.h"
#import "GameManager.h"

@implementation MatchWaitLayer

@synthesize playerReadyFlg;
@synthesize enemyReadyFlg;

CGSize winSize;
CCButton* playerBtn;
CCButton* enemyBtn;

+ (MatchWaitLayer *)scene
{
    return [[self alloc] init];
}

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    self.userInteractionEnabled = YES;
    self.multipleTouchEnabled = YES; /*マルチタッチ検出を有効化*/
    winSize=[[CCDirector sharedDirector]viewSize];
    
    playerReadyFlg=false;
    enemyReadyFlg=false;
    
    if([GameManager getMatchMode]==1)//リアル対戦モード
    {
        playerBtn=[CCButton buttonWithTitle:@"[準備よし]" fontName:@"Verdana-Bold" fontSize:25];
        playerBtn.position=ccp(winSize.width/2,winSize.height*0.35);
        playerBtn.name=[NSString stringWithFormat:@"%d",0];
        [playerBtn setTarget:self selector:@selector(onReadyClicked:)];
        [self addChild:playerBtn];
        
        enemyBtn=[CCButton buttonWithTitle:@"[準備よし]" fontName:@"Verdana-Bold" fontSize:25];
        enemyBtn.position=ccp(winSize.width/2,winSize.height*0.65);
        enemyBtn.rotation=180;
        enemyBtn.name=[NSString stringWithFormat:@"%d",1];
        [enemyBtn setTarget:self selector:@selector(onReadyClicked:)];
        [self addChild:enemyBtn];
    }
    else if([GameManager getMatchMode]==2)//ネット対戦モード
    {
        if([GameManager getHost]){//サーバー
            playerBtn=[CCButton buttonWithTitle:@"[準備よし]" fontName:@"Verdana-Bold" fontSize:25];
            playerBtn.position=ccp(winSize.width/2,winSize.height*0.35);
            //playerBtn.name=[NSString stringWithFormat:@"%d",0];
            [playerBtn setTarget:self selector:@selector(onReadyClicked:)];
            [self addChild:playerBtn];
        }else{//クライアント
            enemyBtn=[CCButton buttonWithTitle:@"[準備よし]" fontName:@"Verdana-Bold" fontSize:25];
            enemyBtn.position=ccp(winSize.width/2,winSize.height*0.35);
            //enemyBtn.name=[NSString stringWithFormat:@"%d",1];
            [enemyBtn setTarget:self selector:@selector(onReadyClicked:)];
            [self addChild:enemyBtn];
        }
    }
    
    CCButton *backButton = [CCButton buttonWithTitle:@"[タイトル]" fontName:@"Verdana-Bold" fontSize:15.0f];
    backButton.positionType = CCPositionTypeNormalized;
    backButton.position = ccp(0.9f, 0.95f); // Top Right of screen
    [backButton setTarget:self selector:@selector(onBackClicked:)];
    [self addChild:backButton];
    
    return self;
}

- (void)onReadyClicked:(id)sender
{
    CCButton* btn=(CCButton*)sender;
    int num=[btn.name intValue];
    
    if([GameManager getMatchMode]==1)//リアル対戦モード
    {
        if(num==0){//プレイヤー
            playerBtn.visible=false;
            playerReadyFlg=true;//準備よし
        }else{
            enemyBtn.visible=false;
            enemyReadyFlg=true;
        }
        //対戦開始！
        if(playerReadyFlg && enemyReadyFlg){
            [self removeFromParentAndCleanup:YES];//レイヤー消去
        }
    }
    else if([GameManager getMatchMode]==2)//ネット対戦モード
    {
        if([GameManager getHost]){//ホスト青プレイヤー
            playerBtn.visible=false;
            playerReadyFlg=true;//準備よし
            //NSLog(@"ホスト準備よし");
        }else{
            enemyBtn.visible=false;
            enemyReadyFlg=true;
            //NSLog(@"クライアント準備よし");
        }
    }
}

- (void)onBackClicked:(id)sender
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
