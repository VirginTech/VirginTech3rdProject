//
//  GameManager.h
//  VirginTech3rdProject
//
//  Created by VirginTech LLC. on 2014/11/11.
//  Copyright (c) 2014年 VirginTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameManager : NSObject

+(void)setWorldSize:(CGSize)size;
+(CGSize)getWorldSize;
+(void)setStageLevel:(int)level;
+(int)getStageLevel;

@end
