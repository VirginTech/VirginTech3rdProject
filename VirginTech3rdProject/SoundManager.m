//
//  SoundManager.m
//  VirginTech3rdProject
//
//  Created by VirginTech LLC. on 2015/01/07.
//  Copyright 2015年 VirginTech LLC. All rights reserved.
//

#import "SoundManager.h"


@implementation SoundManager

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
    
    //UI
    [[OALSimpleAudio sharedInstance]preloadEffect:@"click.mp3"];
    [[OALSimpleAudio sharedInstance]preloadEffect:@"item.mp3"];
    
}

//===================
// BGM
//===================
+(void)playBGM:(NSString*)fileName
{
    if(![[OALSimpleAudio sharedInstance]bgPlaying]){
        [[OALSimpleAudio sharedInstance]playBg:fileName loop:YES];
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
    [[OALSimpleAudio sharedInstance]playEffect:@"creat_obj.mp3"];
}
+(void)battle_Effect
{
    [[OALSimpleAudio sharedInstance]playEffect:@"battle.mp3"];
}
+(void)die_Player_Effect
{
    [[OALSimpleAudio sharedInstance]playEffect:@"die_player.mp3"];
}
+(void)die_Enemy_Effect
{
    [[OALSimpleAudio sharedInstance]playEffect:@"die_enemy.mp3"];
}
+(void)wao_Effect
{
    [[OALSimpleAudio sharedInstance]playEffect:@"wao.mp3"];
}
+(void)run_Effect
{
    [[OALSimpleAudio sharedInstance]playEffect:@"run.mp3"];
}
+(void)ready_Effect
{
    [[OALSimpleAudio sharedInstance]playEffect:@"ready.mp3"];
}
+(void)star_Effect
{
    [[OALSimpleAudio sharedInstance]playEffect:@"star.mp3"];
}
+(void)score_Effect
{
    [[OALSimpleAudio sharedInstance]playEffect:@"score.mp3"];
}
+(void)highscore_Effect
{
    [[OALSimpleAudio sharedInstance]playEffect:@"highscore.mp3"];
}
+(void)win_Effect
{
    [[OALSimpleAudio sharedInstance]playEffect:@"win.mp3"];
}
+(void)lose_Effect
{
    [[OALSimpleAudio sharedInstance]playEffect:@"lose.mp3"];
}
+(void)bomb_Effect
{
    [[OALSimpleAudio sharedInstance]playEffect:@"bomb.mp3"];
}
+(void)attack_Effect
{
    [[OALSimpleAudio sharedInstance]playEffect:@"attack.mp3"];
}

//===================
// UI
//===================
+(void)click_Effect
{
    [[OALSimpleAudio sharedInstance]playEffect:@"click.mp3"];
}
+(void)item_Select_Effect
{
    [[OALSimpleAudio sharedInstance]playEffect:@"item.mp3"];
}

//===================
// オールストップ
//===================
+(void)all_Stop
{
    [[OALSimpleAudio sharedInstance]stopEverything];
}

@end
