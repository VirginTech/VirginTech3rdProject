//
//  CreditLayer.m
//  VirginTech3rdProject
//
//  Created by VirginTech LLC. on 2014/12/09.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "CreditLayer.h"
#import "TitleScene.h"
#import "SoundManager.h"

@implementation CreditLayer

CGSize winSize;

+ (CreditLayer *)scene
{
    return [[self alloc] init];
}

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    winSize=[[CCDirector sharedDirector]viewSize];
    
    //タイトル
    CCSprite* title=[CCSprite spriteWithImageNamed:@"title.png"];
    title.positionType = CCPositionTypeNormalized;
    title.position=ccp(0.5f,0.6f);
    title.scale=0.8;
    [self addChild:title];
    
    //Create a colored background (Dark Grey)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:0.8f]];
    [self addChild:background];
    
    
    
    CCButton *titleButton = [CCButton buttonWithTitle:@"[タイトル]" fontName:@"Verdana-Bold" fontSize:15.0f];
    titleButton.positionType = CCPositionTypeNormalized;
    titleButton.position = ccp(0.9f, 0.95f); // Top Right of screen
    [titleButton setTarget:self selector:@selector(onTitleClicked:)];
    [self addChild:titleButton];
    
    return self;
}

- (void)onTitleClicked:(id)sender
{
    // back to intro scene with transition
    [SoundManager click_Effect];
    [[CCDirector sharedDirector] replaceScene:[TitleScene scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];
    
}

@end
