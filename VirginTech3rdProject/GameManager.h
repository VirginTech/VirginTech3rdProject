//
//  GameManager.h
//  VirginTech3rdProject
//
//  Created by VirginTech LLC. on 2014/11/11.
//  Copyright (c) 2014年 VirginTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameManager : NSObject

+(int)getDevice;
+(void)setDevice:(int)type;// 1:iPhone5,6 2:iPhone4 3:iPad2
+(float)getOsVersion;
+(void)setOsVersion:(float)version;
+(void)setWorldSize:(CGSize)size;
+(CGSize)getWorldSize;
+(void)setStageLevel:(int)level;
+(int)getStageLevel;
+(void)setItem:(int)num;
+(int)getItem;
+(void)setHost:(bool)host;
+(bool)getHost;

@end
