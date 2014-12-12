//
//  Fortress.h
//  VirginTech3rdProject
//
//  Created by VirginTech LLC. on 2014/11/11.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Fortress : CCSprite {
    
    int ability;
    
    CCSprite* lifeGauge1;
    CCSprite* lifeGauge2;
    float maxLife;
    float nowRatio;
    
    //デバッグ用
    //CCLabelTTF* energyLabel;
}

@property int ability;

+(id)createFortress:(CGPoint)pos type:(int)type;

@end
