//
//  MatchMakeScene.h
//  VirginTech3rdProject
//
//  Created by VirginTech LLC. on 2014/11/27.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "cocos2d-ui.h"
#import <GameKit/GameKit.h>
#import "MessageLayer.h"

@interface MatchMakeScene : CCScene <GKMatchDelegate,MsgLayerDelegate>
{
    
}

+ (MatchMakeScene *)scene;
- (id)init;

+(GKMatch*)getCurrentMatch;
+(void)setCurrentMatch:(GKMatch*)match;

+(void)sendData_Pause:(bool)flg;

@end
