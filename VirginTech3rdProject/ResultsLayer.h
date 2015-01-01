//
//  ResultsLayer.h
//  VirginTech3rdProject
//
//  Created by VirginTech LLC. on 2014/12/17.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "cocos2d-ui.h"

@interface ResultsLayer : CCScene {
    
}

+ (ResultsLayer *)scene;
- (id)initWithWinner:(bool)flg//true:青軍 false:赤軍
                        stars:(int)stars
                        playerDie:(int)_playerDieCount
                        enemyDie:(int)_enemyDieCount
                        playerFortress:(int)_playerFortressAbility
                        highScoreFlg:(bool)highScoreFlg;

@end
