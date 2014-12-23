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
+(void)setMatchMode:(int)mode;
+(int)getMatchMode;
+(void)setPause:(bool)flg;
+(bool)getPause;

+(void)setItem:(int)num;
+(int)getItem;
+(void)setHost:(bool)host;
+(bool)getHost;

+(void)save_Score:(long)value;
+(long)load_Score;
+(void)save_Match_Point:(int)value;
+(int)load_Match_Point;

+(void)initialize_Item;

+(NSMutableArray*)load_Item_All;
+(void)save_Item_All:(int)bomb shield:(int)shield onrush:(int)onrush attackup:(int)attackup speedup:(int)speedup;
+(int)load_Item_Individual:(int)item;
+(void)save_Item_Individual:(int)item value:(int)value;

@end
