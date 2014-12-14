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
int matchMode;//0:シングル 1:リアル対戦 2:ネット対戦
int item;//アイテム番号 0:なし 1:爆弾 2:シールド 3:突撃モード 4:攻撃アップ 5:高速モード
bool isHost;//true:ホスト(青) false:クライアント(赤)
bool pauseFlg;

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
//マッチメニュー
+(void)setMatchMode:(int)mode{
    matchMode=mode;
}
+(int)getMatchMode{
    return matchMode;
}
//アイテム番号
+(void)setItem:(int)num{
    item=num;
}
+(int)getItem{
    return item;
}
//ホスト/クライアント
+(void)setHost:(bool)host{
    isHost=host;
}
+(bool)getHost{
    return isHost;
}
//ポーズフラグ
+(void)setPause:(bool)flg{
    pauseFlg=flg;
}
+(bool)getPause{
    return pauseFlg;
}

//=======================
// アイテム初期化処理
//=======================
+(void)initialize_Item
{
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] persistentDomainForName:appDomain];
    
    if([dict valueForKey:@"item"]==nil){
        [self save_Item_All:0 shield:0 onrush:0 attackup:0 speedup:0];
    }
    
}

//=========================================
//アイテムの取得（配列で一括） 0:爆弾 1:シールド 2:突撃モード 3:攻撃アップ 4:高速モード
//=========================================
+(NSMutableArray*)load_Item_All
{
    NSUserDefaults  *userDefault=[NSUserDefaults standardUserDefaults];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    array = [userDefault objectForKey:@"item"];
    return array;
}
//=========================================
//アイテムのセーブ（一括保存） 0:爆弾 1:シールド 2:突撃モード 3:攻撃アップ 4:高速モード
//=========================================
+(void)save_Item_All:(int)bomb shield:(int)shield onrush:(int)onrush attackup:(int)attackup speedup:(int)speedup
{
    NSUserDefaults  *userDefault=[NSUserDefaults standardUserDefaults];
    NSArray* array=[NSArray arrayWithObjects:[NSNumber numberWithInt:bomb],
                                            [NSNumber numberWithInt:shield],
                                            [NSNumber numberWithInt:onrush],
                                            [NSNumber numberWithInt:attackup],
                                            [NSNumber numberWithInt:speedup],nil];
    [userDefault setObject:array forKey:@"item"];
    [userDefault synchronize];
}
//=========================================
//　アイテムの取得（個別に） 0:爆弾 1:シールド 2:突撃モード 3:攻撃アップ 4:高速モード
//=========================================
+(int)load_Item_Individual:(int)item
{
    NSMutableArray* array=[[NSMutableArray alloc]init];
    array=[self load_Item_All];
    int value=[[array objectAtIndex:item]intValue];
    return value;
}
//=========================================
//　アイテムの保存（個別に） 0:爆弾 1:シールド 2:突撃モード 3:攻撃アップ 4:高速モード
//=========================================
+(void)save_Item_Individual:(int)item value:(int)value
{
    NSMutableArray* array=[[NSMutableArray alloc]init];
    NSMutableArray* tmpArray=[[NSMutableArray alloc]init];
    tmpArray=[self load_Item_All];
    for(int i=0;i<tmpArray.count;i++){//コピー
        [array addObject:[tmpArray objectAtIndex:i]];
    }
    [array replaceObjectAtIndex:item withObject:[NSNumber numberWithInt:value]];
    [self save_Item_All:[[array objectAtIndex:0]intValue]
                                            shield:[[array objectAtIndex:1]intValue]
                                            onrush:[[array objectAtIndex:2]intValue]
                                            attackup:[[array objectAtIndex:3]intValue]
                                            speedup:[[array objectAtIndex:4]intValue]];
}

@end
