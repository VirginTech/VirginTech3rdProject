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

@implementation NaviLayer

CGSize winSize;

CCNodeColor *background;
CCButton *pauseButton;
CCButton *resumeButton;
CCButton* titleButton;

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
    
    pauseButton = [CCButton buttonWithTitle:@"[ポーズ]" fontName:@"Verdana-Bold" fontSize:15.0f];
    pauseButton.positionType = CCPositionTypeNormalized;
    if([GameManager getMatchMode]==1){
        pauseButton.position = ccp(0.9f, 0.50f); // Top Right of screen
    }else{
        pauseButton.position = ccp(0.9f, 0.95f); // Top Right of screen
    }
    [pauseButton setTarget:self selector:@selector(onPauseClicked:)];
    [self addChild:pauseButton];
    
    resumeButton = [CCButton buttonWithTitle:@"[レジューム]" fontName:@"Verdana-Bold" fontSize:15.0f];
    resumeButton.positionType = CCPositionTypeNormalized;
    if([GameManager getMatchMode]==1){
        resumeButton.position = ccp(0.9f, 0.50f); // Top Right of screen
    }else{
        resumeButton.position = ccp(0.9f, 0.95f); // Top Right of screen
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
}

-(void)resume
{
    self.userInteractionEnabled = NO;
    [GameManager setPause:false];
    background.visible=false;
    pauseButton.visible=true;
    resumeButton.visible=false;
    titleButton.visible=false;
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
