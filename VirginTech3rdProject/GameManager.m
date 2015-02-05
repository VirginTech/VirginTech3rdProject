//
//  GameManager.m
//  VirginTech3rdProject
//
//  Created by VirginTech LLC. on 2014/11/11.
//  Copyright (c) 2014年 VirginTech LLC. All rights reserved.
//

#import "GameManager.h"
#import <GameKit/GameKit.h>

@implementation GameManager

//==============
// グローバル定数
//==============
const int MATCH_TOTAL_OBJ_MAX=200;//対戦モードにおける総投入数
int TURN_OBJ_MAX;//一度に投入できる数

//==============
// メモリ内
//==============
int locale;//1:日本語 2:それ以外
int deviceType;// 1:iPhone5,6 2:iPhone4 3:iPad2
float osVersion;//OSバージョン
CGSize worldSize;//ワールドサイズ
int stageLevel;//ステージレベル
int currentScore;//現在進行ステージのスコア（比較用）
int matchMode;//0:シングル 1:リアル対戦 2:ネット対戦
int item;//アイテム番号 0:なし 1:爆弾 2:シールド 3:突撃モード 4:攻撃アップ 5:高速モード
bool isHost;//true:ホスト(青) false:クライアント(赤)
bool pauseFlg;

//現在進行中のステージスコア
+(void)setCurrentScore:(int)score{
    currentScore=score;
}
+(int)getCurrentScore{
    return currentScore;
}
//ロケール登録
+(void)setLocale:(int)value{
    locale=value;
}
+(int)getLocale{
    return locale;
}
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
// 初回起動時 初期化処理
//=======================
+(void)initialize_Save_Data
{
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] persistentDomainForName:appDomain];
    
    if([dict valueForKey:@"item"]==nil){
        [self save_Item_All:0 shield:0 onrush:0 attackup:0 speedup:0];
    }
    if([dict valueForKey:@"highscore"]==nil){
        [self save_High_Score:0];
    }
    if([dict valueForKey:@"point"]==nil){
        [self save_Match_Point:0];
    }
    if([dict valueForKey:@"stagescore"]==nil){
        NSMutableArray* array=[[NSMutableArray alloc]init];
        for(int i=0;i<50;i++){
            [array addObject:[NSNumber numberWithInt:0]];
        }
        [self save_Stage_Score_All:array];
    }
    if([dict valueForKey:@"StageClearState"]==nil){
        NSUserDefaults  *userDefault=[NSUserDefaults standardUserDefaults];
        NSMutableArray* array=[[NSMutableArray alloc]init];
        for(int i=0;i<50;i++){
            [array addObject:[NSNumber numberWithInt:0]];
        }
        [userDefault setObject:array forKey:@"StageClearState"];
        [userDefault synchronize];
    }
    if([dict valueForKey:@"coin"]==nil){
        [self save_Coin:0];
    }

}
//=========================================
//ステージクリア状態の保存(0:未達成 1:星1つ 2:星2つ 3:星3つ)
//=========================================
+(void)save_StageClear_State:(int)stageNum rate:(int)rate
{
    NSUserDefaults  *userDefault=[NSUserDefaults standardUserDefaults];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSMutableArray* tmpArray=[[NSMutableArray alloc]init];
    tmpArray = [userDefault objectForKey:@"StageClearState"];
    for(int i=0;i<tmpArray.count;i++){//コピー
        [array addObject:[tmpArray objectAtIndex:i]];
    }
    [array replaceObjectAtIndex:stageNum-1 withObject:[NSNumber numberWithInt:rate]];
    [userDefault setObject:array forKey:@"StageClearState"];
    [userDefault synchronize];
}
//=========================================
//ステージクリア状態の取得(0:未達成 1:星1つ 2:星2つ 3:星3つ)
//=========================================
+(int)load_StageClear_State:(int)stageNum
{
    int rate;
    NSUserDefaults  *userDefault=[NSUserDefaults standardUserDefaults];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    array = [userDefault objectForKey:@"StageClearState"];
    rate=[[array objectAtIndex:stageNum-1]intValue];
    return rate;
}
//====================
//ステージスコアの一括保存
//====================
+(void)save_Stage_Score_All:(NSMutableArray*)array
{
    NSUserDefaults  *userDefault=[NSUserDefaults standardUserDefaults];
    [userDefault setObject:array forKey:@"stagescore"];
    [userDefault synchronize];
}
//====================
//ステージスコアの一括取得
//====================
+(NSMutableArray*)load_Stage_Score_All
{
    NSUserDefaults  *userDefault=[NSUserDefaults standardUserDefaults];
    NSMutableArray *array = [[NSMutableArray alloc]init];
    array = [userDefault objectForKey:@"stagescore"];
    return array;
}
//====================
//各ステージスコアの保存
//====================
+(void)save_Stage_Score:(int)stage score:(int)score
{
    NSMutableArray* array=[[NSMutableArray alloc]init];
    NSMutableArray* tmpArray=[[NSMutableArray alloc]init];
    tmpArray=[self load_Stage_Score_All];
    for(int i=0;i<tmpArray.count;i++){//コピー
        [array addObject:[tmpArray objectAtIndex:i]];
    }
    [array replaceObjectAtIndex:stage-1 withObject:[NSNumber numberWithInt:score]];
    [self save_Stage_Score_All:array];
}

//====================
//各ステージスコアの取得
//====================
+(int)load_Stage_Score:(int)stage
{
    NSMutableArray* array=[[NSMutableArray alloc]init];
    array=[self load_Stage_Score_All];
    int score=[[array objectAtIndex:stage-1]intValue];
    return score;
}
//====================
//トータルスコアの取得
//====================
+(int)load_Total_Score:(int)stage
{
    int score=0;
    NSUserDefaults  *userDefault=[NSUserDefaults standardUserDefaults];
    NSMutableArray *array = [[NSMutableArray alloc]init];
    array = [userDefault objectForKey:@"stagescore"];
    for(int i=0;i<stage;i++){
        score = score+[[array objectAtIndex:i]intValue];
    }
    return score;
}


//====================
//ハイスコアの保存
//====================
+(void)save_High_Score:(long)value
{
    NSUserDefaults  *userDefault=[NSUserDefaults standardUserDefaults];
    NSNumber* score=[NSNumber numberWithLong:value];
    [userDefault setObject:score forKey:@"highscore"];
    [userDefault synchronize];
}

//====================
//ハイスコアの取得
//====================
+(long)load_High_Score
{
    NSUserDefaults  *userDefault=[NSUserDefaults standardUserDefaults];
    long score=[[userDefault objectForKey:@"highscore"]longValue];
    return score;
}
//====================
//勝ち点の保存
//====================
+(void)save_Match_Point:(int)value
{
    NSUserDefaults  *userDefault=[NSUserDefaults standardUserDefaults];
    NSNumber* point=[NSNumber numberWithInt:value];
    [userDefault setObject:point forKey:@"point"];
    [userDefault synchronize];
}
//====================
//勝ち点の取得
//====================
+(int)load_Match_Point
{
    NSUserDefaults  *userDefault=[NSUserDefaults standardUserDefaults];
    int point=[[userDefault objectForKey:@"point"]intValue];
    return point;
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

//=========================================
//　コインの取得
//=========================================
+(int)load_Coin
{
    NSUserDefaults  *userDefault=[NSUserDefaults standardUserDefaults];
    int coin=[[userDefault objectForKey:@"coin"]intValue];
    return coin;
}
//=========================================
//　コインの保存
//=========================================
+(void)save_Coin:(int)value
{
    NSUserDefaults  *userDefault=[NSUserDefaults standardUserDefaults];
    NSNumber* coin=[NSNumber numberWithInt:value];
    [userDefault setObject:coin forKey:@"coin"];
}

//=========================================
//　ログイン日の取得
//=========================================
+(NSDate*)load_Login_Date
{
    NSUserDefaults  *userDefault=[NSUserDefaults standardUserDefaults];
    NSDate* date =[userDefault objectForKey:@"LoginDate"];
    return date;
}

//=========================================
//　ログイン日の保存
//=========================================
+(void)save_login_Date:(NSDate*)date
{
    //日付のみに変換
    NSCalendar *calen = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents *comps = [calen components:unitFlags fromDate:date];
    //[comps setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];//GMTで貫く
    NSDate *date_ = [calen dateFromComponents:comps];
    
    NSUserDefaults  *userDefault=[NSUserDefaults standardUserDefaults];
    [userDefault setObject:date_ forKey:@"LoginDate"];
}

//=========================================
//　初戦開始フラグ
//=========================================
+(void)save_First_Battle:(bool)flg
{
    NSUserDefaults  *userDefault=[NSUserDefaults standardUserDefaults];
    NSNumber* firstBattle=[NSNumber numberWithBool:flg];
    [userDefault setObject:firstBattle forKey:@"FirstBattle"];
}

//=========================================
//　特典付与フラグ
//=========================================
+(void)save_Gift_Acquired:(NSString*)giftKey flg:(bool)flg
{
    NSUserDefaults  *userDefault=[NSUserDefaults standardUserDefaults];
    NSNumber* gift=[NSNumber numberWithBool:flg];
    [userDefault setObject:gift forKey:giftKey];
}

//=========================================
//GameCenterへスコアを送信
//=========================================
+(void)submit_Score_GameCenter:(NSInteger)score
{
    GKScore *scoreReporter = [[GKScore alloc] initWithCategory:@"VirginTech3rdProject_Leaderboard_01"];
    NSInteger scoreR = score;
    scoreReporter.value = scoreR;
    [scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
        if (error != nil){
            NSLog(@"Error in reporting score %@",error);
        }
    }];
}

//=========================================
//GameCenterへ勝ち点を送信
//=========================================
+(void)submit_Points_GameCenter:(NSInteger)points
{
    GKScore *scoreReporter = [[GKScore alloc] initWithCategory:@"VirginTech3rdProject_Leaderboard_02"];
    NSInteger scoreR = points;
    scoreReporter.value = scoreR;
    [scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
        if (error != nil){
            NSLog(@"Error in reporting score %@",error);
        }
    }];
}

@end
