//
//  SoundManager.m
//  VirginTech3rdProject
//
//  Created by VirginTech LLC. on 2015/01/07.
//  Copyright 2015年 VirginTech LLC. All rights reserved.
//

#import "SoundManager.h"


@implementation SoundManager

bool bgmSwitch;
bool effectSwitch;

float bgmValue;
float effectValue;

//===================
//BGM・効果音プリロード
//===================
+(void)initSoundPreload
{
    //BGM
    [[OALSimpleAudio sharedInstance]preloadBg:@"opening_bgm01.mp3"];
    [[OALSimpleAudio sharedInstance]preloadBg:@"opening_bgm02.mp3"];
    
    [[OALSimpleAudio sharedInstance]preloadBg:@"battle_bgm01.mp3"];
    
    //エフェクト
    [[OALSimpleAudio sharedInstance]preloadEffect:@"creat_obj.mp3"];
    [[OALSimpleAudio sharedInstance]preloadEffect:@"battle.mp3"];
    [[OALSimpleAudio sharedInstance]preloadEffect:@"die_player.mp3"];
    [[OALSimpleAudio sharedInstance]preloadEffect:@"die_enemy.mp3"];
    [[OALSimpleAudio sharedInstance]preloadEffect:@"wao.mp3"];
    [[OALSimpleAudio sharedInstance]preloadEffect:@"run.mp3"];
    [[OALSimpleAudio sharedInstance]preloadEffect:@"ready.mp3"];
    [[OALSimpleAudio sharedInstance]preloadEffect:@"star.mp3"];
    [[OALSimpleAudio sharedInstance]preloadEffect:@"score.mp3"];
    [[OALSimpleAudio sharedInstance]preloadEffect:@"highscore.mp3"];
    [[OALSimpleAudio sharedInstance]preloadEffect:@"win.mp3"];
    [[OALSimpleAudio sharedInstance]preloadEffect:@"lose.mp3"];
    [[OALSimpleAudio sharedInstance]preloadEffect:@"bomb.mp3"];
    [[OALSimpleAudio sharedInstance]preloadEffect:@"attack.mp3"];
    [[OALSimpleAudio sharedInstance]preloadEffect:@"f_Bomb_01.mp3"];
    [[OALSimpleAudio sharedInstance]preloadEffect:@"f_Bomb_02.mp3"];
    
    //UI
    [[OALSimpleAudio sharedInstance]preloadEffect:@"click.mp3"];
    [[OALSimpleAudio sharedInstance]preloadEffect:@"item.mp3"];
    
    //スイッチ
    bgmSwitch=true;
    effectSwitch=true;
    
    //BGM音量初期値セット
    bgmValue=0.5;
    //エフェクト音量初期値セット
    effectValue=0.5;
}

//===================
// スイッチ
//===================
+(void)setBgmSwitch:(bool)flg
{
    bgmSwitch=flg;
}
+(bool)getBgmSwitch
{
    return bgmSwitch;
}
+(void)setEffectSwitch:(bool)flg
{
    effectSwitch=flg;
}
+(bool)getEffectSwitch
{
    return effectSwitch;
}

//===================
// BGM音量セット
//===================
+(void)setBgmVolume:(float)value
{
    bgmValue=value;
    [[OALSimpleAudio sharedInstance]setBgVolume:bgmValue];
}
+(float)getBgmVolume
{
    return bgmValue;
}

//===================
// エフェクト音量セット
//===================
+(void)setEffectVolume:(float)value
{
    effectValue=value;
}
+(float)getEffectVolume
{
    return effectValue;
}

//===================
// BGM
//===================
+(void)playBGM:(NSString*)fileName
{
    if(bgmSwitch){
        if(![[OALSimpleAudio sharedInstance]bgPlaying]){
            [[OALSimpleAudio sharedInstance]setBgVolume:bgmValue];
            [[OALSimpleAudio sharedInstance]playBg:fileName loop:YES];
        }
    }
}
+(void)stopBGM
{
    [[OALSimpleAudio sharedInstance]stopBg];
}
+(void)pauseBGM
{
    [[OALSimpleAudio sharedInstance]setPaused:YES];
}
+(void)resumeBGM
{
    [[OALSimpleAudio sharedInstance]setPaused:NO];
}

//===================
// エフェクト
//===================
+(void)creat_Object_Effect
{
    if(effectSwitch){
        [[OALSimpleAudio sharedInstance]setEffectsVolume:effectValue];
        [[OALSimpleAudio sharedInstance]playEffect:@"creat_obj.mp3"];
    }
}
+(void)battle_Effect
{
    if(effectSwitch){
        [[OALSimpleAudio sharedInstance]setEffectsVolume:effectValue];
        [[OALSimpleAudio sharedInstance]playEffect:@"battle.mp3"];
    }
}
+(void)die_Player_Effect
{
    if(effectSwitch){
        [[OALSimpleAudio sharedInstance]setEffectsVolume:effectValue];
        [[OALSimpleAudio sharedInstance]playEffect:@"die_player.mp3"];
    }
}
+(void)die_Enemy_Effect
{
    if(effectSwitch){
        [[OALSimpleAudio sharedInstance]setEffectsVolume:effectValue];
        [[OALSimpleAudio sharedInstance]playEffect:@"die_enemy.mp3"];
    }
}
+(void)wao_Effect
{
    if(effectSwitch){
        [[OALSimpleAudio sharedInstance]setEffectsVolume:effectValue];
        [[OALSimpleAudio sharedInstance]playEffect:@"wao.mp3"];
    }
}
+(void)run_Effect
{
    if(effectSwitch){
        [[OALSimpleAudio sharedInstance]setEffectsVolume:effectValue];
        [[OALSimpleAudio sharedInstance]playEffect:@"run.mp3"];
    }
}
+(void)ready_Effect
{
    if(effectSwitch){
        [[OALSimpleAudio sharedInstance]setEffectsVolume:effectValue];
        [[OALSimpleAudio sharedInstance]playEffect:@"ready.mp3"];
    }
}
+(void)star_Effect
{
    if(effectSwitch){
        [[OALSimpleAudio sharedInstance]setEffectsVolume:effectValue];
        [[OALSimpleAudio sharedInstance]playEffect:@"star.mp3"];
    }
}
+(void)score_Effect
{
    if(effectSwitch){
        [[OALSimpleAudio sharedInstance]setEffectsVolume:effectValue];
        [[OALSimpleAudio sharedInstance]playEffect:@"score.mp3"];
    }
}
+(void)highscore_Effect
{
    if(effectSwitch){
        [[OALSimpleAudio sharedInstance]setEffectsVolume:effectValue];
        [[OALSimpleAudio sharedInstance]playEffect:@"highscore.mp3"];
    }
}
+(void)win_Effect
{
    if(effectSwitch){
        [[OALSimpleAudio sharedInstance]setEffectsVolume:effectValue];
        [[OALSimpleAudio sharedInstance]playEffect:@"win.mp3"];
    }
}
+(void)lose_Effect
{
    if(effectSwitch){
        [[OALSimpleAudio sharedInstance]setEffectsVolume:effectValue];
        [[OALSimpleAudio sharedInstance]playEffect:@"lose.mp3"];
    }
}
+(void)bomb_Effect
{
    if(effectSwitch){
        [[OALSimpleAudio sharedInstance]setEffectsVolume:effectValue];
        [[OALSimpleAudio sharedInstance]playEffect:@"bomb.mp3"];
    }
}
+(void)attack_Effect
{
    if(effectSwitch){
        [[OALSimpleAudio sharedInstance]setEffectsVolume:effectValue];
        [[OALSimpleAudio sharedInstance]playEffect:@"attack.mp3"];
    }
}
+(void)f_Bomb_Effect:(int)cnt
{
    if(effectSwitch){
        NSString* fileName=[NSString stringWithFormat:@"f_Bomb_%02d.mp3",cnt+1];
        [[OALSimpleAudio sharedInstance]setEffectsVolume:effectValue];
        [[OALSimpleAudio sharedInstance]playEffect:fileName];
    }
}

//===================
// UI
//===================
+(void)click_Effect
{
    if(effectSwitch){
        [[OALSimpleAudio sharedInstance]setEffectsVolume:effectValue];
        [[OALSimpleAudio sharedInstance]playEffect:@"click.mp3"];
    }
}
+(void)item_Select_Effect
{
    if(effectSwitch){
        [[OALSimpleAudio sharedInstance]setEffectsVolume:effectValue];
        [[OALSimpleAudio sharedInstance]playEffect:@"item.mp3"];
    }
}

//===================
// オールストップ
//===================
+(void)all_Stop
{
    [[OALSimpleAudio sharedInstance]stopEverything];
}

@end
