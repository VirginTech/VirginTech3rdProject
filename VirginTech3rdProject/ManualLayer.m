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
#import "GameManager.h"

#import "IAdLayer.h"
#import "IMobileLayer.h"
#import "AdGenerLayer.h"

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
    //CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];
    //[self addChild:background];

    if([GameManager getLocale]==1){//日本語なら
        //i-Mobile広告(フッター、アイコン)
        IMobileLayer* iMobileAd=[[IMobileLayer alloc]init:false];
        [self addChild:iMobileAd];
    }else{//それ以外
        //iAd広告
        IAdLayer* iAdLayer=[[IAdLayer alloc]init];
        [self addChild:iAdLayer];
    }

    /*/iPadならAdGene広告(iPadフッター)
    if([GameManager getDevice]==3){
        AdGenerLayer* adgene=[[AdGenerLayer alloc]init];
        [self addChild:adgene];
    }*/
    
    //スクロール背景画像拡大
    int length;
    if([GameManager getDevice]==2){//iPhone4は2048pxが限界・・・。
        length=6;//1920px
    }else{//iPhone5以降なら4096pxまで可能
        length=9;//2880px
    }
    UIImage *image = [UIImage imageNamed:@"bgLayer.png"];
    UIGraphicsBeginImageContext(CGSizeMake(winSize.width * length,winSize.height));
    [image drawInRect:CGRectMake(0, 0, winSize.width * length,winSize.height)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //スクロールビュー配置
    bgSpLayer=[CCSprite spriteWithCGImage:image.CGImage key:nil];
    scrollView=[[CCScrollView alloc]initWithContentNode:bgSpLayer];
    scrollView.verticalScrollEnabled=NO;
    [self addChild:scrollView];
    
    for(int i=0;i<9;i++)
    {
        //背景
        CCSprite* bg=[CCSprite spriteWithImageNamed:@"itemLayer.png"];
        bg.scale=0.6;
        bg.position=ccp(winSize.width/2*(((i+1)*2)-1),winSize.height/2);
        [bgSpLayer addChild:bg z:0];
        
        //ページ
        CCSprite* page=[CCSprite spriteWithImageNamed:[NSString stringWithFormat:@"manual_%02d.png",i+1]];
        page.scale=0.6;
        page.position=ccp(winSize.width/2*(((i+1)*2)-1),winSize.height/2);
        [bgSpLayer addChild:page z:1];
    }
    
    /*/1ページ
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
    [bgSpLayer addChild:page09];*/
    
    //画像読み込み
    [[CCSpriteFrameCache sharedSpriteFrameCache]removeSpriteFrames];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"btn_default.plist"];
    
    CCButton *titleButton;
    if([GameManager getLocale]==1){
        titleButton = [CCButton buttonWithTitle:@"" spriteFrame:
                                [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"titleBtn.png"]];
    }else{
        titleButton = [CCButton buttonWithTitle:@"" spriteFrame:
                                [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"titleBtn_en.png"]];
    }
    //titleButton.positionType = CCPositionTypeNormalized;
    titleButton.scale=0.6;
    titleButton.position = ccp(winSize.width-(titleButton.contentSize.width*titleButton.scale)/2,
                               winSize.height-titleButton.contentSize.height/2);
    [titleButton setTarget:self selector:@selector(onTitleClicked:)];
    [self addChild:titleButton];
        
    return self;
}

- (void)onTitleClicked:(id)sender
{
    // back to intro scene with transition
    [SoundManager click_Effect];
    //[[CCDirector sharedDirector] replaceScene:[TitleScene scene]
    //                           withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];
    [[CCDirector sharedDirector] replaceScene:[TitleScene scene] withTransition:
                                [CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:0.3f]];
    //インターステイシャル広告表示
    [ImobileSdkAds showBySpotID:@"359467"];
}

@end
