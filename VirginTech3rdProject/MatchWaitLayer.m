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

@synthesize playerLbl;
@synthesize enemyLbl;
@synthesize playerReadyFlg;
@synthesize enemyReadyFlg;

CGSize winSize;

CCButton* playerBtn;
CCButton* enemyBtn;

int readyCnt;

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
    
    //初期化
    playerReadyFlg=false;
    enemyReadyFlg=false;
    readyCnt=0;
    
    if([GameManager getMatchMode]==1)//リアル対戦モード
    {
        playerBtn=[CCButton buttonWithTitle:NSLocalizedString(@"YouReady",NULL) fontName:@"Verdana-Bold" fontSize:25];
        playerBtn.position=ccp(winSize.width/2,winSize.height*0.35);
        playerBtn.name=[NSString stringWithFormat:@"%d",0];
        [playerBtn setTarget:self selector:@selector(onReadyClicked:)];
        [self addChild:playerBtn];
        
        playerLbl=[CCLabelTTF labelWithString:@"" fontName:@"Verdana-Bold" fontSize:25];
        playerLbl.position=ccp(winSize.width/2,winSize.height*0.35);
        [self addChild:playerLbl];
        
        enemyBtn=[CCButton buttonWithTitle:NSLocalizedString(@"YouReady",NULL) fontName:@"Verdana-Bold" fontSize:25];
        enemyBtn.position=ccp(winSize.width/2,winSize.height*0.65);
        enemyBtn.rotation=180;
        enemyBtn.name=[NSString stringWithFormat:@"%d",1];
        [enemyBtn setTarget:self selector:@selector(onReadyClicked:)];
        [self addChild:enemyBtn];

        enemyLbl=[CCLabelTTF labelWithString:@"" fontName:@"Verdana-Bold" fontSize:25];
        enemyLbl.position=ccp(winSize.width/2,winSize.height*0.65);
        enemyLbl.rotation=180;
        [self addChild:enemyLbl];
    }
    else if([GameManager getMatchMode]==2)//ネット対戦モード
    {
        if([GameManager getHost]){//サーバー
            playerBtn=[CCButton buttonWithTitle:NSLocalizedString(@"YouReady",NULL) fontName:@"Verdana-Bold" fontSize:25];
            playerBtn.position=ccp(winSize.width/2,winSize.height*0.35);
            //playerBtn.name=[NSString stringWithFormat:@"%d",0];
            [playerBtn setTarget:self selector:@selector(onReadyClicked:)];
            [self addChild:playerBtn];
            
            playerLbl=[CCLabelTTF labelWithString:@"" fontName:@"Verdana-Bold" fontSize:25];
            playerLbl.position=ccp(winSize.width/2,winSize.height*0.35);
            [self addChild:playerLbl];

        }else{//クライアント
            enemyBtn=[CCButton buttonWithTitle:NSLocalizedString(@"YouReady",NULL) fontName:@"Verdana-Bold" fontSize:25];
            enemyBtn.position=ccp(winSize.width/2,winSize.height*0.35);
            //enemyBtn.name=[NSString stringWithFormat:@"%d",1];
            [enemyBtn setTarget:self selector:@selector(onReadyClicked:)];
            [self addChild:enemyBtn];
            
            enemyLbl=[CCLabelTTF labelWithString:@"" fontName:@"Verdana-Bold" fontSize:25];
            enemyLbl.position=ccp(winSize.width/2,winSize.height*0.35);
            [self addChild:enemyLbl];

        }
    }
    
    /*CCButton *backButton = [CCButton buttonWithTitle:@"[タイトル]" fontName:@"Verdana-Bold" fontSize:15.0f];
    backButton.positionType = CCPositionTypeNormalized;
    backButton.position = ccp(0.9f, 0.95f); // Top Right of screen
    [backButton setTarget:self selector:@selector(onBackClicked:)];
    [self addChild:backButton];*/
    
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
            playerLbl.fontSize=20;
            playerLbl.string=NSLocalizedString(@"OpponentWait",NULL);
        }else{
            enemyBtn.visible=false;
            enemyReadyFlg=true;
            enemyLbl.fontSize=20;
            enemyLbl.string=NSLocalizedString(@"OpponentWait",NULL);
        }
        //対戦開始！
        if(playerReadyFlg && enemyReadyFlg){
            playerLbl.fontSize=50;
            playerLbl.string=NSLocalizedString(@"BattleStrart",NULL);
            enemyLbl.fontSize=50;
            enemyLbl.string=NSLocalizedString(@"BattleStrart",NULL);
            [self readyWaitStart];
            //[self removeFromParentAndCleanup:YES];//レイヤー消去
        }
    }
    else if([GameManager getMatchMode]==2)//ネット対戦モード
    {
        if([GameManager getHost]){//ホスト青プレイヤー
            playerBtn.visible=false;
            playerReadyFlg=true;//準備よし
            playerLbl.fontSize=20;
            playerLbl.string=NSLocalizedString(@"OpponentWait",NULL);
            //NSLog(@"ホスト準備よし");
        }else{
            enemyBtn.visible=false;
            enemyReadyFlg=true;
            enemyLbl.fontSize=20;
            enemyLbl.string=NSLocalizedString(@"OpponentWait",NULL);
            //NSLog(@"クライアント準備よし");
        }
    }
}

-(void)readyWaitStart
{
    [self schedule:@selector(ready_Wait_Schedule:) interval:1.0];
}

-(void)ready_Wait_Schedule:(CCTime)dt
{
    readyCnt++;
    if(readyCnt>1){
        [self unschedule:@selector(ready_Wait_Schedule:)];
        [self removeFromParentAndCleanup:YES];//レイヤー消去
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
