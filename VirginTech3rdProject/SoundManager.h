//
//  SoundManager.h
//  VirginTech3rdProject
//
//  Created by VirginTech LLC. on 2015/01/07.
//  Copyright 2015年 VirginTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface SoundManager : NSObject {
    
}

+(void)initSoundPreload;

+(void)playBGM:(NSString*)fileName;
+(void)stopBGM;
+(void)pauseBGM;
+(void)resumeBGM;

+(void)creat_Object_Effect;
+(void)battle_Effect;
+(void)die_Player_Effect;
+(void)die_Enemy_Effect;
+(void)wao_Effect;
+(void)run_Effect;
+(void)ready_Effect;

@end
