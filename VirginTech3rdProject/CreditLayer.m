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
#import "GameManager.h"

#import "ImobileSdkAds/ImobileSdkAds.h"

@implementation CreditLayer

CGSize winSize;
CCSprite* bgSpLayer;
CCScrollView* scrollView;

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
    
    //背景画像拡大
    UIImage *image = [UIImage imageNamed:@"bgLayer.png"];
    UIGraphicsBeginImageContext(CGSizeMake(winSize.width,1100));
    [image drawInRect:CGRectMake(0, 0, winSize.width,1100)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //スクロールビュー配置
    bgSpLayer=[CCSprite spriteWithCGImage:image.CGImage key:nil];
    scrollView=[[CCScrollView alloc]initWithContentNode:bgSpLayer];
    scrollView.horizontalScrollEnabled=NO;
    [self addChild:scrollView];
    
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
    
    //ロゴ
    CCSprite* logo=[CCSprite spriteWithImageNamed:@"virgintech.png"];
    logo.position=ccp(winSize.width/2,890);
    logo.scale=0.3;
    [bgSpLayer addChild:logo];
    
    //開発者
    CCLabelTTF* label;
    
    label=[CCLabelTTF labelWithString:@"Developer" fontName:@"Verdana-Italic" fontSize:12];
    label.position=ccp(winSize.width/2,760);
    [bgSpLayer addChild:label];
    
    label=[CCLabelTTF labelWithString:@"OOTANI,Kenji" fontName:@"Verdana-Bold" fontSize:15];
    label.position=ccp(winSize.width/2,740);
    [bgSpLayer addChild:label];
    
    //イラストデザイン
    label=[CCLabelTTF labelWithString:@"Illust-Designer" fontName:@"Verdana-Italic" fontSize:12];
    label.position=ccp(winSize.width/2,660);
    [bgSpLayer addChild:label];
    
    label=[CCLabelTTF labelWithString:@"FUKUDA,Makiko" fontName:@"Verdana-Bold" fontSize:15];
    label.position=ccp(winSize.width/2,640);
    [bgSpLayer addChild:label];
    
    label=[CCLabelTTF labelWithString:@"FUJII,Eiji" fontName:@"Verdana-Bold" fontSize:15];
    label.position=ccp(winSize.width/2,620);
    [bgSpLayer addChild:label];
    
    [self setList];
    
    return self;
}

-(void)setList
{
    CCLabelTTF* label;
    
    //マテリアル
    label=[CCLabelTTF labelWithString:@"Material by" fontName:@"Verdana-Italic" fontSize:12];
    label.position=ccp(winSize.width/2,570);
    [bgSpLayer addChild:label];
    
    label=[CCLabelTTF labelWithString:@"ドット絵世界 - yms.main.jp" fontName:@"Verdana-Bold" fontSize:10];
    label.position=ccp(winSize.width/2,540);
    [bgSpLayer addChild:label];
    
    label=[CCLabelTTF labelWithString:@"超シンプル素材集 - sozai.akuseru-design.com" fontName:@"Verdana-Bold" fontSize:10];
    label.position=ccp(winSize.width/2,520);
    [bgSpLayer addChild:label];
    
    label=[CCLabelTTF labelWithString:@"blue-green - bluegreen.jp" fontName:@"Verdana-Bold" fontSize:10];
    label.position=ccp(winSize.width/2,500);
    [bgSpLayer addChild:label];
    
    label=[CCLabelTTF labelWithString:@"ストックマテリアル - stockmaterial.geo.jp" fontName:@"Verdana-Bold" fontSize:10];
    label.position=ccp(winSize.width/2,480);
    [bgSpLayer addChild:label];
    
    label=[CCLabelTTF labelWithString:@"無料イラスト素材.com - www.無料イラスト素材.com" fontName:@"Verdana-Bold" fontSize:10];
    label.position=ccp(winSize.width/2,460);
    [bgSpLayer addChild:label];
    
    label=[CCLabelTTF labelWithString:@"いらすとや - www.irasutoya.com" fontName:@"Verdana-Bold" fontSize:10];
    label.position=ccp(winSize.width/2,440);
    [bgSpLayer addChild:label];
    
    label=[CCLabelTTF labelWithString:@"PremiumPixels - www.premiumpixels.com" fontName:@"Verdana-Bold" fontSize:10];
    label.position=ccp(winSize.width/2,420);
    [bgSpLayer addChild:label];
    
    label=[CCLabelTTF labelWithString:@"SENDESIGNZ - www.sendesignz.com" fontName:@"Verdana-Bold" fontSize:10];
    label.position=ccp(winSize.width/2,400);
    [bgSpLayer addChild:label];
    
    label=[CCLabelTTF labelWithString:@"Artless KITCHEN - illustration.artlesskitchen.com" fontName:@"Verdana-Bold" fontSize:10];
    label.position=ccp(winSize.width/2,380);
    [bgSpLayer addChild:label];
    
    label=[CCLabelTTF labelWithString:@"GATAG - free-illustrations.gatag.net" fontName:@"Verdana-Bold" fontSize:10];
    label.position=ccp(winSize.width/2,360);
    [bgSpLayer addChild:label];
    
    label=[CCLabelTTF labelWithString:@"PhotoshopVIP - photoshopvip.net" fontName:@"Verdana-Bold" fontSize:10];
    label.position=ccp(winSize.width/2,340);
    [bgSpLayer addChild:label];
    
    label=[CCLabelTTF labelWithString:@"PSDgraphics.com - www.psdgraphics.com" fontName:@"Verdana-Bold" fontSize:10];
    label.position=ccp(winSize.width/2,320);
    [bgSpLayer addChild:label];
    
    label=[CCLabelTTF labelWithString:@"やじるし素材天国 - yajidesign.com" fontName:@"Verdana-Bold" fontSize:10];
    label.position=ccp(winSize.width/2,300);
    [bgSpLayer addChild:label];
    
    //サウンド
    label=[CCLabelTTF labelWithString:@"Sound by" fontName:@"Verdana-Italic" fontSize:12];
    label.position=ccp(winSize.width/2,250);
    [bgSpLayer addChild:label];
    
    label=[CCLabelTTF labelWithString:@"くらげ工匠 - www.kurage-kosho.info" fontName:@"Verdana-Bold" fontSize:10];
    label.position=ccp(winSize.width/2,220);
    [bgSpLayer addChild:label];
    
    label=[CCLabelTTF labelWithString:@"魔王魂 - maoudamashii.jokersounds.com" fontName:@"Verdana-Bold" fontSize:10];
    label.position=ccp(winSize.width/2,200);
    [bgSpLayer addChild:label];
    
    label=[CCLabelTTF labelWithString:@"音の杜 - www.otonomori.info" fontName:@"Verdana-Bold" fontSize:10];
    label.position=ccp(winSize.width/2,180);
    [bgSpLayer addChild:label];
    
    label=[CCLabelTTF labelWithString:@"効果音ラボ - soundeffect-lab.info" fontName:@"Verdana-Bold" fontSize:10];
    label.position=ccp(winSize.width/2,160);
    [bgSpLayer addChild:label];

    label=[CCLabelTTF labelWithString:@"SoundLabel - www.snd-jpn.net" fontName:@"Verdana-Bold" fontSize:10];
    label.position=ccp(winSize.width/2,140);
    [bgSpLayer addChild:label];

    label=[CCLabelTTF labelWithString:@"H/MIX GALLERY - www.hmix.net" fontName:@"Verdana-Bold" fontSize:10];
    label.position=ccp(winSize.width/2,120);
    [bgSpLayer addChild:label];

    label=[CCLabelTTF labelWithString:@"On-Jin ～音人～ - on-jin.com" fontName:@"Verdana-Bold" fontSize:10];
    label.position=ccp(winSize.width/2,100);
    [bgSpLayer addChild:label];
    
    
    label=[CCLabelTTF labelWithString:@"Special Thanks! " fontName:@"Verdana-Italic" fontSize:20];
    label.position=ccp(winSize.width/2,60);
    [bgSpLayer addChild:label];
    
    label=[CCLabelTTF labelWithString:@"ありがとう! " fontName:@"Verdana-Italic" fontSize:20];
    label.position=ccp(winSize.width/2,30);
    [bgSpLayer addChild:label];
    
}

- (void)onTitleClicked:(id)sender
{
    // back to intro scene with transition
    [SoundManager click_Effect];
    [[CCDirector sharedDirector] replaceScene:[TitleScene scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];
    //インターステイシャル広告表示
    [ImobileSdkAds showBySpotID:@"359467"];
}

@end
