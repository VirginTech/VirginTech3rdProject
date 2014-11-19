//
//  SelectScene.m
//  VirginTech3rdProject
//
//  Created by VirginTech LLC. on 2014/11/18.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "SelectScene.h"
#import "TitleScene.h"
#import "GameManager.h"
#import "StageScene.h"

@implementation SelectScene

CGSize winSize;

+ (SelectScene *)scene
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
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];
    [self addChild:background];
    
    //セレクトレヴェルボタン
    CGPoint btnPos=CGPointMake(70, winSize.height-50);
    for(int i=0;i<50;i++){
        CCButton* selectBtn=[CCButton buttonWithTitle:
                             [NSString stringWithFormat:@"%02d",i+1] fontName:@"Verdana-Bold" fontSize:25];
        if(i%5!=0){
            btnPos=CGPointMake(btnPos.x+50, btnPos.y);
        }else{
            btnPos=CGPointMake(70, btnPos.y-40);
        }
        selectBtn.position = CGPointMake(btnPos.x, btnPos.y);
        selectBtn.name=[NSString stringWithFormat:@"%d",i+1];
        [selectBtn setTarget:self selector:@selector(onStageLevel:)];
        [self addChild:selectBtn];
    }
    
    
    CCButton *backButton = [CCButton buttonWithTitle:@"[タイトル]" fontName:@"Verdana-Bold" fontSize:15.0f];
    backButton.positionType = CCPositionTypeNormalized;
    backButton.position = ccp(0.9f, 0.95f); // Top Right of screen
    [backButton setTarget:self selector:@selector(onBackClicked:)];
    [self addChild:backButton];
    
    return self;
}

- (void)onStageLevel:(id)sender
{
    // back to intro scene with transition
    CCButton* button =(CCButton*)sender;
    [GameManager setStageLevel:[[button name]intValue]];
    
    [[CCDirector sharedDirector] replaceScene:[StageScene scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];
    
}

- (void)onBackClicked:(id)sender
{
    // back to intro scene with transition
    [[CCDirector sharedDirector] replaceScene:[TitleScene scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];
    
}

@end
