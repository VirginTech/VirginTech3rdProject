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

@implementation NaviLayer

CGSize winSize;

CCNodeColor *background;
CCButton *pauseButton;
CCButton *resumeButton;
CCButton* titleButton;
CCButton* selectButton;

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
                                   (pauseButton.contentSize.height*pauseButton.scale)/2);
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
                                    (resumeButton.contentSize.height*resumeButton.scale)/2);
    }
    [resumeButton setTarget:self selector:@selector(onResumeClicked:)];
    resumeButton.visible=false;
    [self addChild:resumeButton];
    
    titleButton = [CCButton buttonWithTitle:@"[タイトル]" fontName:@"Verdana-Bold" fontSize:15.0f];
    titleButton.positionType = CCPositionTypeNormalized;
    titleButton.position = ccp(0.5f, 0.3f); // Top Right of screen
    [titleButton setTarget:self selector:@selector(onTitleClicked:)];
    titleButton.visible=false;
    [self addChild:titleButton];
    
    //セレクトシーン
    selectButton = [CCButton buttonWithTitle:@"[セレクト]" fontName:@"Verdana-Bold" fontSize:15.0f];
    selectButton.positionType = CCPositionTypeNormalized;
    selectButton.position = ccp(0.5f, 0.25f); // Top Right of screen
    [selectButton setTarget:self selector:@selector(onSelectClicked:)];
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
}

- (void)onPauseClicked:(id)sender
{
    [self pause];
    if([GameManager getMatchMode]==2){
        [MatchMakeScene sendData_Pause:true];
    }
}

- (void)onResumeClicked:(id)sender
{
    [self resume];
    if([GameManager getMatchMode]==2){
        [MatchMakeScene sendData_Pause:false];
    }
}


- (void)onTitleClicked:(id)sender
{
    // back to intro scene with transition
    [[CCDirector sharedDirector] replaceScene:[TitleScene scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];
}

-(void)onSelectClicked:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[SelectScene scene]
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
