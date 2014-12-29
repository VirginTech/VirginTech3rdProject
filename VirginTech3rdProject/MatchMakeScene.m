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
#import "MatchWaitLayer.h"
#import "NaviLayer.h"
#import "InfoLayer.h"
#import "ResultsLayer.h"

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
    int ability;//アビリティ
    bool stopFlg;//停止
    int mode;//状態モード
};
typedef struct Battle_Data Battle_Data;

//オブジェクト配置用 構造体
struct CreateObj_Data {
    float posX;//posX
    float posY;//posY
};
typedef struct CreateObj_Data CreateObj_Data;

//陣地アビリティ送信用 構造体
struct Fortress_Data {
    int pAbility;//プレイヤーアビリティ
    int eAbility;//エネミーアビリティ
};
typedef struct Fortress_Data Fortress_Data;

@implementation MatchMakeScene

CGSize winSize;
GKMatch* battleMatch;

InfoLayer* infoLayer;

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

//パーティクル
CCParticleSystem* dieParticle;

//カウンター
//int pMaxCnt;
//int pTotalCnt;
//int pCnt;
//int eMaxCnt;
//int eTotalCnt;
//int eCnt;

//対戦準備レイヤー
MatchWaitLayer* mWaitLayer;
MessageLayer* msgBox;
NaviLayer* naviLayer;

//デバッグラベル
//CCLabelTTF* lbl_1;
//CCLabelTTF* lbl_2;
//CCLabelTTF* debugLabel1;
//CCLabelTTF* debugLabel2;
//CCLabelTTF* debugLabel3;
//CCLabelTTF* debugLabel4;
//CCLabelTTF* debugLabel5;

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
    //NSLog(@"%@",battleMatch.playerIDs);
    
    //初期化
    TURN_OBJ_MAX=50;
    gameEndFlg=false;
    playerArray=[[NSMutableArray alloc]init];
    enemyArray=[[NSMutableArray alloc]init];
    createObjectFlg=false;
    [GameManager setPause:false];
    dieParticle=nil;
    
    //アイテム初期化
    [GameManager setItem:0];//アイテム選択なし
    
    //インフォレイヤー
    infoLayer=[[InfoLayer alloc]init];
    [self addChild:infoLayer z:1];
    
    //対戦準備レイヤー
    mWaitLayer=[[MatchWaitLayer alloc]init];
    [self addChild:mWaitLayer z:2];//最上位へ
    
    //ナビレイヤー
    naviLayer=[[NaviLayer alloc]init];
    [self addChild:naviLayer z:TURN_OBJ_MAX+1];
    
    //ワールドサイズ（iPhone4に合わせた画面の大きさ）
    [GameManager setWorldSize:CGSizeMake(320, 480)];
    
    //オフセット量
    offSet.width=(winSize.width-[GameManager getWorldSize].width)/2;
    offSet.height=(winSize.height-[GameManager getWorldSize].height)/2;
    //NSLog(@"winSizeX=%f : winSizeY=%f",winSize.width,winSize.height);

    // Create a colored background (Dark Grey)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];
    [self addChild:background];
    
    //地面配置
    [self setGround];
    [self setYard];
    
    /*/ Create a back button
    CCButton *backButton = [CCButton buttonWithTitle:@"[タイトル]" fontName:@"Verdana-Bold" fontSize:15.0f];
    backButton.positionType = CCPositionTypeNormalized;
    backButton.position = ccp(0.9f, 0.95f); // Top Right of screen
    [backButton setTarget:self selector:@selector(onBackClicked:)];
    [self addChild:backButton];*/
    
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
    
    //GKMatch監視
    if(battleMatch.playerIDs.count<=0){
        [self alert_Disconnected:NSLocalizedString(@"NetworkError",NULL)
                                            msg:NSLocalizedString(@"NotBattleData",NULL)
                                            delegate:self
                                            procNum:1];//エラーメッセージ送信
    }
    
    /*/デバッグラベル
    if([GameManager getHost]){
        lbl_1=[CCLabelTTF labelWithString:@"サーバー" fontName:@"Verdana-Bold" fontSize:15];
    }else{
        lbl_1=[CCLabelTTF labelWithString:@"クライアント" fontName:@"Verdana-Bold" fontSize:15];
    }
    lbl_1.position=ccp(lbl_1.contentSize.width/2,winSize.height-lbl_1.contentSize.height/2);
    [self addChild:lbl_1];
    
    //GKMatch監視
    if(battleMatch.playerIDs.count>0){
        lbl_2=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@",[battleMatch.playerIDs objectAtIndex:0]] fontName:@"Verdana-Bold" fontSize:10];
    }else{
        lbl_2=[CCLabelTTF labelWithString:@"対戦データの取得に失敗しました(受信不能)" fontName:@"Verdana-Bold" fontSize:10];
        [self alert_Disconnected:NSLocalizedString(@"NetworkError",NULL)
                                msg:NSLocalizedString(@"NotBattleData",NULL)
                                delegate:self
                                procNum:1];//エラーメッセージ送信
    }
    lbl_2.position=ccp(winSize.width-lbl_2.contentSize.width/2,winSize.height-lbl_2.contentSize.height/2);
    [self addChild:lbl_2];*/
    
    /*/デバッグラベル
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
    [self addChild:debugLabel5];*/
    
    return self;
}

-(void)dealloc
{
    // clean up code goes here
    [battleMatch disconnect];
    battleMatch.delegate=nil;
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
    
    //準備状況・スケジュール
    [self schedule:@selector(readiness_Schedule:)interval:0.5];
    
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

-(void)setGround
{
    float offsetX;
    float offsetY;
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"ground_default.plist"];
    CCSprite* frame = [CCSprite spriteWithSpriteFrame:
                       [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"ground_00.png"]];
    CGSize frameCount = CGSizeMake(winSize.width/frame.contentSize.width+2,
                                   [GameManager getWorldSize].height/frame.contentSize.height+1);
    //NSString* bgName=[NSString stringWithFormat:@"ground_%02d.png",(arc4random()%10)];
    NSString* bgName=[NSString stringWithFormat:@"ground_%02d.png",2];
    for(int i=0;i<frameCount.width*frameCount.height;i++)
    {
        frame = [CCSprite spriteWithSpriteFrame:
                 [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:bgName]];
        if(i==0){
            offsetX = frame.contentSize.width/2-1;
            offsetY = frame.contentSize.height/2-1;
        }else if(i%(int)frameCount.width==0){
            offsetX = frame.contentSize.width/2-1;
            offsetY = offsetY + frame.contentSize.height-1;
        }else{
            offsetX = offsetX + frame.contentSize.width-1;
        }
        frame.position = CGPointMake(offsetX,offsetY);
        [self addChild:frame z:0];
    }
}

-(void)setYard
{
    float offsetX;
    float offsetY;
    float scale=0.5;
    CCSprite* frame = [CCSprite spriteWithSpriteFrame:
                       [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"ground_00.png"]];
    CGSize frameCount = CGSizeMake(winSize.width/(frame.contentSize.width*scale)+2,
                            (offSet.height+[GameManager getWorldSize].height*0.2)/(frame.contentSize.height*scale)+1);
    //NSString* bgName=[NSString stringWithFormat:@"ground_%02d.png",(arc4random()%10)];
    NSString* bgName=[NSString stringWithFormat:@"ground_%02d.png",7];
    
    //プレイヤ側陣地
    for(int i=0;i<frameCount.width*frameCount.height;i++)
    {
        frame = [CCSprite spriteWithSpriteFrame:
                 [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:bgName]];
        frame.scale=scale;
        if(i==0){
            offsetX = (frame.contentSize.width*scale)/2-1;
            offsetY = (offSet.height+[GameManager getWorldSize].height*0.2)-(frame.contentSize.height*scale)/2;
        }else if(i%(int)frameCount.width==0){
            offsetX = (frame.contentSize.width*scale)/2-1;
            offsetY = offsetY - (frame.contentSize.height*scale)+1;
        }else{
            offsetX = offsetX + (frame.contentSize.width*scale)-1;
        }
        frame.position = CGPointMake(offsetX,offsetY);
        [self addChild:frame z:0];
    }
    //敵側陣地
    for(int i=0;i<frameCount.width*frameCount.height;i++)
    {
        frame = [CCSprite spriteWithSpriteFrame:
                 [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:bgName]];
        frame.scale=scale;
        if(i==0){
            offsetX = (frame.contentSize.width*scale)/2-1;
            offsetY = (offSet.height+[GameManager getWorldSize].height*0.8)+(frame.contentSize.height*scale)/2;
        }else if(i%(int)frameCount.width==0){
            offsetX = (frame.contentSize.width*scale)/2-1;
            offsetY = offsetY + (frame.contentSize.height*scale)-1;
        }else{
            offsetX = offsetX + (frame.contentSize.width*scale)-1;
        }
        frame.position = CGPointMake(offsetX,offsetY);
        [self addChild:frame z:0];
    }
}

//=========================
//準備状況・スケジュール
//=========================
-(void)readiness_Schedule:(CCTime)dt
{
    if([GameManager getHost]){//ホスト青
        if(mWaitLayer.playerReadyFlg){
            //準備OK 送信
            [self sendData_Readiness:true];
        }
    }else{//クライアント赤
        if(mWaitLayer.enemyReadyFlg){
            //準備OK 送信
            [self sendData_Readiness:true];
        }
    }
    
    if(mWaitLayer.playerReadyFlg && mWaitLayer.enemyReadyFlg){
        [self unschedule:@selector(readiness_Schedule:)];
        //mWaitLayer.playerLbl.fontSize=50;
        mWaitLayer.playerLbl.scale=1.0;
        mWaitLayer.playerLbl.string=NSLocalizedString(@"BattleStrart",NULL);
        //mWaitLayer.enemyLbl.fontSize=50;
        mWaitLayer.enemyLbl.scale=1.0;
        mWaitLayer.enemyLbl.string=NSLocalizedString(@"BattleStrart",NULL);
        [mWaitLayer readyWaitStart];
        //[self removeChild:mWaitLayer cleanup:YES];
    }
}

//=========================
//サーバー・スケジュール
//=========================
-(void)judgement_Schedule:(CCTime)dt
{
    if([GameManager getPause]){
        return;
    }
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
                     if(_player.mode!=1 && _player.mode!=3){
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
                     if(_player.mode!=2 && _player.mode!=3){
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
                
                if(_enemy.mode!=1 && _enemy.mode!=3){
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
                if(_enemy.mode!=2 && _enemy.mode!=3){
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
                                         radius1:(_player.contentSize.width*_player.scale)/2 -5.0f
                                         radius2:(_enemy.contentSize.width*_enemy.scale)/2 -5.0f])
            {
                _player.stopFlg=true;
                _player.targetAngle=[BasicMath getAngle_To_Radian:_player.position ePos:_enemy.position];
                _player.mode=3;
                _player.targetObject=_enemy;
                break;
            }
        }
    }
    for(mEnemy* _enemy in enemyArray){
        for(mPlayer* _player in playerArray){
            if([BasicMath RadiusIntersectsRadius:_player.position
                                          pointB:_enemy.position
                                         radius1:(_player.contentSize.width*_player.scale)/2 -5.0f
                                         radius2:(_enemy.contentSize.width*_enemy.scale)/2 -5.0f])
            {
                _enemy.stopFlg=true;
                _enemy.targetAngle=[BasicMath getAngle_To_Radian:_enemy.position ePos:_player.position];
                _enemy.mode=3;
                _enemy.targetObject=_player;
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
    
    //===============
    //戦闘後復帰処理
    //===============
    for(mPlayer* _player in playerArray){
        if(_player.mode==3){
            bool hitFlg=false;
            for(mEnemy* _enemy in enemyArray){
                if([BasicMath RadiusIntersectsRadius:_player.position
                                              pointB:_enemy.position
                                             radius1:(_player.contentSize.width*_player.scale)/2 -5.0f
                                             radius2:(_enemy.contentSize.width*_enemy.scale)/2 -5.0f])
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
                                             radius1:(_enemy.contentSize.width*_enemy.scale)/2 -5.0f
                                             radius2:(_player.contentSize.width*_player.scale)/2 -5.0f])
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
            if(_player.mode!=3){
                if(!gameEndFlg){
                    _player.stopFlg=true;
                    _player.mode=4;
                    _player.targetAngle=[BasicMath getAngle_To_Radian:_player.position ePos:enemyFortress.position];
                    //enemyFortress.ability--;
                    _player.targetObject=enemyFortress;
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
            if(_enemy.mode!=3){
                if(!gameEndFlg){
                    _enemy.stopFlg=true;
                    _enemy.mode=4;
                    _enemy.targetAngle=[BasicMath getAngle_To_Radian:_enemy.position ePos:playerFortress.position];
                    //playerFortress.ability--;
                    _enemy.targetObject=playerFortress;
                }
            }
        }
    }
    
    //===================
    // 対戦データ作成
    //===================
    battleDataArray=[[NSMutableArray alloc]init];
    Battle_Data battleData;
    NSData* data;
    
    for(mPlayer* _player in playerArray){
        battleData.objId=_player.objId;
        battleData.group=_player.group;
        battleData.posX=_player.position.x-offSet.width;//X座標正規化
        battleData.posY=_player.position.y-offSet.height;//Y座標正規化
        battleData.angle=_player.targetAngle;
        battleData.ability=_player.ability;
        battleData.stopFlg=_player.stopFlg;
        battleData.mode=_player.mode;
        
        data=[NSData dataWithBytes:&battleData length:sizeof(Battle_Data)];
        [battleDataArray addObject:data];
    }
    for(mEnemy* _enemy in enemyArray){
        battleData.objId=_enemy.objId;
        battleData.group=_enemy.group;
        battleData.posX=_enemy.position.x-offSet.width;//X座標正規化
        battleData.posY=_enemy.position.y-offSet.height;//Y座標正規化
        battleData.angle=_enemy.targetAngle;
        battleData.ability=_enemy.ability;
        battleData.stopFlg=_enemy.stopFlg;
        battleData.mode=_enemy.mode;
        
        data=[NSData dataWithBytes:&battleData length:sizeof(Battle_Data)];
        [battleDataArray addObject:data];
    }
    //対戦データ送信
    if(battleDataArray.count>0){
        [self sendData_BattleData:battleDataArray];
    }
    //要塞アビリティ送信
    [self sendData_Fortress:playerFortress.ability enemy:enemyFortress.ability];
    
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
    //===================
    //要塞オブジェクト削除
    //===================
    if(playerFortress.ability<=0){
        [self removeChild:playerFortress cleanup:YES];
        gameEndFlg=true;
        [self gameEnd:false];
    }
    if(enemyFortress.ability<=0){
        [self removeChild:enemyFortress cleanup:YES];
        gameEndFlg=true;
        [self gameEnd:true];
    }
    /*/=============
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
    }*/
    
    //インフォレイヤー更新
    [infoLayer stats_Update];

    //デバッグラベル更新
    //debugLabel3.string=[NSString stringWithFormat:@"青=%03d 赤=%03d",pCnt,eCnt];
    //debugLabel4.string=[NSString stringWithFormat:@"pTotle=%04d",pTotalCnt];
    //debugLabel5.string=[NSString stringWithFormat:@"eTotle=%04d",eTotalCnt];
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
        [self setDieParticle:_player.position];
        [self setTomb:_player.position];
        [playerArray removeObject:_player];
        [self removeChild:_player cleanup:YES];
        infoLayer.pCnt--;
    }
    for(mEnemy* _enemy in removeEnemyArray)
    {
        [self setDieParticle:_enemy.position];
        [self setTomb:_enemy.position];
        [enemyArray removeObject:_enemy];
        [self removeChild:_enemy cleanup:YES];
        infoLayer.eCnt--;
    }
}

-(void)setTomb:(CGPoint)pos
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"ground_default.plist"];
    CCSprite* tomb = [CCSprite spriteWithSpriteFrame:
                      [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"tomb.png"]];
    tomb.scale=0.2;
    tomb.position=pos;
    [self addChild:tomb z:0];
}

//=========================
//クライアント・スケジュール
//=========================
-(void)status_Schedule:(CCTime)dt
{
    if([GameManager getPause]){
        return;
    }
    removePlayerArray=[[NSMutableArray alloc]init];
    removeEnemyArray=[[NSMutableArray alloc]init];
    
    //=============
    //オブジェクト撃破
    //=============
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
    //=============
    //要塞撃破
    //=============
    if(playerFortress.ability<=0){
        [self removeChild:playerFortress cleanup:YES];
        gameEndFlg=true;
        [self gameEnd:false];
    }
    if(enemyFortress.ability<=0){
        [self removeChild:enemyFortress cleanup:YES];
        gameEndFlg=true;
        [self gameEnd:true];
    }
    /*/=============
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
    }*/

    //インフォレイヤー更新
    [infoLayer stats_Update];
    
    //デバッグラベル更新
    //debugLabel3.string=[NSString stringWithFormat:@"青=%03d 赤=%03d",pCnt,eCnt];
    //debugLabel4.string=[NSString stringWithFormat:@"pTotle=%04d",pTotalCnt];
    //debugLabel5.string=[NSString stringWithFormat:@"eTotle=%04d",eTotalCnt];
}

//==================
// ゲームエンド
//==================
-(void)gameEnd:(bool)winnerFlg
{
    [GameManager setPause:true];
    
    for(mPlayer* _player in playerArray){
        _player.stopFlg=true;
    }
    for(mEnemy* _enemy in enemyArray){
        _enemy.stopFlg=true;
    }
    [self unscheduleAllSelectors];
    
    //勝ち点を保存
    if(winnerFlg){//青勝ち
        if([GameManager getHost]){//ホストなら
            [GameManager save_Match_Point:[GameManager load_Match_Point]+1];
        }
    }else{//赤勝ち
        if(![GameManager getHost]){//クライアントなら
            [GameManager save_Match_Point:[GameManager load_Match_Point]+1];
        }
    }
    //インフォレイヤー更新
    [infoLayer score_Update];
    
    //NSLog(@"勝ち点: %02d ポイント",[GameManager load_Match_Point]);
    //リザルトレイヤー表示
    ResultsLayer* resultsLayer=[[ResultsLayer alloc]initWithWinner:winnerFlg stars:0 playerDie:0 enemyDie:0 playerFortress:0];
    [self addChild:resultsLayer z:TURN_OBJ_MAX+2];
    
}

-(void)setDieParticle:(CGPoint)pos
{
    if(dieParticle!=nil){//その都度削除
        [self removeChild:dieParticle cleanup:YES];
    }
    dieParticle=[[CCParticleSystem alloc]initWithFile:@"die.plist"];
    dieParticle.position=pos;
    dieParticle.scale=0.5;
    [self addChild:dieParticle z:100];
    //[bombParticleArray addObject:bombParticle];
}

-(void)create_Object_Schedule:(CCTime)dt
{
    if(touchPos.y<offSet.height+[GameManager getWorldSize].height*0.2){
        if([GameManager getHost]){//青(Player)
            if(infoLayer.pCnt<TURN_OBJ_MAX && infoLayer.pTotalCnt<infoLayer.pMaxCnt){
                m_player=[mPlayer createPlayer:infoLayer.pTotalCnt pos:touchPos];
                [self addChild:m_player z:1];
                [playerArray addObject:m_player];
                infoLayer.pCnt++;
                infoLayer.pTotalCnt++;
                //データ送信
                [self sendData_CreateObject:touchPos];
            }else{
                //カウント超過停止
                createObjectFlg=false;
                [self unschedule:@selector(create_Object_Schedule:)];
            }
        }else{//赤(Enemy)
            if(infoLayer.eCnt<TURN_OBJ_MAX && infoLayer.eTotalCnt<infoLayer.eMaxCnt){
                m_enemy=[mEnemy createEnemy:infoLayer.eTotalCnt pos:touchPos];
                [self addChild:m_enemy z:1];
                [enemyArray addObject:m_enemy];
                infoLayer.eCnt++;
                infoLayer.eTotalCnt++;
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
    [battleMatch disconnect];
    battleMatch.delegate=nil;
    [[CCDirector sharedDirector] replaceScene:[TitleScene scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];
    
}

//=====================
// デリゲートメソッド
//=====================
-(void)onMessageLayerBtnClocked:(int)btnNum procNum:(int)procNum
{
    //NSLog(@"%d が選択されました",btnNum);

    if(procNum==1){//対戦相手へのエラー通知
        [self sendData_Error_Message:NSLocalizedString(@"NotBattleData",NULL)];//相手へエラー通知
    }
    msgBox.delegate=nil;//デリゲート解除
}

-(void)alert_Disconnected:(NSString*)title msg:(NSString*)msg delegate:(id)delegate procNum:(int)procNum
{
    /*UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:msg
                                                    delegate:delegate
                                                    cancelButtonTitle:nil
                                                    otherButtonTitles:@"OK", nil];
    [alert show];*/
    
    //カスタムアラートメッセージ
    msgBox=[[MessageLayer alloc]initWithTitle:title
                                            msg:msg
                                            pos:ccp(winSize.width/2,winSize.height/2)
                                            size:CGSizeMake(200, 100)
                                            modal:true
                                            rotation:false
                                            type:0
                                            procNum:procNum];
    msgBox.delegate=self;//デリゲートセット
    [self addChild:msgBox z:43];

}

/*-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self sendData_Error_Message:NSLocalizedString(@"NotBattleData",NULL)];//相手へエラー通知
    //[battleMatch disconnect];
    //battleMatch.delegate=nil;
    //[[CCDirector sharedDirector] replaceScene:[TitleScene scene]
    //                           withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];
    
}*/

-(void)match:(GKMatch *)match player:(NSString *)playerID didChangeState:(GKPlayerConnectionState)state
{
    switch (state)
    {
        case GKPlayerStateConnected:
            // 新規のプレーヤー接続を処理する
            break;
        case GKPlayerStateDisconnected:
            // プレーヤーが切断した場合
            if(!gameEndFlg){//ゲーム中だったら・・・
                //ポイント加算
                [GameManager save_Match_Point:[GameManager load_Match_Point]+1];
                //インフォレイヤー更新
                [infoLayer score_Update];
                //NSLog(@"勝ち点: %02d ポイント",[GameManager load_Match_Point]);
                //リザルトレイヤー表示
                ResultsLayer* resultsLayer;
                if([GameManager getHost]){//ホスト青だったら
                    resultsLayer=[[ResultsLayer alloc]initWithWinner:true stars:0 playerDie:0 enemyDie:0 playerFortress:0];
                }else{
                    resultsLayer=[[ResultsLayer alloc]initWithWinner:false stars:0 playerDie:0 enemyDie:0 playerFortress:0];
                }
                [self addChild:resultsLayer z:42];
                
                [self alert_Disconnected:NSLocalizedString(@"NetworkError",NULL)
                                    msg:NSLocalizedString(@"PlayerDisconnected",NULL)
                                    delegate:nil
                                    procNum:0];//処理なし
            }
            break;
        default:
            break;
    }
    if (match.expectedPlayerCount == 0)
    {
        // ゲーム開始の処理
    }
}

//====================================
// 対戦データ送信メソッド ヘッダー（１）
//====================================
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
//====================================
// オブジェクト配置 送信メソッド ヘッダー（０）
//====================================
-(void)sendData_CreateObject:(CGPoint)_pos;
{
    CreateObj_Data createData;
    createData.posX=_pos.x-offSet.width;//X座標正規化
    createData.posY=_pos.y-offSet.height;//Y座標正規化

    NSError *error = nil;
    //ヘッダー番号付与
    int header=0;
    NSMutableData* tmpData=[NSMutableData dataWithBytes:&header length:sizeof(header)];//ヘッダー部
    NSData *packetData = [NSData dataWithBytes:&createData length:sizeof(CreateObj_Data)];//本体部
    //合体
    [tmpData appendData:packetData];
    //送信
    [battleMatch sendDataToAllPlayers:tmpData withDataMode:GKMatchSendDataUnreliable error:&error];
    //NSLog(@"送信しました！");
    if (error != nil){
        NSLog(@"%@",error);
    }
}
//====================================
// エラーメッセージ 送信メソッド ヘッダー（２）
//====================================
-(void)sendData_Error_Message:(NSString*)message
{
    //NSLog(@"エラーメッセージ、送信してる？");
    NSError *error = nil;
    //ヘッダー番号付与
    int header=2;
    NSMutableData* tmpData=[NSMutableData dataWithBytes:&header length:sizeof(header)];//ヘッダー部
    NSData *packetData = [message dataUsingEncoding:NSUTF8StringEncoding];//本体部
    //合体
    [tmpData appendData:packetData];
    //送信
    [battleMatch sendDataToAllPlayers:tmpData withDataMode:GKMatchSendDataUnreliable error:&error];
    
    if (error != nil){
        NSLog(@"%@",error);
    }
}
//====================================
// 陣地アビリティ 送信メソッド ヘッダー（３）
//====================================
-(void)sendData_Fortress:(int)pAbility enemy:(int)eAbility
{
    Fortress_Data fortressData;
    fortressData.pAbility=pAbility;
    fortressData.eAbility=eAbility;
    
    NSError *error = nil;
    //ヘッダー番号付与
    int header=3;
    NSMutableData* tmpData=[NSMutableData dataWithBytes:&header length:sizeof(header)];//ヘッダー部
    NSData *packetData = [NSData dataWithBytes:&fortressData length:sizeof(Fortress_Data)];//本体部
    //合体
    [tmpData appendData:packetData];
    //送信
    [battleMatch sendDataToAllPlayers:tmpData withDataMode:GKMatchSendDataUnreliable error:&error];
    
    if (error != nil){
        NSLog(@"%@",error);
    }

}
//====================================
// 準備状況 送信メソッド ヘッダー（４）
//====================================
-(void)sendData_Readiness:(bool)readyFlg
{
    NSError *error = nil;

    int header=4;
    NSMutableData* tmpData=[NSMutableData dataWithBytes:&header length:sizeof(header)];//ヘッダー部
    NSData *packetData = [[NSString stringWithFormat:@"%d",readyFlg] dataUsingEncoding:NSUTF8StringEncoding];//本体部
    //合体
    [tmpData appendData:packetData];
    //送信
    [battleMatch sendDataToAllPlayers:tmpData withDataMode:GKMatchSendDataUnreliable error:&error];
    
    if (error != nil){
        NSLog(@"%@",error);
    }
}
//====================================
// ポーズ・レジューム 送信メソッド ヘッダー（５）
//====================================
+(void)sendData_Pause:(bool)flg
{
    NSError *error = nil;
    
    int header=5;
    NSMutableData* tmpData=[NSMutableData dataWithBytes:&header length:sizeof(header)];//ヘッダー部
    NSData *packetData = [[NSString stringWithFormat:@"%d",flg] dataUsingEncoding:NSUTF8StringEncoding];//本体部
    //合体
    [tmpData appendData:packetData];
    //送信
    [battleMatch sendDataToAllPlayers:tmpData withDataMode:GKMatchSendDataReliable error:&error];
    
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
    //NSLog(@"受信しました！");
    //======================
    // オブジェクト配置
    //======================
    if(_msgNum==0)
    {
        //構造体へ代入
        CreateObj_Data* createData=(CreateObj_Data*)msg;
        //NSLog(@"PosX=%f : PosY=%f",createData->posX,createData->posY);
        
        //対称軸へ置く
        float _x=winSize.width-createData->posX-offSet.width;
        float _y=winSize.height-createData->posY-offSet.height;
        
        //同じ位置なら
        //float _x=createObj->posX+offSet.width;
        //float _y=createObj->posY+offSet.height;
        
        if([GameManager getHost]){
            m_enemy=[mEnemy createEnemy:infoLayer.eTotalCnt pos:ccp(_x,_y)];
            [self addChild:m_enemy z:TURN_OBJ_MAX-infoLayer.eCnt];
            [enemyArray addObject:m_enemy];
            infoLayer.eCnt++;
            infoLayer.eTotalCnt++;
        }else{
            m_player=[mPlayer createPlayer:infoLayer.pTotalCnt pos:ccp(_x,_y)];
            [self addChild:m_player z:TURN_OBJ_MAX-infoLayer.pCnt];
            [playerArray addObject:m_player];
            infoLayer.pCnt++;
            infoLayer.pTotalCnt++;
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
            //NSLog(@"PosX=%f : PosY=%f",battleData->posX,battleData->posY);
            [self setObjectData:battleData];
        }
    }
    //======================
    // エラーメッセージ
    //======================
    else if(_msgNum==2)
    {
        //NSDataへ変換
        NSData* dData=[NSData dataWithBytes:msg length:diffLength];
        //文字列の復元
        NSString* message=[[NSString alloc] initWithData:dData encoding:NSUTF8StringEncoding];
        [self alert_Disconnected:NSLocalizedString(@"NetworkError",NULL)
                                                                msg:message
                                                                delegate:nil
                                                                procNum:0];//処理なし
    }
    //======================
    // 陣地アビリティ
    //======================
    else if(_msgNum==3)
    {
        //構造体へ代入
        Fortress_Data* fortressData=(Fortress_Data*)msg;
        playerFortress.ability=fortressData->pAbility;
        enemyFortress.ability=fortressData->eAbility;
    }
    //======================
    // 準備状況受信
    //======================
    else if(_msgNum==4)
    {
        //NSDataへ変換
        NSData* dData=[NSData dataWithBytes:msg length:diffLength];
        //boolへ
        bool flg = [[[NSString alloc] initWithData:dData encoding:NSUTF8StringEncoding]boolValue];
        
        if([GameManager getHost]){//ホスト青
            mWaitLayer.enemyReadyFlg=flg;//赤状況受信
        }else{
            mWaitLayer.playerReadyFlg=flg;//青状況受信
        }
    }
    //======================
    // ポーズ・レジューム状況受信
    //======================
    else if(_msgNum==5)
    {
        //NSDataへ変換
        NSData* dData=[NSData dataWithBytes:msg length:diffLength];
        //boolへ
        bool flg = [[[NSString alloc] initWithData:dData encoding:NSUTF8StringEncoding]boolValue];
        
        if(flg){
            [naviLayer pause];
        }else{
            [naviLayer resume];
        }
    }
    //======================
    //
    //======================
    else
    {
        
    }
    free(msg);
}

-(void)setObjectData:(Battle_Data*)battleData
{
    int group=battleData->group;
    int objId=battleData->objId;
    
    if(group==0){//青
        for(mPlayer* _player in playerArray){
            if(_player.objId==objId){
                _player.position=ccp(winSize.width-battleData->posX-offSet.width,
                                     winSize.height-battleData->posY-offSet.height);
                _player.targetAngle=battleData->angle + M_PI;//反転
                _player.ability=battleData->ability;
                _player.stopFlg=battleData->stopFlg;
                _player.mode=battleData->mode;
                break;
            }
        }
    }else{//赤
        for(mEnemy* _enemy in enemyArray){
            if(_enemy.objId==objId){
                _enemy.position=ccp(winSize.width-battleData->posX-offSet.width,
                                     winSize.height-battleData->posY-offSet.height);
                _enemy.targetAngle=battleData->angle + M_PI;//反転
                _enemy.ability=battleData->ability;
                _enemy.stopFlg=battleData->stopFlg;
                _enemy.mode=battleData->mode;
                break;
            }
        }
    }
}

@end
