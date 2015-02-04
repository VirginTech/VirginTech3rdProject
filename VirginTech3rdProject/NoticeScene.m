//
//  NoticeScene.m
//  VirginTech3rdProject
//
//  Created by VirginTech LLC. on 2015/02/04.
//  Copyright 2015年 VirginTech LLC. All rights reserved.
//

#import "NoticeScene.h"
#import "TitleScene.h"
#import "GameManager.h"
#import "SoundManager.h"

@implementation NoticeScene

CGSize winSize;
UIWebView *webview;

+ (NoticeScene *)scene
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
    
    //WebViewの生成
    if([GameManager getDevice]==3){//iPad
        webview = [[UIWebView alloc] initWithFrame:CGRectMake(winSize.width*2*0.1,winSize.height*2*0.1,
                                                            winSize.width*2*0.8, winSize.height*2*0.8)];
    }else{
        webview = [[UIWebView alloc] initWithFrame:CGRectMake(winSize.width*0.1,winSize.height*0.1,
                                                            winSize.width*0.8, winSize.height*0.8)];
    }
    //delegateの使い方はお好みで
    webview.delegate = self;
    //参照先URLの設定
    NSURL *url = [NSURL URLWithString:@"http://www.virgintech.co.jp/notice/notice_home.html"];
    //お決まりの構文
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //読み込み開始
    [webview loadRequest:request];
    //ここもお好みで(画面サイズにページを合わせるか)
    webview.scalesPageToFit = YES;
    //cocos2dの上に乗っける
    [[[CCDirector sharedDirector] view] addSubview:webview];
    
    
    //画像読み込み
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"btn_default.plist"];
    
    CCButton *titleButton = [CCButton buttonWithTitle:@"" spriteFrame:
                             [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"titleBtn.png"]];
    //titleButton.positionType = CCPositionTypeNormalized;
    titleButton.scale=0.6;
    titleButton.position = ccp(winSize.width-(titleButton.contentSize.width*titleButton.scale)/2,
                               winSize.height-titleButton.contentSize.height/2);
    [titleButton setTarget:self selector:@selector(onTitleClicked:)];
    [self addChild:titleButton];
    
    return self;
}

- (void) dealloc
{
    webview.delegate=nil;
    [webview removeFromSuperview];
}

- (void)onTitleClicked:(id)sender
{
    // back to intro scene with transition
    [SoundManager click_Effect];
    [[CCDirector sharedDirector] replaceScene:[TitleScene scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];
    //インターステイシャル広告表示
    //[ImobileSdkAds showBySpotID:@"359467"];
}

@end
