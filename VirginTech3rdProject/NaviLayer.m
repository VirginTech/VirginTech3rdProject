//
//  NaviLayer.m
//  VirginTech3rdProject
//
//  Created by VirginTech LLC. on 2014/12/14.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "NaviLayer.h"
#import "TitleScene.h"
#import "GameManager.h"
#import "MatchMakeScene.h"
#import "SelectScene.h"
#import "SoundManager.h"

#import "IAdLayer.h"
#import "IMobileLayer.h"
#import "AdGenerLayer.h"
#import "AdMobLayer_iOS.h"

@implementation NaviLayer

CGSize winSize;

CCNodeColor *background;
CCButton *pauseButton;
CCButton *resumeButton;
CCButton* titleButton;
CCButton* selectButton;

IAdLayer* iAdLayer;
IMobileLayer* iMobileAd;
//AdGenerLayer* adgene;
AdMobLayer_iOS* admob;

+ (NaviLayer *)scene
{
    return [[self alloc] init];
}

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    winSize=[[CCDirector sharedDirector]viewSize];
    
    // Create a colored background (Dark Grey)
    background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:0.7f]];
    background.visible=false;
    [self addChild:background];
    
    //画像読み込み
    [[CCSpriteFrameCache sharedSpriteFrameCache]removeSpriteFrames];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"btn_default.plist"];
    
    pauseButton=[CCButton buttonWithTitle:@""
                              spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"pause.png"]];
    pauseButton.scale=0.5;
    if([GameManager getMatchMode]==0){
        pauseButton.position = ccp(winSize.width-(pauseButton.contentSize.width*pauseButton.scale)/2,
                                   60+(pauseButton.contentSize.height*pauseButton.scale)/2);
    }else if([GameManager getMatchMode]==1){
        pauseButton.position = ccp(winSize.width-(pauseButton.contentSize.width*pauseButton.scale)/2,
                                   winSize.height/2);
    }else{
        pauseButton.position = ccp(winSize.width-(pauseButton.contentSize.width*pauseButton.scale)/2,
                                   60+(pauseButton.contentSize.height*pauseButton.scale)/2);
    }
    [pauseButton setTarget:self selector:@selector(onPauseClicked:)];
    [self addChild:pauseButton];
    
    resumeButton=[CCButton buttonWithTitle:@""
                               spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"resume.png"]];
    resumeButton.scale=0.5;
    if([GameManager getMatchMode]==0){
        resumeButton.position = ccp(winSize.width-(resumeButton.contentSize.width*pauseButton.scale)/2,
                                    60+(resumeButton.contentSize.height*resumeButton.scale)/2);
    }else if([GameManager getMatchMode]==1){
        resumeButton.position = ccp(winSize.width-(resumeButton.contentSize.width*pauseButton.scale)/2,
                                    winSize.height/2);
    }else{
        resumeButton.position = ccp(winSize.width-(resumeButton.contentSize.width*pauseButton.scale)/2,
                                    60+(resumeButton.contentSize.height*resumeButton.scale)/2);
    }
    [resumeButton setTarget:self selector:@selector(onResumeClicked:)];
    resumeButton.visible=false;
    [self addChild:resumeButton];
    
    //タイトルボタン
    if([GameManager getLocale]==1){
        titleButton = [CCButton buttonWithTitle:@"" spriteFrame:
                       [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"titleBtn.png"]];
    }else{
        titleButton = [CCButton buttonWithTitle:@"" spriteFrame:
                       [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"titleBtn_en.png"]];
    }
    titleButton.positionType = CCPositionTypeNormalized;
    if([GameManager getMatchMode]==0){//１人対戦
        titleButton.position = ccp(0.3f, 0.3f);
    }else if([GameManager getMatchMode]==1){//２人対戦
        titleButton.position = ccp(0.5f, 0.5f);
    }else{//ネット対戦
        titleButton.position = ccp(0.5f, 0.3f);
    }
    [titleButton setTarget:self selector:@selector(onTitleClicked:)];
    titleButton.scale=0.6;
    titleButton.visible=false;
    [self addChild:titleButton];
    
    //セレクトボタン
    if([GameManager getLocale]==1){
        selectButton = [CCButton buttonWithTitle:@"" spriteFrame:
                       [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"selectBtn.png"]];
    }else{
        selectButton = [CCButton buttonWithTitle:@"" spriteFrame:
                       [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"selectBtn_en.png"]];
    }
    selectButton.positionType = CCPositionTypeNormalized;
    selectButton.position = ccp(0.7f, 0.3f); // Top Right of screen
    [selectButton setTarget:self selector:@selector(onSelectClicked:)];
    selectButton.scale=0.6;
    selectButton.visible=false;
    [self addChild:selectButton];
    
    return self;
}

-(void)pause
{
    self.userInteractionEnabled = YES;
    [GameManager setPause:true];
    background.visible=true;
    pauseButton.visible=false;
    resumeButton.visible=true;
    titleButton.visible=true;
    if([GameManager getMatchMode]==0){
        selectButton.visible=true;
    }
    if([GameManager getLocale]==1){//日本語なら
        //i-Mobile広告(フッター、アイコン)
        iMobileAd=[[IMobileLayer alloc]init:false];
        [self addChild:iMobileAd];
    }else{//それ以外
        //iAd広告
        //iAdLayer=[[IAdLayer alloc]init];
        //self addChild:iAdLayer];
        
        admob=[[AdMobLayer_iOS alloc]init];
        [self addChild:admob];
    }

    /*/iPadならAdGene広告(iPadフッター)
    if([GameManager getDevice]==3){
        adgene=[[AdGenerLayer alloc]init];
        [self addChild:adgene];
    }*/
}

-(void)resume
{
    self.userInteractionEnabled = NO;
    [GameManager setPause:false];
    background.visible=false;
    pauseButton.visible=true;
    resumeButton.visible=false;
    titleButton.visible=false;
    selectButton.visible=false;
    
    //広告非表示
    if([GameManager getLocale]==1){//日本語なら
        [iMobileAd removeLayer];
    }else{
        //[iAdLayer removeLayer];
        [admob removeLayer];
    }
    /*if([GameManager getDevice]==3){
        [adgene removeLayer];
    }*/
}

- (void)onPauseClicked:(id)sender
{
    [self pause];
    //BGMポーズ
    [SoundManager pauseBGM];
    if([GameManager getMatchMode]==2){
        [MatchMakeScene sendData_Pause:true];
    }
}

- (void)onResumeClicked:(id)sender
{
    [self resume];
    //BGMレジューム
    [SoundManager resumeBGM];
    if([GameManager getMatchMode]==2){
        [MatchMakeScene sendData_Pause:false];
    }
}


- (void)onTitleClicked:(id)sender
{
    //サウンドストップ
    [SoundManager all_Stop];
    [SoundManager click_Effect];
    [[CCDirector sharedDirector] replaceScene:[TitleScene scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];
    //広告非表示
    if([GameManager getLocale]==1){//日本語なら
        [iMobileAd removeLayer];
    }else{
        //[iAdLayer removeLayer];
        [admob removeLayer];
    }
    /*if([GameManager getDevice]==3){
        [adgene removeLayer];
    }*/
    //インターステイシャル広告表示
    [ImobileSdkAds showBySpotID:@"359467"];
}

-(void)onSelectClicked:(id)sender
{
    //サウンドストップ
    [SoundManager all_Stop];
    [SoundManager click_Effect];
    [[CCDirector sharedDirector] replaceScene:[SelectScene scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];
    //広告非表示
    if([GameManager getLocale]==1){//日本語なら
        [iMobileAd removeLayer];
    }else{
        //[iAdLayer removeLayer];
        [admob removeLayer];
    }
    /*if([GameManager getDevice]==3){
        [adgene removeLayer];
    }*/
    //インターステイシャル広告表示
    [ImobileSdkAds showBySpotID:@"359467"];
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
