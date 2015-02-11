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
#import "SoundManager.h"

#import "IAdLayer.h"
#import "IMobileLayer.h"
#import "AdGenerLayer.h"

@implementation SelectScene

CGSize winSize;

CCSprite* bgSpLayer;
CCScrollView* scrollView;

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
    
    //オープニングBGM
    [SoundManager playBGM:@"opening_bgm01.mp3"];
    
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
    
    //画面サイズ設定
    UIImage *image = [UIImage imageNamed:@"bgLayer.png"];
    UIGraphicsBeginImageContext(CGSizeMake(winSize.width * 5,winSize.height));
    [image drawInRect:CGRectMake(0, 0, winSize.width * 5,winSize.height)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //スクロールビュー配置 z:0
    bgSpLayer=[CCSprite spriteWithCGImage:image.CGImage key:nil];
    scrollView=[[CCScrollView alloc]initWithContentNode:bgSpLayer];
    scrollView.verticalScrollEnabled=NO;
    bgSpLayer.position=CGPointMake(0, 0);
    [self addChild:scrollView z:0];
    
    //セレクトレヴェルボタン
    int btnCnt=0;
    CGPoint btnPos;
    
    //画像読み込み
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"btn_default.plist"];

    for(int i=0;i<5;i++)
    {
        btnPos=CGPointMake((i*winSize.width)+winSize.width*0.35, winSize.height*0.8);
        
        //背景
        CCSprite* bg=[CCSprite spriteWithImageNamed:@"itemLayer.png"];
        bg.scale=0.6;
        bg.position=ccp(winSize.width/2*(((i+1)*2)-1),winSize.height/2);
        [bgSpLayer addChild:bg z:0];
        
        CCSprite* selectBg=[CCSprite spriteWithImageNamed:@"selectLayer.png"];
        selectBg.scale=0.7;
        selectBg.position=ccp(winSize.width/2*(((i+1)*2)-1),winSize.height/2);
        [bgSpLayer addChild:selectBg z:1];
        
        for(int j=0;j<10;j++)
        {
            btnCnt++;
            CCButton* selectBtn=[CCButton buttonWithTitle:@""
                            spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"player.png"]];
            
            if([GameManager getDevice]==1){
                selectBtn.scale=0.7;
            }else{
                selectBtn.scale=0.5;
            }

            if(j%2==0){
                selectBtn.position=CGPointMake(btnPos.x, btnPos.y-(j*(selectBtn.contentSize.height*selectBtn.scale+15)/2));
            }else{
                selectBtn.position=CGPointMake(btnPos.x+100, btnPos.y-((j-1)*(selectBtn.contentSize.height*selectBtn.scale+15)/2-20));
            }
            
            //selectBtn.position = CGPointMake(btnPos.x, btnPos.y);
            selectBtn.name=[NSString stringWithFormat:@"%d",btnCnt];
            [selectBtn setTarget:self selector:@selector(onStageLevel:)];
            
            //ボタン有効化
            if(btnCnt>1){
                if([GameManager load_StageClear_State:btnCnt-1]>0){
                    selectBtn.enabled=true;
                    //ラベル
                    CCLabelTTF* selectLbl=[CCLabelTTF labelWithString:
                                           [NSString stringWithFormat:@"%02d",btnCnt] fontName:@"Verdana-Bold" fontSize:35];
                    selectLbl.position=ccp(selectBtn.contentSize.width/2,selectBtn.contentSize.height-(selectLbl.contentSize.height*selectLbl.scale)/2-15);
                    [selectBtn addChild:selectLbl];
                    
                }else{
                    selectBtn.enabled=false;
                    //錠前
                    CCSprite* lock=[CCSprite spriteWithSpriteFrame:
                                    [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"bomb.png"]];
                    lock.position=ccp(selectBtn.contentSize.width/2+10,selectBtn.contentSize.height/2+10);
                    lock.scale=0.8;
                    [selectBtn addChild:lock];
                }
            }else{
                //ラベル
                CCLabelTTF* selectLbl=[CCLabelTTF labelWithString:
                                       [NSString stringWithFormat:@"%02d",btnCnt] fontName:@"Verdana-Bold" fontSize:35];
                selectLbl.position=ccp(selectBtn.contentSize.width/2,selectBtn.contentSize.height-(selectLbl.contentSize.height*selectLbl.scale)/2-15);
                [selectBtn addChild:selectLbl];
            }
            
            //スター
            if([GameManager load_StageClear_State:btnCnt]>0){
                CCSprite* star;
                star=[CCSprite spriteWithSpriteFrame:
                      [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:
                       [NSString stringWithFormat:@"star%d.png",[GameManager load_StageClear_State:btnCnt]]]];
                star.scale=0.7;
                star.position=CGPointMake(selectBtn.contentSize.width/2, selectBtn.contentSize.height-(star.contentSize.height*star.scale)/2+15);
                [selectBtn addChild:star];
            }
            
            [bgSpLayer addChild:selectBtn z:2];
        }
    }
    
    //CCButton *titleButton = [CCButton buttonWithTitle:@"[タイトル]" fontName:@"Verdana-Bold" fontSize:15.0f];
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

- (void)onStageLevel:(id)sender
{
    // back to intro scene with transition
    [SoundManager click_Effect];
    CCButton* button =(CCButton*)sender;
    [GameManager setStageLevel:[[button name]intValue]];
    //BGMストップ
    [SoundManager stopBGM];
    [[CCDirector sharedDirector] replaceScene:[StageScene scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];
    
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
