//
//  MatchWaitLayer.h
//  VirginTech3rdProject
//
//  Created by VirginTech LLC. on 2014/12/09.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "cocos2d-ui.h"

@interface MatchWaitLayer : CCScene {
    
    bool playerReadyFlg;
    bool enemyReadyFlg;
}
@property bool playerReadyFlg;
@property bool enemyReadyFlg;

+ (MatchWaitLayer *)scene;
- (id)init;

@end
