//
//  HelloWorldScene.m
//  VirginTech3rdProject
//
//  Created by VirginTech LLC. on 2014/10/19.
//  Copyright VirginTech LLC. 2014年. All rights reserved.
//
// -----------------------------------------------------------------------

#import "StageScene.h"
#import "CCDrawNode.h"
#import "TitleScene.h"
#import "GameManager.h"
#import "InitObjManager.h"
#import "BasicMath.h"
#import "ItemBtnLayer.h"
#import "Fortress.h"
#import "Player.h"
#import "Enemy.h"
#import "NaviLayer.h"
#import "InfoLayer.h"
#import "ResultsLayer.h"
#import "SoundManager.h"

@implementation StageScene

CGSize winSize;
CCSprite* bgSpLayer;
CCScrollView* scrollView;
CGPoint worldLocation;

MessageLayer* msgBox;
InfoLayer* infoLayer;

ItemBtnLayer* itemLayer;
int itemNum;
float footer;

int repeatNum;
int stageNum;

Fortress* playerFortress;
Fortress* enemyFortress;
bool gameEndFlg;
bool winnerFlg;//true:青軍 false:赤軍
bool highScoreFlg;

int bombAnimeCnt;
CCSprite* pBomb;
CCSprite* eBomb;

Player* player;
NSMutableArray* playerArray;
NSMutableArray* removePlayerArray;
bool createPlayerFlg;
int playerDieCount;

Enemy* enemy;
NSMutableArray* enemyArray;
NSMutableArray* removeEnemyArray;
bool createEnemyFlg;
int enemyDieCount;

//パーティクル
CCParticleSystem* bombParticle;
//CCParticleSystem* rushLoadParticle;
CCParticleSystem* dieParticle;
//NSMutableArray* bombParticleArray;

//デバッグ用ラベル
//int repCnt;
//CCLabelTTF* debugLabel1;
//CCLabelTTF* debugLabel2;
//CCLabelTTF* debugLabel3;
//CCLabelTTF* debugLabel4;
//CCLabelTTF* debugLabel5;

//カウンター
//int pMaxCnt;
//int eMaxCnt;
//int pTotalCnt;
//int pCnt;
//int eCnt;

+ (StageScene *)scene
{
    return [[self alloc] init];
}

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    winSize=[[CCDirector sharedDirector]viewSize];
    
    //エフェクトサウンド
    [SoundManager ready_Effect];
    
    // Enable touch handling on scene node
    self.userInteractionEnabled = YES;
    
    //初期化
    TURN_OBJ_MAX=40;
    footer=60;
    playerArray=[[NSMutableArray alloc]init];
    enemyArray=[[NSMutableArray alloc]init];
    //bombParticleArray=[[NSMutableArray alloc]init];
    bombParticle=nil;
    dieParticle=nil;
    createPlayerFlg=false;
    gameEndFlg=false;
    stageNum=[GameManager getStageLevel];
    [GameManager setPause:false];
    [GameManager setCurrentScore:0];
    playerDieCount=0;
    enemyDieCount=0;
    bombAnimeCnt=0;
    
    // Create a colored background (Dark Grey)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];
    [self addChild:background];
    
    //インフォレイヤー
    infoLayer=[[InfoLayer alloc]init];
    [self addChild:infoLayer z:1];
    
    //アイテムボタンレイヤー
    itemLayer=[[ItemBtnLayer alloc]init];
    [self addChild:itemLayer z:2];
    
    //ナビレイヤー
    NaviLayer* naviLayer=[[NaviLayer alloc]init];
    [self addChild:naviLayer z:3];
    
    //レベルに応じた画面の大きさ
    [GameManager setWorldSize:CGSizeMake(winSize.width, winSize.height)];
    
    UIImage *image = [UIImage imageNamed:@"bgLayer.png"];
    UIGraphicsBeginImageContext(CGSizeMake(winSize.width,[GameManager getWorldSize].height));
    [image drawInRect:CGRectMake(0, 0, winSize.width,[GameManager getWorldSize].height)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //スクロールビュー配置 z:0
    bgSpLayer=[CCSprite spriteWithCGImage:image.CGImage key:nil];
    scrollView=[[CCScrollView alloc]initWithContentNode:bgSpLayer];
    scrollView.horizontalScrollEnabled=NO;
    bgSpLayer.position=CGPointMake(0, 0);
    [self addChild:scrollView z:0];
    
    //地面配置
    [self setGround];
    [self setYard];
    
    // Create a back button
    /*CCButton *backButton = [CCButton buttonWithTitle:@"[タイトル]" fontName:@"Verdana-Bold" fontSize:15.0f];
    backButton.positionType = CCPositionTypeNormalized;
    backButton.position = ccp(0.9f, 0.95f); // Top Right of screen
    [backButton setTarget:self selector:@selector(onBackClicked:)];
    [self addChild:backButton];*/

    /*/デバッグラベル
    debugLabel1=[CCLabelTTF labelWithString:@"青=000 赤=000" fontName:@"Verdana-Bold" fontSize:10];
    debugLabel1.position=ccp(debugLabel1.contentSize.width/2, winSize.height-debugLabel1.contentSize.height/2);
    [self addChild:debugLabel1];

    debugLabel2=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"PlayerMax=%d",pMaxCnt] fontName:@"Verdana-Bold" fontSize:10];
    debugLabel2.position=ccp(debugLabel2.contentSize.width/2, debugLabel1.position.y-debugLabel2.contentSize.height);
    [self addChild:debugLabel2];

    debugLabel3=[CCLabelTTF labelWithString:@"Totle=0000" fontName:@"Verdana-Bold" fontSize:10];
    debugLabel3.position=ccp(debugLabel3.contentSize.width/2, debugLabel2.position.y-debugLabel3.contentSize.height);
    [self addChild:debugLabel3];

    debugLabel4=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"eRepeat: 0/0"]fontName:@"Verdana-Bold" fontSize:10];
    debugLabel4.position=ccp(debugLabel4.contentSize.width/2, debugLabel3.position.y-debugLabel4.contentSize.height);
    [self addChild:debugLabel4];

    debugLabel5=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"EnemyMax=%d",eMaxCnt]fontName:@"Verdana-Bold" fontSize:10];
    debugLabel5.position=ccp(debugLabel5.contentSize.width/2, debugLabel4.position.y-debugLabel5.contentSize.height);
    [self addChild:debugLabel5];*/
    
    // done
	return self;
}

- (void)dealloc
{
    // clean up code goes here
}

- (void)onEnter
{
    // always call super onEnter first
    [super onEnter];
    
    //アイテムライン
    /*CCDrawNode* drawNode0=[CCDrawNode node];
    [drawNode0 drawSegmentFrom:ccp(0,footer)
                            to:ccp([GameManager getWorldSize].width, footer)
                        radius:0.5
                         color:[CCColor whiteColor]];
    [bgSpLayer addChild:drawNode0];
    
    //我陣地ライン
    CCDrawNode* drawNode1=[CCDrawNode node];
    [drawNode1 drawSegmentFrom:ccp(0,footer+([GameManager getWorldSize].height-footer)*0.2)
                                to:ccp([GameManager getWorldSize].width,footer+([GameManager getWorldSize].height-footer)*0.2)
                                radius:0.5
                                color:[CCColor whiteColor]];
    [bgSpLayer addChild:drawNode1];
    
    //敵陣地ライン
    CCDrawNode* drawNode2=[CCDrawNode node];
    [drawNode2 drawSegmentFrom:ccp(0,footer+([GameManager getWorldSize].height-footer)*0.8)
                                to:ccp([GameManager getWorldSize].width,footer+([GameManager getWorldSize].height-footer)*0.8)
                                radius:0.5
                                color:[CCColor whiteColor]];
    [bgSpLayer addChild:drawNode2];*/

    //我逃避限界ライン
    CCDrawNode* drawNode3=[CCDrawNode node];
    [drawNode3 drawSegmentFrom:ccp(0,footer+([GameManager getWorldSize].height-footer)*0.25)
                            to:ccp([GameManager getWorldSize].width,footer+([GameManager getWorldSize].height-footer)*0.25)
                            radius:0.5
                            color:[CCColor blueColor]];
    [bgSpLayer addChild:drawNode3];
    
    //敵逃避限界ライン
    CCDrawNode* drawNode4=[CCDrawNode node];
    [drawNode4 drawSegmentFrom:ccp(0,footer+([GameManager getWorldSize].height-footer)*0.75)
                            to:ccp([GameManager getWorldSize].width,footer+([GameManager getWorldSize].height-footer)*0.75)
                            radius:0.5
                            color:[CCColor redColor]];
    [bgSpLayer addChild:drawNode4];

    //センターライン
    CCDrawNode* drawNode5=[CCDrawNode node];
    [drawNode5 drawSegmentFrom:ccp(0,footer+([GameManager getWorldSize].height-footer)/2)
                            to:ccp([GameManager getWorldSize].width,footer+([GameManager getWorldSize].height-footer)/2)
                        radius:0.5
                         color:[CCColor yellowColor]];
    [bgSpLayer addChild:drawNode5];
    
    //我城生成
    playerFortress=[Fortress createFortress:ccp([GameManager getWorldSize].width/2,footer+15) type:0];
    pBomb=[CCSprite spriteWithSpriteFrame:
                    [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"bomb.png"]];
    pBomb.position=ccp(playerFortress.contentSize.width/2,playerFortress.contentSize.height/2);
    pBomb.scale=0.5;
    pBomb.visible=false;
    [playerFortress addChild:pBomb];
    [bgSpLayer addChild:playerFortress z:1];
    
    //敵城生成
    enemyFortress=[Fortress createFortress:ccp([GameManager getWorldSize].width/2,[GameManager getWorldSize].height-15) type:1];
    eBomb=[CCSprite spriteWithSpriteFrame:
                    [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"bomb.png"]];
    eBomb.position=ccp(enemyFortress.contentSize.width/2,enemyFortress.contentSize.height/2);
    eBomb.scale=0.5;
    eBomb.visible=false;
    [enemyFortress addChild:eBomb];
    [bgSpLayer addChild:enemyFortress z:1];
    
    //カスタムアラートメッセージ
    NSString* msg=[NSString stringWithFormat:@"・%@: %d %@\n・%@: %d %@\n\n　%@",
                    NSLocalizedString(@"RedArmy",NULL),
                    (int)[InitObjManager init_Enemy_Pattern:stageNum].count*([InitObjManager NumOfRepeat:stageNum]+1),
                    NSLocalizedString(@"Man",NULL),
                    NSLocalizedString(@"BlueArmy",NULL),
                    [InitObjManager NumPlayerMax:stageNum],
                    NSLocalizedString(@"Man",NULL),
                    NSLocalizedString(@"YouReady",NULL)
                    ];
    
    msgBox=[[MessageLayer alloc]initWithTitle:@"戦闘準備!"
                                                msg:msg
                                                pos:ccp(winSize.width/2,winSize.height/2)
                                                size:CGSizeMake(200, 120)
                                                modal:true
                                                rotation:false
                                                type:0
                                                procNum:1];
    msgBox.delegate=self;//デリゲートセット
    [self addChild:msgBox z:4];
    
    //「敵」生成スケジュール
    //repeatNum=[InitObjManager NumOfRepeat:stageNum];
    //int interval=[InitObjManager NumOfInterval:stageNum];
    //[self schedule:@selector(create_Enemy_Schedule:)interval:interval repeat:CCTimerRepeatForever delay:1.0];
    
    //審判スケジュール開始
    //[self schedule:@selector(judgement_Schedule:)interval:0.1];
    
}

- (void)onExit
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
        [bgSpLayer addChild:frame z:0];
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
                        (footer+([GameManager getWorldSize].height-footer)*0.2)/(frame.contentSize.height*scale)+1);
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
            offsetY = (footer+([GameManager getWorldSize].height-footer)*0.2)-(frame.contentSize.height*scale)/2;
        }else if(i%(int)frameCount.width==0){
            offsetX = (frame.contentSize.width*scale)/2-1;
            offsetY = offsetY - (frame.contentSize.height*scale)+1;
        }else{
            offsetX = offsetX + (frame.contentSize.width*scale)-1;
        }
        frame.position = CGPointMake(offsetX,offsetY);
        [bgSpLayer addChild:frame z:0];
    }
    //敵側陣地
    for(int i=0;i<frameCount.width*frameCount.height;i++)
    {
        frame = [CCSprite spriteWithSpriteFrame:
                 [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:bgName]];
        frame.scale=scale;
        if(i==0){
            offsetX = (frame.contentSize.width*scale)/2-1;
            offsetY = (footer+([GameManager getWorldSize].height-footer)*0.8)+(frame.contentSize.height*scale)/2;
        }else if(i%(int)frameCount.width==0){
            offsetX = (frame.contentSize.width*scale)/2-1;
            offsetY = offsetY + (frame.contentSize.height*scale)-1;
        }else{
            offsetX = offsetX + (frame.contentSize.width*scale)-1;
        }
        frame.position = CGPointMake(offsetX,offsetY);
        [bgSpLayer addChild:frame z:0];
    }
}

//=====================
// デリゲートメソッド
//=====================
-(void)onMessageLayerBtnClocked:(int)btnNum procNum:(int)procNum
{
    if(procNum==1){
        //BGMスタート
        [SoundManager playBGM:@"battle_bgm01.mp3"];
        //「敵」生成スケジュール
        repeatNum=[InitObjManager NumOfRepeat:stageNum];
        int interval=[InitObjManager NumOfInterval:stageNum];
        [self schedule:@selector(create_Enemy_Schedule:)interval:interval repeat:CCTimerRepeatForever delay:1.0];
        //審判スケジュール開始
        [self schedule:@selector(judgement_Schedule:)interval:0.1];
    }
    msgBox.delegate=nil;//デリゲート解除
}

-(void)create_Enemy_Schedule:(CCTime)dt
{
    if([GameManager getPause]){
        return;
    }
    
    CGPoint pos;
    NSMutableArray* array=[[NSMutableArray alloc]init];
    array=[InitObjManager init_Enemy_Pattern:stageNum];
    
    infoLayer.repCnt++;
    
    for(int i=0;i<array.count;i++)
    {
        pos=[[array objectAtIndex:i]CGPointValue];
        enemy=[Enemy createEnemy:pos];
        [bgSpLayer addChild:enemy z:array.count-i];
        [enemyArray addObject:enemy];
        infoLayer.eCnt++;
        if(i==0){
            [SoundManager wao_Effect];
        }
    }
    if(infoLayer.repCnt>repeatNum){
        [self unschedule:@selector(create_Enemy_Schedule:)];
    }
}

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
                    if(_player.mode!=1 && _player.mode!=3){
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
                    if(_player.mode!=2 && _player.mode!=3){
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
                
                if(_enemy.mode!=1 && _enemy.mode!=3){
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
                if(_enemy.mode!=2 && _enemy.mode!=3){
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
                                            radius1:(_player.contentSize.width*_player.scale)/2 -5.0f
                                            radius2:(_enemy.contentSize.width*_enemy.scale)/2 -5.0f])
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
                    //爆発パーティクル
                    [self setBombParticle:_player.position];
                    //サウンドエフェクト
                    [SoundManager bomb_Effect];
                    
                    for(Enemy* _enemy_ in enemyArray){
                        if([BasicMath RadiusContainsPoint:_player.position
                                                        pointB:_enemy_.position
                                                        radius:50])
                        {
                            _enemy_.ability=0;
                        }
                    }
                    _player.itemNum=0;
                }/*else if(_player.itemNum==4){//攻撃アップ
                    _player.ability--;
                    _enemy.ability-=3;
                }else{//通常・その他
                    //_player.ability--;
                    //_enemy.ability--;*/
                _player.targetObject=_enemy;
                _enemy.targetObject=_player;
                //}
                
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
    
    //===============
    //戦闘後復帰処理
    //===============
    for(Player* _player in playerArray){
        if(_player.mode==3){
            bool hitFlg=false;
            for(Enemy* _enemy in enemyArray){
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
    for(Enemy* _enemy in enemyArray){
        if(_enemy.mode==3){
            bool hitFlg=false;
            for(Player* _player in playerArray){
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
    for(Player* _player in playerArray){
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
                    
                    if(enemyFortress.ability<=0){
                        //[bgSpLayer removeChild:enemyFortress cleanup:YES];
                        gameEndFlg=true;
                        winnerFlg=true;
                        [self gameEnd];
                    }
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
            if(_enemy.mode!=3){
                if(!gameEndFlg){
                    _enemy.stopFlg=true;
                    _enemy.mode=4;
                    _enemy.targetAngle=[BasicMath getAngle_To_Radian:_enemy.position ePos:playerFortress.position];
                    //playerFortress.ability--;
                    _enemy.targetObject=playerFortress;
                    
                    if(playerFortress.ability<=0){
                        //[bgSpLayer removeChild:playerFortress cleanup:YES];
                        gameEndFlg=true;
                        winnerFlg=false;
                        [self gameEnd];
                    }
                }
            }
        }
    }
    
    /*/=============
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
    }*/
    
    //===================
    //消滅オブジェクト削除
    //===================
    for(Player* _player in playerArray){
        if(_player.ability<=0){
            [removePlayerArray addObject:_player];
            playerDieCount++;
        }
    }
    for(Enemy* _enemy in enemyArray){
        if(_enemy.ability<=0){
            [removeEnemyArray addObject:_enemy];
            enemyDieCount++;
            
            //スコア反映
            [GameManager setCurrentScore:[GameManager getCurrentScore]+1];

            //ゲームセンターへ送信
            //TODO
            
            
            

        }
    }
    [self removeObject];
    
    //インフォレイヤー更新
    [infoLayer stats_Update];
    [infoLayer score_Update];
    
    //デバッグラベル更新
    //debugLabel1.string=[NSString stringWithFormat:@"青=%03d 赤=%03d",pCnt,eCnt];
    //debugLabel3.string=[NSString stringWithFormat:@"Totle=%04d",pTotalCnt];
    //debugLabel4.string=[NSString stringWithFormat:@"eRepeat:%d／%d",repCnt,[InitObjManager NumOfRepeat:stageNum]+1];

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
        [self setDieParticle:_player.position];
        [self setTomb:_player.position];
        if(playerDieCount%3==0){
            [SoundManager die_Player_Effect];
        }
        [playerArray removeObject:_player];
        [bgSpLayer removeChild:_player cleanup:YES];
        infoLayer.pCnt--;
    }
    for(Enemy* _enemy in removeEnemyArray)
    {
        [self setDieParticle:_enemy.position];
        [self setTomb:_enemy.position];
        if(enemyDieCount%3==0){
            [SoundManager die_Enemy_Effect];
        }
        [enemyArray removeObject:_enemy];
        [bgSpLayer removeChild:_enemy cleanup:YES];
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
    [bgSpLayer addChild:tomb z:0];
}

//==================
// ゲームエンド
//==================
-(void)gameEnd
{
    self.userInteractionEnabled = NO;
    [GameManager setPause:true];
    
    for(Player* _player in playerArray){
        _player.stopFlg=true;
    }
    for(Enemy* _enemy in enemyArray){
        _enemy.stopFlg=true;
    }
    
    //サウンドオールストップ
    [SoundManager all_Stop];
    
    //スコアリング処理
    if(winnerFlg){//勝ちなら
        //プレイヤー城アビリティ残量をスコアへ加算
        [GameManager setCurrentScore:[GameManager getCurrentScore]+playerFortress.ability];
        //敵城アビリティ「500」加算
        [GameManager setCurrentScore:[GameManager getCurrentScore]+500];
        //残存我兵の数をスコアに加算
        [GameManager setCurrentScore:[GameManager getCurrentScore]+(infoLayer.pMaxCnt-playerDieCount)];
        //スコア更新
        [infoLayer score_Update];
    }
    
    //ハイスコア保存
    highScoreFlg=false;
    if([GameManager getCurrentScore]>[GameManager load_Stage_Score:stageNum]){//ハイスコア！
        highScoreFlg=true;
        [GameManager save_Stage_Score:stageNum score:[GameManager getCurrentScore]];//ステージスコア保存
        [GameManager save_High_Score:[GameManager load_Total_Score:50]];//全スコアをハイスコアへ保存
        [infoLayer highScore_Update];//ハイスコア更新
        
        //ゲームセンターへ送信
        [GameManager submit_Score_GameCenter:[GameManager load_High_Score]];

    }
    //全スケジュール停止
    [self unscheduleAllSelectors];

    //爆発スケジュール開始
    [self schedule:@selector(bomb_Schedule:) interval:0.1 repeat:30 delay:0.0f];
    
}

//int soundCnt=0;
-(void)bomb_Schedule:(CCTime)dt
{
    if(bombAnimeCnt<=20){//20回まで
        /*/爆発音を交互に
        if(soundCnt>1){
            soundCnt=0;
        }*/
        
        if(bombAnimeCnt%2==0){
            if(winnerFlg){
                //サウンドエフェクト
                [SoundManager f_Bomb_Effect:0];
                eBomb.position=ccp(arc4random()%(int)(eBomb.contentSize.width*eBomb.scale),
                                        arc4random()%(int)(eBomb.contentSize.height*eBomb.scale));
                eBomb.scale=(arc4random()%4+2)*0.1;
                eBomb.visible=true;
            }else{
                //サウンドエフェクト
                [SoundManager f_Bomb_Effect:0];
                pBomb.position=ccp(arc4random()%(int)(pBomb.contentSize.width*pBomb.scale),
                                        arc4random()%(int)(pBomb.contentSize.height*pBomb.scale)+
                                        (playerFortress.contentSize.height*playerFortress.scale)/3);
                pBomb.scale=(arc4random()%4+2)*0.1;
                pBomb.visible=true;
            }
            //soundCnt++;
        }else{
            if(winnerFlg){
                eBomb.visible=false;
            }else{
                pBomb.visible=false;
            }
        }
    }
    
    if(bombAnimeCnt>=30)
    {
        //リザルトレイヤー表示
        int stars=0;
        if(winnerFlg){//勝ちなら
            float ratio=(100.0f/500)*playerFortress.ability;
            if(ratio>=80){
                stars=3;
                if([GameManager load_StageClear_State:stageNum]<3){
                    [GameManager save_StageClear_State:stageNum rate:3];//ついでにステージクリア状態保存
                }
            }else if(ratio>=50 && ratio<80){
                stars=2;
                if([GameManager load_StageClear_State:stageNum]<2){
                    [GameManager save_StageClear_State:stageNum rate:2];//ついでにステージクリア状態保存
                }
            }else{
                stars=1;
                if([GameManager load_StageClear_State:stageNum]<1){
                    [GameManager save_StageClear_State:stageNum rate:1];//ついでにステージクリア状態保存
                }
            }
        }
        ResultsLayer* resultsLayer=[[ResultsLayer alloc]initWithWinner:winnerFlg
                                                                        stars:stars
                                                                        playerDie:playerDieCount
                                                                        enemyDie:enemyDieCount
                                                                        playerFortress:playerFortress.ability
                                                                        highScoreFlg:highScoreFlg];
        [self addChild:resultsLayer z:4];
    }
    
    bombAnimeCnt++;
}

-(void)setBombParticle:(CGPoint)pos
{
    /*/その都度削除
    for(CCParticleSystem* _particle in bombParticleArray){
        [bgSpLayer removeChild:_particle cleanup:YES];
    }
    bombParticleArray=[[NSMutableArray alloc]init];*/
    
    if(bombParticle!=nil){//その都度削除
        [bgSpLayer removeChild:bombParticle cleanup:YES];
    }
    bombParticle=[[CCParticleSystem alloc]initWithFile:@"bomb.plist"];
    bombParticle.position=pos;
    bombParticle.scale=0.3;
    [bgSpLayer addChild:bombParticle z:100];
    //[bombParticleArray addObject:bombParticle];
}

-(void)setDieParticle:(CGPoint)pos
{
    if(dieParticle!=nil){//その都度削除
        [bgSpLayer removeChild:dieParticle cleanup:YES];
    }
    dieParticle=[[CCParticleSystem alloc]initWithFile:@"die.plist"];
    dieParticle.position=pos;
    dieParticle.scale=0.5;
    [bgSpLayer addChild:dieParticle z:100];
    //[bombParticleArray addObject:bombParticle];
}

UITouch* touches;
UIEvent* events;

-(void)create_Player_Schedule:(CCTime)dt
{
    if(infoLayer.pCnt<TURN_OBJ_MAX && infoLayer.pTotalCnt<infoLayer.pMaxCnt){
        if(touches.tapCount>0 && worldLocation.y<footer+([GameManager getWorldSize].height-footer)*0.2){
            player=[Player createPlayer:worldLocation];
            [bgSpLayer addChild:player z:1];
            [playerArray addObject:player];
            //エフェクトサウンド
            [SoundManager creat_Object_Effect];
            if(infoLayer.pTotalCnt%5==0){
                [SoundManager run_Effect];
            }
            itemNum=[GameManager getItem];
            if(itemNum>0){//アイテムが選択されていて
                //アイテム数更新
                [GameManager save_Item_Individual:itemNum-1 value:[GameManager load_Item_Individual:itemNum-1]-1];
                [itemLayer updata_Item_Value];
                //アイテム数が0になったら無効化
                if([GameManager load_Item_Individual:itemNum-1]<=0){
                    [itemLayer btnSelectedDisable];
                }
            }
            /*if(itemNum==3){//突進モード・パーティクル
                CGPoint rushLoadPos=worldLocation;
                while(rushLoadPos.y<footer+([GameManager getWorldSize].height-footer)*0.8){
                    rushLoadParticle=[[CCParticleSystem alloc]initWithFile:@"rush.plist"];
                    rushLoadPos=ccp(rushLoadPos.x,rushLoadPos.y+25);
                    rushLoadParticle.position=rushLoadPos;
                    rushLoadParticle.scale=0.3;
                    [bgSpLayer addChild:rushLoadParticle];
                }
            }*/
            [self touchBegan:touches withEvent:events];
            infoLayer.pCnt++;
            infoLayer.pTotalCnt++;
        }else{
            //通常停止
            createPlayerFlg=false;
            [self unschedule:@selector(create_Player_Schedule:)];
            //アイテムボタン無効化
            [itemLayer btnSelectedDisable];
        }
    }else{
        //カウント超過停止
        createPlayerFlg=false;
        [self unschedule:@selector(create_Player_Schedule:)];
        //アイテムボタン無効化
        [itemLayer btnSelectedDisable];
    }
}

-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    touches=touch;
    events=event;
    scrollView.verticalScrollEnabled=YES;
    
    CGPoint touchLocation = [touch locationInNode:self];
    
    float offsetY = bgSpLayer.contentSize.height - winSize.height - scrollView.scrollPosition.y;
    worldLocation.x = touchLocation.x + scrollView.scrollPosition.x;
    worldLocation.y = touchLocation.y + offsetY;
    
    //プレイヤー作成
    if(worldLocation.y<footer+([GameManager getWorldSize].height-footer)*0.2){
        scrollView.verticalScrollEnabled=NO;
        if(!createPlayerFlg){
            //プレイヤー生成スケジュール開始
            [self schedule:@selector(create_Player_Schedule:)interval:0.1 repeat:CCTimerRepeatForever delay:0.15f];
            createPlayerFlg=true;
        }
    }else{
        //境界線超え停止
        if(createPlayerFlg){
            [self unschedule:@selector(create_Player_Schedule:)];
            createPlayerFlg=false;
            //アイテムボタン無効化
            [itemLayer btnSelectedDisable];
        }
    }

    /*/敵作成
    if(worldLocation.y>footer+([GameManager getWorldSize].height-footer)*0.8){
        enemy=[Enemy createEnemy:worldLocation];
        [bgSpLayer addChild:enemy];
        [enemyArray addObject:enemy];
        eCnt++;
    }*/
}

/*-(void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
}*/

-(void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    //チョンタッチ停止
    if(createPlayerFlg){
        createPlayerFlg=false;
        [self unschedule:@selector(create_Player_Schedule:)];
        //アイテムボタン無効化
        [itemLayer btnSelectedDisable];
    }
}

- (void)onBackClicked:(id)sender
{
    // back to intro scene with transition
    [[CCDirector sharedDirector] replaceScene:[TitleScene scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];

}

@end
