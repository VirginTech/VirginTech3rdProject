//
//  MatchMakeScene.m
//  VirginTech3rdProject
//
//  Created by VirginTech LLC. on 2014/11/27.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "MatchMakeScene.h"
#import "GameManager.h"
#import "BasicMath.h"
#import "TitleScene.h"
#import "Fortress.h"
#import "mPlayer.h"
#import "mEnemy.h"

//対戦データ送信用 構造体
struct Battle_Data {
    int objId;//個別ID
    int group;//青:0 赤:1
    float posX;//posX
    float posY;//posY
    float angle;//ターゲットアングル
    bool stopFlg;//停止
    bool dieFlg;//生死
};
typedef struct Battle_Data Battle_Data;

//オブジェクト配置用 構造体
struct CreateObj_Data {
    float posX;//posX
    float posY;//posY
};
typedef struct CreateObj_Data CreateObj_Data;

@implementation MatchMakeScene

CGSize winSize;
GKMatch* battleMatch;

CGSize offSet;
CGPoint touchPos;
bool createObjectFlg;

mPlayer* m_player;
NSMutableArray* playerArray;
NSMutableArray* removePlayerArray;

mEnemy* m_enemy;
NSMutableArray* enemyArray;
NSMutableArray* removeEnemyArray;

Fortress* playerFortress;
Fortress* enemyFortress;
bool gameEndFlg;

NSMutableArray* battleDataArray;

//カウンター
int pMaxCnt;
int pTotalCnt;
int pCnt;
int eMaxCnt;
int eTotalCnt;
int eCnt;

//デバッグラベル
CCLabelTTF* lbl_1;
CCLabelTTF* debugLabel1;
CCLabelTTF* debugLabel2;
CCLabelTTF* debugLabel3;
CCLabelTTF* debugLabel4;
CCLabelTTF* debugLabel5;

+(GKMatch*)getCurrentMatch
{
    return battleMatch;
}
+(void)setCurrentMatch:(GKMatch*)match
{
    battleMatch=match;
}

+(MatchMakeScene *)scene
{
    return [[self alloc] init];
}

//==============================================//

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    winSize=[[CCDirector sharedDirector]viewSize];

    self.userInteractionEnabled = YES;
    
    //GKMatchデリゲート
    battleMatch.delegate=self;
    
    //初期化
    gameEndFlg=false;
    
    playerArray=[[NSMutableArray alloc]init];
    enemyArray=[[NSMutableArray alloc]init];
    createObjectFlg=false;
    
    pTotalCnt=0;
    pCnt=0;
    pMaxCnt=250;
    
    eTotalCnt=0;
    eCnt=0;
    eMaxCnt=250;
    
    //アイテム初期化
    [GameManager setItem:0];//アイテム選択なし
    
    //ワールドサイズ（iPhone4に合わせた画面の大きさ）
    [GameManager setWorldSize:CGSizeMake(320, 480)];
    
    //オフセット量
    offSet.width=(winSize.width-[GameManager getWorldSize].width)/2;
    offSet.height=(winSize.height-[GameManager getWorldSize].height)/2;
    //NSLog(@"winSizeX=%f : winSizeY=%f",winSize.width,winSize.height);

    // Create a colored background (Dark Grey)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];
    [self addChild:background];
    
    // Create a back button
    CCButton *backButton = [CCButton buttonWithTitle:@"[タイトル]" fontName:@"Verdana-Bold" fontSize:15.0f];
    backButton.positionType = CCPositionTypeNormalized;
    backButton.position = ccp(0.9f, 0.95f); // Top Right of screen
    [backButton setTarget:self selector:@selector(onBackClicked:)];
    [self addChild:backButton];
    
    //ワールドライン描画
    CCDrawNode* worldLine_v1=[CCDrawNode node];//左縦
    [worldLine_v1 drawSegmentFrom:ccp(offSet.width+0,offSet.height+0)
                            to:ccp(offSet.width+0,offSet.height+[GameManager getWorldSize].height)
                            radius:0.5
                            color:[CCColor whiteColor]];
    [self addChild:worldLine_v1];

    CCDrawNode* worldLine_v2=[CCDrawNode node];//右縦
    [worldLine_v2 drawSegmentFrom:ccp(offSet.width+[GameManager getWorldSize].width,offSet.height+0)
                               to:ccp(offSet.width+[GameManager getWorldSize].width,offSet.height+[GameManager getWorldSize].height)
                           radius:0.5
                            color:[CCColor whiteColor]];
    [self addChild:worldLine_v2];

    CCDrawNode* worldLine_h1=[CCDrawNode node];//下横
    [worldLine_h1 drawSegmentFrom:ccp(offSet.width+0,offSet.height+0)
                               to:ccp(offSet.width+[GameManager getWorldSize].width,offSet.height+0)
                           radius:0.5
                            color:[CCColor whiteColor]];
    [self addChild:worldLine_h1];

    CCDrawNode* worldLine_h2=[CCDrawNode node];//上横
    [worldLine_h2 drawSegmentFrom:ccp(offSet.width+0,offSet.height+[GameManager getWorldSize].height)
                               to:ccp(offSet.width+[GameManager getWorldSize].width,offSet.height+[GameManager getWorldSize].height)
                           radius:0.5
                            color:[CCColor whiteColor]];
    [self addChild:worldLine_h2];
    
    //デバッグラベル
    if([GameManager getHost]){
        lbl_1=[CCLabelTTF labelWithString:@"サーバー" fontName:@"Verdana-Bold" fontSize:15];
    }else{
        lbl_1=[CCLabelTTF labelWithString:@"クライアント" fontName:@"Verdana-Bold" fontSize:15];
    }
    lbl_1.position=ccp(lbl_1.contentSize.width/2,winSize.height-lbl_1.contentSize.height/2);
    [self addChild:lbl_1];
    
    //デバッグラベル
    debugLabel1=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"PlayerMax=%d",pMaxCnt] fontName:@"Verdana-Bold" fontSize:10];
    debugLabel1.position=ccp(debugLabel1.contentSize.width/2, lbl_1.position.y -debugLabel1.contentSize.height-20);
    [self addChild:debugLabel1];
    
    debugLabel2=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"EnemyMax=%d",eMaxCnt] fontName:@"Verdana-Bold" fontSize:10];
    debugLabel2.position=ccp(debugLabel2.contentSize.width/2, debugLabel1.position.y-debugLabel2.contentSize.height);
    [self addChild:debugLabel2];
    
    debugLabel3=[CCLabelTTF labelWithString:@"青=000 赤=000" fontName:@"Verdana-Bold" fontSize:10];
    debugLabel3.position=ccp(debugLabel3.contentSize.width/2, debugLabel2.position.y-debugLabel3.contentSize.height);
    [self addChild:debugLabel3];
    
    debugLabel4=[CCLabelTTF labelWithString:@"pTotal=0000" fontName:@"Verdana-Bold" fontSize:10];
    debugLabel4.position=ccp(debugLabel4.contentSize.width/2, debugLabel3.position.y-debugLabel4.contentSize.height);
    [self addChild:debugLabel4];
    
    debugLabel5=[CCLabelTTF labelWithString:@"eTotle=0000" fontName:@"Verdana-Bold" fontSize:10];
    debugLabel5.position=ccp(debugLabel5.contentSize.width/2, debugLabel4.position.y-debugLabel5.contentSize.height);
    [self addChild:debugLabel5];
    
    return self;
}

-(void)dealloc
{
    // clean up code goes here
    battleMatch.delegate=nil;
    [battleMatch disconnect];
}

-(void)onEnter
{
    // always call super onEnter first
    [super onEnter];
    
    //城作成
    if([GameManager getHost]){
        playerFortress=[Fortress createFortress:ccp(offSet.width+[GameManager getWorldSize].width/2,offSet.height+15) type:0];
        [self addChild:playerFortress];
        enemyFortress=[Fortress createFortress:ccp(offSet.width+[GameManager getWorldSize].width/2,offSet.height+[GameManager getWorldSize].height-15) type:1];
        [self addChild:enemyFortress];
    }else{
        enemyFortress=[Fortress createFortress:ccp(offSet.width+[GameManager getWorldSize].width/2,offSet.height+15) type:1];
        [self addChild:enemyFortress];
        playerFortress=[Fortress createFortress:ccp(offSet.width+[GameManager getWorldSize].width/2,offSet.height+[GameManager getWorldSize].height-15) type:0];
        [self addChild:playerFortress];
    }
    
    //我陣地ライン
    CCDrawNode* drawNode1=[CCDrawNode node];
    [drawNode1 drawSegmentFrom:ccp(offSet.width+0,offSet.height+[GameManager getWorldSize].height*0.2)
                            to:ccp(offSet.width+[GameManager getWorldSize].width,offSet.height+[GameManager getWorldSize].height*0.2)
                        radius:0.5
                         color:[CCColor whiteColor]];
    [self addChild:drawNode1];
    
    //敵陣地ライン
    CCDrawNode* drawNode2=[CCDrawNode node];
    [drawNode2 drawSegmentFrom:ccp(offSet.width+0,offSet.height+[GameManager getWorldSize].height*0.8)
                            to:ccp(offSet.width+[GameManager getWorldSize].width,offSet.height+[GameManager getWorldSize].height*0.8)
                        radius:0.5
                         color:[CCColor whiteColor]];
    [self addChild:drawNode2];
    
    //センターライン
    CCDrawNode* drawNode5=[CCDrawNode node];
    [drawNode5 drawSegmentFrom:ccp(offSet.width+0,offSet.height+[GameManager getWorldSize].height/2)
                            to:ccp(offSet.width+[GameManager getWorldSize].width,offSet.height+[GameManager getWorldSize].height/2)
                        radius:0.5
                         color:[CCColor yellowColor]];
    [self addChild:drawNode5];
    
    //審判スケジュール開始
    if([GameManager getHost]){//ホストだったら
        [self schedule:@selector(judgement_Schedule:)interval:0.1];
    }else{
        [self schedule:@selector(status_Schedule:)interval:0.1];
    }
}

-(void)onExit
{
    // always call super onExit last
    [super onExit];
}

//=========================
//サーバー・スケジュール
//=========================
-(void)judgement_Schedule:(CCTime)dt
{
    //初期化
    removePlayerArray=[[NSMutableArray alloc]init];
    removeEnemyArray=[[NSMutableArray alloc]init];
    
    float collisSurfaceAngle;//衝突面角度
    
    //**********************
    //プレイヤージャッジメント
    //**********************
    for(mPlayer* _player in playerArray){
        if(_player.mode==0){
            _player.stopFlg=false;
            _player.targetAngle=[BasicMath getAngle_To_Radian:_player.position
                                                         ePos:ccp(_player.position.x,_player.position.y+1.0f)];
        }
        //================
        //近隣プレイヤー捜索
        //================
        _player.nearPlayerCnt=0;
        for(mPlayer* _player1 in playerArray){
            if([BasicMath RadiusIntersectsRadius:_player.position
                                          pointB:_player1.position
                                         radius1:(_player.contentSize.width*_player.scale+20)
                                         radius2:(_player1.contentSize.width*_player1.scale+20)])
            {
                _player.nearPlayerCnt++;
            }
        }
        //「敵」配列入れ替え
        if(enemyArray.count>0){
            [enemyArray addObject:[enemyArray objectAtIndex:0]];
            [enemyArray removeObjectAtIndex:0];
        }
        for(mEnemy* _enemy in enemyArray){
            /*/====================
             //衝突「戦闘」判定
             //====================
             if([BasicMath RadiusIntersectsRadius:_player.position
             pointB:_enemy.position
             radius1:(_player.contentSize.width*_player.scale-5)
             radius2:(_enemy.contentSize.width*_enemy.scale-5)]){
             
             if(!_player.stopFlg){
             [removePlayerArray addObject:_player];
             }
             if(!_enemy.stopFlg){
             [removeEnemyArray addObject:_enemy];
             }
             
             _player.stopFlg=true;
             _enemy.stopFlg=true;
             
             _player.targetAngle=[BasicMath getAngle_To_Radian:_player.position ePos:_enemy.position];
             _enemy.targetAngle=[BasicMath getAngle_To_Radian:_enemy.position ePos:_player.position];
             
             _player.mode=3;
             _enemy.mode=3;
             
             break;
             
             //====================
             //プレイヤー逃避判定
             //====================
             }else*/if([BasicMath RadiusIntersectsRadius:_player.position
                                                  pointB:_enemy.position
                                                 radius1:(_player.contentSize.width*_player.scale+15)
                                                 radius2:(_enemy.contentSize.width*_enemy.scale+15)])
             {
                 
                 if(_player.itemNum!=3){//突撃モードでなければ
                     if(_player.mode!=1){
                         if(_player.nearPlayerCnt < _enemy.nearEnemyCnt){
                             if(_player.position.y>offSet.height+[GameManager getWorldSize].height*0.25){
                                 collisSurfaceAngle = [self getCollisSurfaceAngle:_player.position pos2:_enemy.position];
                                 _player.targetAngle = 2*collisSurfaceAngle-(_player.targetAngle+collisSurfaceAngle);
                                 _player.targetAngle = [BasicMath getNormalize_Radian:_player.targetAngle];
                                 _player.mode=1;
                             }
                         }
                     }
                 }
                 break;
             }
            //====================
            //プレイヤー追撃判定
            //====================
             else if([BasicMath RadiusIntersectsRadius:_player.position
                                                pointB:_enemy.position
                                               radius1:(_player.contentSize.width*_player.scale+30)
                                               radius2:(_enemy.contentSize.width*_enemy.scale+30)]){
                 
                 if(_player.itemNum!=3){//突撃モードでなければ
                     if(_player.mode!=2){
                         if(_enemy.nearEnemyCnt <= _player.nearPlayerCnt){
                             _player.targetAngle=[BasicMath getAngle_To_Radian:_player.position ePos:_enemy.position];
                             _player.mode=2;
                         }
                         if(_player.position.y<offSet.height+[GameManager getWorldSize].height*0.25){
                             _player.targetAngle=[BasicMath getAngle_To_Radian:_player.position ePos:_enemy.position];
                             _player.mode=2;
                         }
                     }
                 }
                 break;
             }
        }
    }
    
    //********************
    //敵ジャッジメント
    //********************
    for(mEnemy* _enemy in enemyArray){
        if(_enemy.mode==0){
            _enemy.stopFlg=false;
            _enemy.targetAngle=[BasicMath getAngle_To_Radian:_enemy.position
                                                        ePos:ccp(_enemy.position.x,_enemy.position.y-1.0f)];
        }
        //==============
        //近隣「敵」捜索
        //==============
        _enemy.nearEnemyCnt=0;
        for(mEnemy* _enemy1 in enemyArray){
            if([BasicMath RadiusIntersectsRadius:_enemy.position
                                          pointB:_enemy1.position
                                         radius1:(_enemy.contentSize.width*_enemy.scale+20)
                                         radius2:(_enemy1.contentSize.width*_enemy1.scale+20)])
            {
                _enemy.nearEnemyCnt++;
            }
        }
        //「敵」配列入れ替え
        if(playerArray.count>0){
            [playerArray addObject:[playerArray objectAtIndex:0]];
            [playerArray removeObjectAtIndex:0];
        }
        for(mPlayer* _player in playerArray){
            //====================
            //「敵」逃避判定
            //====================
            if([BasicMath RadiusIntersectsRadius:_enemy.position
                                          pointB:_player.position
                                         radius1:(_enemy.contentSize.width*_enemy.scale+15)
                                         radius2:(_player.contentSize.width*_player.scale+15)])
            {
                
                if(_enemy.mode!=1){
                    if(_player.nearPlayerCnt > _enemy.nearEnemyCnt){
                        if(_enemy.position.y<offSet.height+[GameManager getWorldSize].height*0.75){
                            collisSurfaceAngle = [self getCollisSurfaceAngle:_enemy.position pos2:_player.position];
                            _enemy.targetAngle = 2*collisSurfaceAngle-(_enemy.targetAngle+collisSurfaceAngle);
                            _enemy.targetAngle = [BasicMath getNormalize_Radian:_enemy.targetAngle];
                            _enemy.mode=1;
                        }
                    }
                }
                break;
            }
            //====================
            //「敵」追撃判定
            //====================
            else if([BasicMath RadiusIntersectsRadius:_enemy.position
                                               pointB:_player.position
                                              radius1:(_enemy.contentSize.width*_enemy.scale+30)
                                              radius2:(_player.contentSize.width*_player.scale+30)])
            {
                if(_enemy.mode!=2){
                    if(_enemy.nearEnemyCnt >= _player.nearPlayerCnt){
                        _enemy.targetAngle=[BasicMath getAngle_To_Radian:_enemy.position ePos:_player.position];
                        _enemy.mode=2;
                    }
                    if(_enemy.position.y>offSet.height+[GameManager getWorldSize].height*0.75){
                        _enemy.targetAngle=[BasicMath getAngle_To_Radian:_enemy.position ePos:_player.position];
                        _enemy.mode=2;
                    }
                }
                break;
            }
        }
    }
    
    //==============
    //戦闘判定（停止）
    //==============
    for(mPlayer* _player in playerArray){
        for(mEnemy* _enemy in enemyArray){
            if([BasicMath RadiusIntersectsRadius:_player.position
                                          pointB:_enemy.position
                                         radius1:(_player.contentSize.width*_player.scale)/2
                                         radius2:(_enemy.contentSize.width*_enemy.scale)/2])
            {
                _player.stopFlg=true;
                _enemy.stopFlg=true;
                
                _player.targetAngle=[BasicMath getAngle_To_Radian:_player.position ePos:_enemy.position];
                _enemy.targetAngle=[BasicMath getAngle_To_Radian:_enemy.position ePos:_player.position];
                
                _player.mode=3;
                _enemy.mode=3;
                
                //==================
                //アイテムごとによる攻撃
                //==================
                if(_player.itemNum==1){//爆弾
                    for(mEnemy* _enemy_ in enemyArray){
                        if([BasicMath RadiusContainsPoint:_player.position
                                                   pointB:_enemy_.position
                                                   radius:50])
                        {
                            _enemy_.ability=0;
                        }
                    }
                    _player.itemNum=0;
                }else if(_player.itemNum==4){//攻撃アップ
                    _player.ability--;
                    _enemy.ability-=3;
                }else{//通常・その他
                    _player.ability--;
                    _enemy.ability--;
                }
                
                break;
            }
        }
    }
    
    //==============
    //陣地内判定
    //==============
    for(mPlayer* _player in playerArray){
        //敵陣地内に入ったら
        if(_player.mode!=3){//戦闘以外だったら
            if(_player.position.y>offSet.height+[GameManager getWorldSize].height*0.8){
                _player.targetAngle=[BasicMath getAngle_To_Radian:_player.position ePos:enemyFortress.position];
            }
        }
    }
    
    for(mEnemy* _enemy in enemyArray){
        //プレイヤー陣地内に入ったら
        if(_enemy.mode!=3){//戦闘以外だったら
            if(_enemy.position.y<offSet.height+[GameManager getWorldSize].height*0.2){
                _enemy.targetAngle=[BasicMath getAngle_To_Radian:_enemy.position ePos:playerFortress.position];
            }
        }
    }
    
    //===================
    //消滅オブジェクト削除
    //===================
    for(mPlayer* _player in playerArray){
        if(_player.ability<=0){
            [removePlayerArray addObject:_player];
        }
    }
    for(mEnemy* _enemy in enemyArray){
        if(_enemy.ability<=0){
            [removeEnemyArray addObject:_enemy];
        }
    }
    [self removeObject];
    
    //===============
    //戦闘後復帰処理
    //===============
    for(mPlayer* _player in playerArray){
        if(_player.mode==3){
            bool hitFlg=false;
            for(mEnemy* _enemy in enemyArray){
                if([BasicMath RadiusIntersectsRadius:_player.position
                                              pointB:_enemy.position
                                             radius1:(_player.contentSize.width*_player.scale)/2
                                             radius2:(_enemy.contentSize.width*_enemy.scale)/2])
                {
                    hitFlg=true;
                    break;
                }
            }
            if(!hitFlg){
                _player.mode=0;
                _player.stopFlg=false;
            }
        }
    }
    for(mEnemy* _enemy in enemyArray){
        if(_enemy.mode==3){
            bool hitFlg=false;
            for(mPlayer* _player in playerArray){
                if([BasicMath RadiusIntersectsRadius:_enemy.position
                                              pointB:_player.position
                                             radius1:(_enemy.contentSize.width*_enemy.scale)/2
                                             radius2:(_player.contentSize.width*_player.scale)/2])
                {
                    hitFlg=true;
                    break;
                }
            }
            if(!hitFlg){
                _enemy.mode=0;
                _enemy.stopFlg=false;
            }
        }
    }
    
    //=================
    //陣地攻撃
    //=================
    for(mPlayer* _player in playerArray){
        if([BasicMath RadiusIntersectsRadius:_player.position
                                      pointB:enemyFortress.position
                                     radius1:(_player.contentSize.width*_player.scale)/2
                                     radius2:(enemyFortress.contentSize.width*enemyFortress.scale)/2])
        {
            if(!gameEndFlg){
                _player.stopFlg=true;
                enemyFortress.ability--;
                if(enemyFortress.ability<=0){
                    [self removeChild:enemyFortress cleanup:YES];
                    gameEndFlg=true;
                }
            }
        }
    }
    for(mEnemy* _enemy in enemyArray){
        if([BasicMath RadiusIntersectsRadius:_enemy.position
                                      pointB:playerFortress.position
                                     radius1:(_enemy.contentSize.width*_enemy.scale)/2
                                     radius2:(playerFortress.contentSize.width*playerFortress.scale)/2])
        {
            if(!gameEndFlg){
                _enemy.stopFlg=true;
                playerFortress.ability--;
                if(playerFortress.ability<=0){
                    [self removeChild:playerFortress cleanup:YES];
                    gameEndFlg=true;
                }
            }
        }
    }
    
    //=============
    //ゲーム終了停止
    //=============
    if(gameEndFlg){
        for(mPlayer* _player in playerArray){
            _player.stopFlg=true;
        }
        for(mEnemy* _enemy in enemyArray){
            _enemy.stopFlg=true;
        }
        [self unscheduleAllSelectors];
    }  
    
    //===================
    // メッセージデータ送信
    //===================
    battleDataArray=[[NSMutableArray alloc]init];
    Battle_Data battleData;
    NSData* data;
    
    for(mPlayer* _player in playerArray){
        battleData.objId=_player.objId;
        battleData.group=_player.group;
        battleData.posX=_player.position.x;
        battleData.posY=_player.position.y;
        battleData.angle=_player.targetAngle;
        battleData.stopFlg=_player.stopFlg;
        battleData.dieFlg=false;//仮
        data=[NSData dataWithBytes:&battleData length:sizeof(Battle_Data)];
        [battleDataArray addObject:data];
    }
    for(mEnemy* _enemy in enemyArray){
        battleData.objId=_enemy.objId;
        battleData.group=_enemy.group;
        battleData.posX=_enemy.position.x;
        battleData.posY=_enemy.position.y;
        battleData.angle=_enemy.targetAngle;
        battleData.stopFlg=_enemy.stopFlg;
        battleData.dieFlg=false;//仮
        data=[NSData dataWithBytes:&battleData length:sizeof(Battle_Data)];
        [battleDataArray addObject:data];
    }
    if(battleDataArray.count>0){
        [self sendData_BattleData:battleDataArray];
    }
    
    //デバッグラベル更新
    debugLabel3.string=[NSString stringWithFormat:@"青=%03d 赤=%03d",pCnt,eCnt];
    debugLabel4.string=[NSString stringWithFormat:@"pTotle=%04d",pTotalCnt];
    debugLabel5.string=[NSString stringWithFormat:@"eTotle=%04d",eTotalCnt];
}

//============================
// 衝突面アングル算出
//============================
-(float)getCollisSurfaceAngle:(CGPoint)pos1 pos2:(CGPoint)pos2
{
    float angle;
    
    float inAngle=[BasicMath getAngle_To_Degree:pos1 ePos:pos2];
    
    if(inAngle>=315 || inAngle<45){//上
        angle = [BasicMath getAngle_To_Radian:pos1 ePos:pos2]-M_PI_2;
    }else if(inAngle>=45 && inAngle<135){//右
        angle = [BasicMath getAngle_To_Radian:pos1 ePos:pos2]-M_PI;
    }else if(inAngle>=135 && inAngle<225){//下
        angle = [BasicMath getAngle_To_Radian:pos1 ePos:pos2]+M_PI_2;
    }else if(inAngle>=225 && inAngle<315){//左
        angle = [BasicMath getAngle_To_Radian:pos1 ePos:pos2]+M_PI * 2;
    }
    angle=[BasicMath getNormalize_Radian:angle];
    return angle;
}

//============================
// オブジェクト削除
//============================
-(void)removeObject
{
    for(mPlayer* _player in removePlayerArray)
    {
        [playerArray removeObject:_player];
        [self removeChild:_player cleanup:YES];
        pCnt--;
    }
    for(mEnemy* _enemy in removeEnemyArray)
    {
        [enemyArray removeObject:_enemy];
        [self removeChild:_enemy cleanup:YES];
        eCnt--;
    }
}

//=========================
//クライアント・スケジュール
//=========================
-(void)status_Schedule:(CCTime)dt
{
    //デバッグラベル更新
    debugLabel3.string=[NSString stringWithFormat:@"青=%03d 赤=%03d",pCnt,eCnt];
    debugLabel4.string=[NSString stringWithFormat:@"pTotle=%04d",pTotalCnt];
    debugLabel5.string=[NSString stringWithFormat:@"eTotle=%04d",eTotalCnt];
}

-(void)create_Object_Schedule:(CCTime)dt
{
    if(touchPos.y<offSet.height+[GameManager getWorldSize].height*0.2){
        if([GameManager getHost]){//青(Player)
            if(pCnt<40 && pTotalCnt<pMaxCnt){
                m_player=[mPlayer createPlayer:pTotalCnt pos:touchPos];
                [self addChild:m_player];
                [playerArray addObject:m_player];
                pCnt++;
                pTotalCnt++;
                //データ送信
                [self sendData_CreateObject:touchPos];
            }else{
                //カウント超過停止
                createObjectFlg=false;
                [self unschedule:@selector(create_Object_Schedule:)];
            }
        }else{//赤(Enemy)
            if(eCnt<40 && eTotalCnt<eMaxCnt){
                m_enemy=[mEnemy createEnemy:eTotalCnt pos:touchPos];
                [self addChild:m_enemy];
                [enemyArray addObject:m_enemy];
                eCnt++;
                eTotalCnt++;
                //データ送信
                [self sendData_CreateObject:touchPos];
            }else{
                //カウント超過停止
                createObjectFlg=false;
                [self unschedule:@selector(create_Object_Schedule:)];
            }
        }
    }else{
        //陣地外停止
        createObjectFlg=false;
        [self unschedule:@selector(create_Object_Schedule:)];
    }

}

-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [touch locationInNode:self];
    touchPos=touchLocation;
 
    //プレイヤー作成
    if(touchLocation.y<offSet.height+[GameManager getWorldSize].height*0.2){
        if(!createObjectFlg){
            //プレイヤー生成スケジュール開始
            [self schedule:@selector(create_Object_Schedule:)interval:0.1 repeat:CCTimerRepeatForever delay:0.15f];
            createObjectFlg=true;
        }
    }
}

-(void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [touch locationInNode:self];
    
    if(touchLocation.y<offSet.height+[GameManager getWorldSize].height*0.2+50)
    {
        touchPos=touchLocation;
    }
}

-(void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    //タッチアップ停止
    CGPoint touchLocation = [touch locationInNode:self];
    
    if(touchLocation.y<offSet.height+[GameManager getWorldSize].height*0.5){
        if(createObjectFlg){
            createObjectFlg=false;
            [self unschedule:@selector(create_Object_Schedule:)];
        }
    }
}

-(void)onBackClicked:(id)sender
{
    // back to intro scene with transition
    battleMatch.delegate=nil;
    [battleMatch disconnect];
    [[CCDirector sharedDirector] replaceScene:[TitleScene scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];
    
}

-(void)match:(GKMatch *)match player:(NSString *)playerID didChangeState:(GKPlayerConnectionState)state
{
    switch (state)
    {
        case GKPlayerStateConnected:
            // 新規のプレーヤー接続を処理する
            break;
        case GKPlayerStateDisconnected:
            // プレーヤーが切断した場合
            NSLog(@"切断されました");
            break;
        default:
            break;
    }
    if (match.expectedPlayerCount == 0)
    {
        // ゲーム開始の処理
    }
}

//==========================
// 　　　送信メソッド
//==========================
-(void)sendData_BattleData:(NSMutableArray*)array;
{
    NSError *error = nil;
    
    //ヘッダー番号付与
    int header=1;
    NSMutableData* tmpData=[NSMutableData dataWithBytes:&header length:sizeof(header)];//ヘッダー部
    NSData *packetData = [NSKeyedArchiver archivedDataWithRootObject:array];//本体部
    //合体
    [tmpData appendData:packetData];
    //送信
    [battleMatch sendDataToAllPlayers:tmpData withDataMode:GKMatchSendDataUnreliable error:&error];
    
    if (error != nil){
        NSLog(@"%@",error);
    }
}

-(void)sendData_CreateObject:(CGPoint)_pos;
{
    CreateObj_Data createData;

    createData.posX=_pos.x-offSet.width;
    createData.posY=_pos.y-offSet.height;

    NSError *error = nil;

    //ヘッダー番号付与
    int header=0;
    NSMutableData* tmpData=[NSMutableData dataWithBytes:&header length:sizeof(header)];//ヘッダー部
    NSData *packetData = [NSData dataWithBytes:&createData length:sizeof(CreateObj_Data)];//本体部
    //合体
    [tmpData appendData:packetData];
    //送信
    [battleMatch sendDataToAllPlayers:tmpData withDataMode:GKMatchSendDataUnreliable error:&error];
    
    if (error != nil){
        NSLog(@"%@",error);
    }
}
//==========================
// 　　　受信メソッド
//==========================
-(void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID
{
    //ヘッダー番号の取り出し
    int *header=malloc(sizeof(*header));//メモリー確保
    memset(header, 0, sizeof(*header));//初期化
    [data getBytes:header range:NSMakeRange(0, sizeof(*header))];//部分コピー
    int _msgNum=*header;
    free(header);//解放

    //本体の取り出し
    long diffLength=data.length-sizeof(*header);//本体サイズ取得
    char *msg=malloc(diffLength);//メモリー確保
    memset(msg, 0, diffLength);//初期化
    [data getBytes:msg range:NSMakeRange(sizeof(*header), diffLength)];//部分コピー
    
    //======================
    // オブジェクト配置
    //======================
    if(_msgNum==0)
    {
        //構造体へ代入
        CreateObj_Data* createData=(CreateObj_Data*)msg;

        //対称軸へ置く
        float _x=winSize.width-createData->posX-offSet.width;
        float _y=winSize.height-createData->posY-offSet.height;
        
        //同じ位置なら
        //float _x=createObj->posX+offSet.width;
        //float _y=createObj->posY+offSet.height;
        
        if([GameManager getHost]){
            m_enemy=[mEnemy createEnemy:eTotalCnt pos:ccp(_x,_y)];
            [self addChild:m_enemy];
            [enemyArray addObject:m_enemy];
            eCnt++;
            eTotalCnt++;
        }else{
            m_player=[mPlayer createPlayer:pTotalCnt pos:ccp(_x,_y)];
            [self addChild:m_player];
            [playerArray addObject:m_player];
            pCnt++;
            pTotalCnt++;
        }
    }
    //======================
    // 対戦データ受信
    //======================
    else if(_msgNum==1)
    {
        //NSDataへ変換
        NSData* dData=[NSData dataWithBytes:msg length:diffLength];
        //配列の復元
        NSArray* array = [NSKeyedUnarchiver unarchiveObjectWithData:dData];
        //構造体へ
        for(NSData* _data in array)
        {
            Battle_Data* battleData=(Battle_Data*)[_data bytes];
            int objId=battleData->objId;//個別ID
            int group=battleData->group;//青:0 赤:1
            float posX=battleData->posX;//posX
            float posY=battleData->posY;//posY
            float angle=battleData->angle;//ターゲットアングル
            bool stopFlg=battleData->stopFlg;//停止
            bool dieFlg=battleData->dieFlg;//生死
            
            NSLog(@"ObjID=%d PosX=%f PosY=%f Angle=%f",objId,posX,posY,angle);
        }
        NSLog(@"--------------------");
    }
    //======================
    //
    //======================
    else{
        
    }

    free(msg);
}

@end
