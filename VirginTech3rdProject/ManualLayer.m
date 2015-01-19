//
//  ManualLayer.m
//  VirginTech3rdProject
//
//  Created by VirginTech LLC. on 2015/01/19.
//  Copyright 2015年 VirginTech LLC. All rights reserved.
//

#import "ManualLayer.h"
#import "TitleScene.h"
#import "SoundManager.h"

@implementation ManualLayer

CGSize winSize;
CCSprite* bgSpLayer;
CCScrollView* scrollView;

+ (ManualLayer *)scene
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

    //背景画像拡大
    UIImage *image = [UIImage imageNamed:@"bgLayer.png"];
    UIGraphicsBeginImageContext(CGSizeMake(winSize.width * 9,winSize.height));
    [image drawInRect:CGRectMake(0, 0, winSize.width * 9,winSize.height)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //スクロールビュー配置
    bgSpLayer=[CCSprite spriteWithCGImage:image.CGImage key:nil];
    scrollView=[[CCScrollView alloc]initWithContentNode:bgSpLayer];
    scrollView.verticalScrollEnabled=NO;
    [self addChild:scrollView];
    
    //1ページ
    CCSprite* page01=[CCSprite spriteWithImageNamed:@"manual_01.png"];
    page01.scale=0.6;
    page01.position=ccp(winSize.width/2 * 1,winSize.height/2);
    [bgSpLayer addChild:page01];
    
    //2ページ
    CCSprite* page02=[CCSprite spriteWithImageNamed:@"manual_02.png"];
    page02.scale=0.6;
    page02.position=ccp(winSize.width/2 * 3,winSize.height/2);
    [bgSpLayer addChild:page02];
    
    //3ページ
    CCSprite* page03=[CCSprite spriteWithImageNamed:@"manual_03.png"];
    page03.scale=0.6;
    page03.position=ccp(winSize.width/2 * 5,winSize.height/2);
    [bgSpLayer addChild:page03];

    //4ページ
    CCSprite* page04=[CCSprite spriteWithImageNamed:@"manual_04.png"];
    page04.scale=0.6;
    page04.position=ccp(winSize.width/2 * 7,winSize.height/2);
    [bgSpLayer addChild:page04];

    //5ページ
    CCSprite* page05=[CCSprite spriteWithImageNamed:@"manual_05.png"];
    page05.scale=0.6;
    page05.position=ccp(winSize.width/2 * 9,winSize.height/2);
    [bgSpLayer addChild:page05];

    //6ページ
    CCSprite* page06=[CCSprite spriteWithImageNamed:@"manual_06.png"];
    page06.scale=0.6;
    page06.position=ccp(winSize.width/2 * 11,winSize.height/2);
    [bgSpLayer addChild:page06];

    //7ページ
    CCSprite* page07=[CCSprite spriteWithImageNamed:@"manual_07.png"];
    page07.scale=0.6;
    page07.position=ccp(winSize.width/2 * 13,winSize.height/2);
    [bgSpLayer addChild:page07];

    //8ページ
    CCSprite* page08=[CCSprite spriteWithImageNamed:@"manual_08.png"];
    page08.scale=0.6;
    page08.position=ccp(winSize.width/2 * 15,winSize.height/2);
    [bgSpLayer addChild:page08];

    //9ページ
    CCSprite* page09=[CCSprite spriteWithImageNamed:@"manual_09.png"];
    page09.scale=0.6;
    page09.position=ccp(winSize.width/2 * 17,winSize.height/2);
    [bgSpLayer addChild:page09];
    
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
