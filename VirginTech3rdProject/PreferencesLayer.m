//
//  PreferencesLayer.m
//  VirginTech3rdProject
//
//  Created by VirginTech LLC. on 2014/12/09.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "PreferencesLayer.h"
#import "TitleScene.h"
#import "SoundManager.h"

@implementation PreferencesLayer

CGSize winSize;

CCSlider* bgmSlider;
CCSlider* effectSlider;
CCButton* onBgmSwitch;
CCButton* offBgmSwitch;
CCButton* onEffectSwitch;
CCButton* offEffectSwitch;

+ (PreferencesLayer *)scene
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
    
    //画像読込み
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"sound_default.plist"];
    
    CCButton *titleButton = [CCButton buttonWithTitle:@"[タイトル]" fontName:@"Verdana-Bold" fontSize:15.0f];
    titleButton.positionType = CCPositionTypeNormalized;
    titleButton.position = ccp(0.9f, 0.95f); // Top Right of screen
    [titleButton setTarget:self selector:@selector(onTitleClicked:)];
    [self addChild:titleButton];
    
    //=================
    //BGM音量
    //=================
    
    //BGMラベル
    CCLabelTTF* bgmLabel=[CCLabelTTF labelWithString:@"BGM:" fontName:@"Verdana-Bold" fontSize:20.0];
    bgmLabel.position=ccp(winSize.width/2-100,winSize.height/2+100);
    [self addChild:bgmLabel];
    
    //BGMスイッチ
    onBgmSwitch=[CCButton buttonWithTitle:@""
                              spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"on.png"]];
    onBgmSwitch.position=ccp(bgmLabel.position.x+100,bgmLabel.position.y);
    [onBgmSwitch setTarget:self selector:@selector(bgmSwitchClicked:)];
    onBgmSwitch.name=@"1";
    
    offBgmSwitch=[CCButton buttonWithTitle:@""
                               spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"off.png"]];
    offBgmSwitch.position=ccp(bgmLabel.position.x+100,bgmLabel.position.y);
    [offBgmSwitch setTarget:self selector:@selector(bgmSwitchClicked:)];
    offBgmSwitch.name=@"0";
    
    if([SoundManager getBgmSwitch]){
        onBgmSwitch.visible=true;
        offBgmSwitch.visible=false;
    }else{
        onBgmSwitch.visible=false;
        offBgmSwitch.visible=true;
    }
    
    [self addChild:onBgmSwitch z:1];
    [self addChild:offBgmSwitch z:1];
    
    
    //BGM音量スライダー
    bgmSlider=[[CCSlider alloc]initWithBackground:
               [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"bgm_line.png"]
                andHandleImage:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"handle_bgm.png"]];
    bgmSlider.position=ccp(winSize.width/2-bgmSlider.contentSize.width/2,bgmLabel.position.y-70);
    [bgmSlider setSliderValue:[SoundManager getBgmVolume]];
    bgmSlider.name=@"BGM-Volume";
    bgmSlider.handle.scale=0.5;
    [self addChild:bgmSlider];
    
    //=================
    //エフェクト音量
    //=================
    
    //Effectラベル
    CCLabelTTF* effectLabel=[CCLabelTTF labelWithString:@"Effect:" fontName:@"Verdana-Bold" fontSize:20.0];
    effectLabel.position=ccp(winSize.width/2-100,bgmLabel.position.y-150);
    [self addChild:effectLabel];
    
    //Effectスイッチ
    onEffectSwitch=[CCButton buttonWithTitle:@""
                                 spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"on.png"]];
    onEffectSwitch.position=ccp(effectLabel.position.x+100,effectLabel.position.y);
    [onEffectSwitch setTarget:self selector:@selector(effectSwitchClicked:)];
    onEffectSwitch.name=@"1";
    
    offEffectSwitch=[CCButton buttonWithTitle:@""
                                  spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"off.png"]];
    offEffectSwitch.position=ccp(effectLabel.position.x+100,effectLabel.position.y);
    [offEffectSwitch setTarget:self selector:@selector(effectSwitchClicked:)];
    offEffectSwitch.name=@"0";
    
    if([SoundManager getEffectSwitch]){
        onEffectSwitch.visible=true;
        offEffectSwitch.visible=false;
    }else{
        onEffectSwitch.visible=false;
        offEffectSwitch.visible=true;
    }
    
    [self addChild:onEffectSwitch z:1];
    [self addChild:offEffectSwitch z:1];
    
    //エフェクト音量スライダー
    effectSlider=[[CCSlider alloc]initWithBackground:
                [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"effect_line.png"]
                andHandleImage:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"handle_effect.png"]];
    effectSlider.position=ccp(winSize.width/2-effectSlider.contentSize.width/2,effectLabel.position.y-70);
    [effectSlider setSliderValue:[SoundManager getEffectVolume]];
    effectSlider.name=@"Effect-Volume";
    effectSlider.handle.scale=0.5;
    [self addChild:effectSlider];
    
    return self;
}

- (void)bgmSwitchClicked:(id)sender
{
    //NSLog(@"押された！");
    CCButton* button=(CCButton*)sender;
    if([button.name intValue]==0){//停止中〜開始
        onBgmSwitch.visible=true;
        offBgmSwitch.visible=false;
        [SoundManager setBgmSwitch:true];
        [SoundManager playBGM:@"opening_bgm01.mp3"];
    }else{
        onBgmSwitch.visible=false;
        offBgmSwitch.visible=true;
        [SoundManager setBgmSwitch:false];
        [SoundManager stopBGM];
    }
}
- (void)effectSwitchClicked:(id)sender
{
    CCButton* button=(CCButton*)sender;
    if([button.name intValue]==0){//停止中〜開始
        onEffectSwitch.visible=true;
        offEffectSwitch.visible=false;
        [SoundManager setEffectSwitch:true];
    }else{
        onEffectSwitch.visible=false;
        offEffectSwitch.visible=true;
        [SoundManager setEffectSwitch:false];
    }
}

- (void)onTitleClicked:(id)sender
{
    // back to intro scene with transition
    [SoundManager click_Effect];
    //[[CCDirector sharedDirector] replaceScene:[TitleScene scene]
    //                           withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];
    [[CCDirector sharedDirector] replaceScene:[TitleScene scene] withTransition:
                        [CCTransition transitionRevealWithDirection:CCTransitionDirectionLeft duration:0.3f]];

}

@end
