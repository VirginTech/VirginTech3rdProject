//
//  GameManager.m
//  VirginTech3rdProject
//
//  Created by VirginTech LLC. on 2014/11/11.
//  Copyright (c) 2014年 VirginTech LLC. All rights reserved.
//

#import "GameManager.h"

@implementation GameManager

int deviceType;// 1:iPhone5,6 2:iPhone4 3:iPad2
float osVersion;//OSバージョン
CGSize worldSize;//ワールドサイズ
int stageLevel;//ステージレベル
int item;//アイテム番号 0:なし 1:爆弾 2:シールド 3:突撃モード 4:攻撃アップ 5:高速モード

//デバイス取得／登録
+(void)setDevice:(int)type{
    deviceType=type;
}
+(int)getDevice{
    return deviceType;
}
//OSバージョン
+(void)setOsVersion:(float)version{
    osVersion=version;
}
+(float)getOsVersion{
    return osVersion;
}
//ワールドサイズ
+(void)setWorldSize:(CGSize)size{
    worldSize=size;
}
+(CGSize)getWorldSize{
    return worldSize;
}
//ステージレベル取得／登録
+(void)setStageLevel:(int)level{
    stageLevel=level;
}
+(int)getStageLevel{
    return stageLevel;
}
//アイテム番号
+(void)setItem:(int)num{
    item=num;
}
+(int)getItem{
    return item;
}

@end
