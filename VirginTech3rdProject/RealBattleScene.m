//
//  RealBattleScene.m
//  VirginTech3rdProject
//
//  Created by VirginTech LLC. on 2014/11/25.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "RealBattleScene.h"
#import "BasicMath.h"
#import "GameManager.h"
#import "TitleScene.h"
#import "CCDrawNode.h"

#import "Fortress.h"
#import "Player.h"
#import "Enemy.h"

@implementation RealBattleScene

CGSize winSize;
CGPoint playerLocation;
CGPoint enemyLocation;
float footer;

Fortress* playerFortress;
Fortress* enemyFortress;
bool gameEndFlg;

Player* player;
NSMutableArray* playerArray;
NSMutableArray* removePlayerArray;
bool createPlayerFlg;

Enemy* enemy;
NSMutableArray* enemyArray;
NSMutableArray* removeEnemyArray;
bool createEnemyFlg;

//カウンター
int pMaxCnt;
int pTotalCnt;
int pCnt;
int eMaxCnt;
int eTotalCnt;
int eCnt;

//デバッグ用ラベル
int repCnt;
CCLabelTTF* debugLabel1;
CCLabelTTF* debugLabel2;
CCLabelTTF* debugLabel3;
CCLabelTTF* debugLabel4;
CCLabelTTF* debugLabel5;

+(RealBattleScene *)scene
{
    return [[self alloc] init];
}

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    winSize=[[CCDirector sharedDirector]viewSize];
    
    // Enable touch handling on scene node
    self.userInteractionEnabled = YES;
    self.multipleTouchEnabled = YES; /*マルチタッチ検出を有効化*/

    //初期化
    gameEndFlg=false;
    
    footer=0;
    playerArray=[[NSMutableArray alloc]init];
    createPlayerFlg=false;
    pTotalCnt=0;
    pCnt=0;
    pMaxCnt=250;
    
    enemyArray=[[NSMutableArray alloc]init];
    createEnemyFlg=false;
    eTotalCnt=0;
    eCnt=0;
    eMaxCnt=250;
    
    // Create a colored background (Dark Grey)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];
    [self addChild:background];
    
    //レベルに応じた画面の大きさ
    [GameManager setWorldSize:CGSizeMake(winSize.width, winSize.height)];
    
    UIImage *image = [UIImage imageNamed:@"bgLayer.png"];
    UIGraphicsBeginImageContext(CGSizeMake(winSize.width,[GameManager getWorldSize].height));
    [image drawInRect:CGRectMake(0, 0, winSize.width,[GameManager getWorldSize].height)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Create a back button
    CCButton *backButton = [CCButton buttonWithTitle:@"[タイトル]" fontName:@"Verdana-Bold" fontSize:15.0f];
    backButton.positionType = CCPositionTypeNormalized;
    backButton.position = ccp(0.9f, 0.95f); // Top Right of screen
    [backButton setTarget:self selector:@selector(onBackClicked:)];
    [self addChild:backButton];
    
    //デバッグラベル
    debugLabel1=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"PlayerMax=%d",pMaxCnt] fontName:@"Verdana-Bold" fontSize:10];
    debugLabel1.position=ccp(debugLabel1.contentSize.width/2, winSize.height-debugLabel1.contentSize.height/2);
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
}

-(void)onEnter
{
    // always call super onEnter first
    [super onEnter];
    
    //我陣地ライン
    CCDrawNode* drawNode1=[CCDrawNode node];
    [drawNode1 drawSegmentFrom:ccp(0,footer+([GameManager getWorldSize].height-footer)*0.2)
                            to:ccp([GameManager getWorldSize].width,footer+([GameManager getWorldSize].height-footer)*0.2)
                        radius:0.5
                         color:[CCColor whiteColor]];
    [self addChild:drawNode1];
    
    //敵陣地ライン
    CCDrawNode* drawNode2=[CCDrawNode node];
    [drawNode2 drawSegmentFrom:ccp(0,footer+([GameManager getWorldSize].height-footer)*0.8)
                            to:ccp([GameManager getWorldSize].width,footer+([GameManager getWorldSize].height-footer)*0.8)
                        radius:0.5
                         color:[CCColor whiteColor]];
    [self addChild:drawNode2];
    
    //センターライン
    CCDrawNode* drawNode5=[CCDrawNode node];
    [drawNode5 drawSegmentFrom:ccp(0,footer+([GameManager getWorldSize].height-footer)/2)
                            to:ccp([GameManager getWorldSize].width,footer+([GameManager getWorldSize].height-footer)/2)
                        radius:0.5
                         color:[CCColor yellowColor]];
    [self addChild:drawNode5];
    
    //我城生成
    playerFortress=[Fortress createFortress:ccp([GameManager getWorldSize].width/2,footer+15) type:0];
    [self addChild:playerFortress];
    
    //敵城生成
    enemyFortress=[Fortress createFortress:ccp([GameManager getWorldSize].width/2,[GameManager getWorldSize].height-15) type:1];
    [self addChild:enemyFortress];
    
    //審判スケジュール開始
    [self schedule:@selector(judgement_Schedule:)interval:0.1];
}

-(void)onExit
{
    // always call super onExit last
    [super onExit];
}

-(void)judgement_Schedule:(CCTime)dt
{
    //初期化
    removePlayerArray=[[NSMutableArray alloc]init];
    removeEnemyArray=[[NSMutableArray alloc]init];
    
    float collisSurfaceAngle;//衝突面角度
    
    //**********************
    //プレイヤージャッジメント
    //**********************
    for(Player* _player in playerArray){
        if(_player.mode==0){
            _player.stopFlg=false;
            _player.targetAngle=[BasicMath getAngle_To_Radian:_player.position
                                                         ePos:ccp(_player.position.x,_player.position.y+1.0f)];
        }
        //================
        //近隣プレイヤー捜索
        //================
        _player.nearPlayerCnt=0;
        for(Player* _player1 in playerArray){
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
        for(Enemy* _enemy in enemyArray){
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
                             if(_player.position.y>footer+([GameManager getWorldSize].height-footer)*0.25){
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
                         if(_player.position.y<footer+([GameManager getWorldSize].height-footer)*0.25){
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
    for(Enemy* _enemy in enemyArray){
        if(_enemy.mode==0){
            _enemy.stopFlg=false;
            _enemy.targetAngle=[BasicMath getAngle_To_Radian:_enemy.position
                                                        ePos:ccp(_enemy.position.x,_enemy.position.y-1.0f)];
        }
        //==============
        //近隣「敵」捜索
        //==============
        _enemy.nearEnemyCnt=0;
        for(Enemy* _enemy1 in enemyArray){
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
        for(Player* _player in playerArray){
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
                        if(_enemy.position.y<footer+([GameManager getWorldSize].height-footer)*0.75){
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
                    if(_enemy.position.y>footer+([GameManager getWorldSize].height-footer)*0.75){
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
    for(Player* _player in playerArray){
        for(Enemy* _enemy in enemyArray){
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
                    for(Enemy* _enemy_ in enemyArray){
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
    for(Player* _player in playerArray){
        //敵陣地内に入ったら
        if(_player.mode!=3){//戦闘以外だったら
            if(_player.position.y>footer+([GameManager getWorldSize].height-footer)*0.8){
                _player.targetAngle=[BasicMath getAngle_To_Radian:_player.position ePos:enemyFortress.position];
            }
        }
    }
    
    for(Enemy* _enemy in enemyArray){
        //プレイヤー陣地内に入ったら
        if(_enemy.mode!=3){//戦闘以外だったら
            if(_enemy.position.y<footer+([GameManager getWorldSize].height-footer)*0.2){
                _enemy.targetAngle=[BasicMath getAngle_To_Radian:_enemy.position ePos:playerFortress.position];
            }
        }
    }
    
    //===================
    //消滅オブジェクト削除
    //===================
    for(Player* _player in playerArray){
        if(_player.ability<=0){
            [removePlayerArray addObject:_player];
        }
    }
    for(Enemy* _enemy in enemyArray){
        if(_enemy.ability<=0){
            [removeEnemyArray addObject:_enemy];
        }
    }
    [self removeObject];
    
    //===============
    //戦闘後復帰処理
    //===============
    for(Player* _player in playerArray){
        if(_player.mode==3){
            bool hitFlg=false;
            for(Enemy* _enemy in enemyArray){
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
    for(Enemy* _enemy in enemyArray){
        if(_enemy.mode==3){
            bool hitFlg=false;
            for(Player* _player in playerArray){
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
    for(Player* _player in playerArray){
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
    for(Enemy* _enemy in enemyArray){
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
        for(Player* _player in playerArray){
            _player.stopFlg=true;
        }
        for(Enemy* _enemy in enemyArray){
            _enemy.stopFlg=true;
        }
        [self unscheduleAllSelectors];
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
    for(Player* _player in removePlayerArray)
    {
        [playerArray removeObject:_player];
        [self removeChild:_player cleanup:YES];
        pCnt--;
    }
    for(Enemy* _enemy in removeEnemyArray)
    {
        [enemyArray removeObject:_enemy];
        [self removeChild:_enemy cleanup:YES];
        eCnt--;
    }
}

-(void)create_Player_Schedule:(CCTime)dt
{
    if(pCnt<40 && pTotalCnt<pMaxCnt){
        if(playerLocation.y<[GameManager getWorldSize].height*0.2){
            player=[Player createPlayer:playerLocation];
            [self addChild:player];
            [playerArray addObject:player];
            pCnt++;
            pTotalCnt++;
        }else{
            //通常停止
            createPlayerFlg=false;
            [self unschedule:@selector(create_Player_Schedule:)];
        }
    }else{
        //カウント超過停止
        createPlayerFlg=false;
        [self unschedule:@selector(create_Player_Schedule:)];
    }
}

-(void)create_Enemy_Schedule:(CCTime)dt
{
    if(eCnt<40 && eTotalCnt<eMaxCnt){
        if(enemyLocation.y>[GameManager getWorldSize].height*0.8){
            enemy=[Enemy createEnemy:enemyLocation];
            [self addChild:enemy];
            [enemyArray addObject:enemy];
            eCnt++;
            eTotalCnt++;
        }else{
            //通常停止
            createEnemyFlg=false;
            [self unschedule:@selector(create_Enemy_Schedule:)];
        }
    }else{
        //カウント超過停止
        createEnemyFlg=false;
        [self unschedule:@selector(create_Enemy_Schedule:)];
    }
}

-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [touch locationInNode:self];
    
    //プレイヤー作成
    if(touchLocation.y<footer+([GameManager getWorldSize].height-footer)*0.2){
        playerLocation=touchLocation;
        if(!createPlayerFlg){
            //プレイヤー生成スケジュール開始
            [self schedule:@selector(create_Player_Schedule:)interval:0.1 repeat:CCTimerRepeatForever delay:0.15f];
            createPlayerFlg=true;
        }
    }
    if(touchLocation.y>footer+([GameManager getWorldSize].height-footer)*0.8){
        enemyLocation=touchLocation;
        if(!createEnemyFlg){
            //敵生成スケジュール開始
            [self schedule:@selector(create_Enemy_Schedule:)interval:0.1 repeat:CCTimerRepeatForever delay:0.15f];
            createEnemyFlg=true;
        }
    }
}

-(void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [touch locationInNode:self];
    
    if(touchLocation.y<[GameManager getWorldSize].height*0.2+50)
    {
        playerLocation=touchLocation;
    }
    
    if(touchLocation.y>[GameManager getWorldSize].height*0.8-50)
    {
        enemyLocation=touchLocation;
    }
}

-(void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    //チョンタッチ停止
    CGPoint touchLocation = [touch locationInNode:self];
    
    if(touchLocation.y<[GameManager getWorldSize].height*0.5){
        if(createPlayerFlg){
            createPlayerFlg=false;
            [self unschedule:@selector(create_Player_Schedule:)];
        }
    }

    if(touchLocation.y>[GameManager getWorldSize].height*0.5){
        if(createEnemyFlg){
            createEnemyFlg=false;
            [self unschedule:@selector(create_Enemy_Schedule:)];
        }
    }
    
}

-(void)onBackClicked:(id)sender
{
    // back to intro scene with transition
    [[CCDirector sharedDirector] replaceScene:[TitleScene scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];
    
}

@end
