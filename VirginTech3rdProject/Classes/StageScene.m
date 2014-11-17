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
#import "BasicMath.h"
#import "Fortress.h"
#import "Player.h"
#import "Enemy.h"

@implementation StageScene

CGSize winSize;
CCSprite* bgSpLayer;
CCScrollView* scrollView;
CGPoint worldLocation;

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

//デバッグ用ラベル
CCLabelTTF* debugLabel;
int pCnt;
int eCnt;

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
    
    // Enable touch handling on scene node
    self.userInteractionEnabled = YES;
    
    //初期化
    playerArray=[[NSMutableArray alloc]init];
    enemyArray=[[NSMutableArray alloc]init];
    createPlayerFlg=false;
    gameEndFlg=false;
    pCnt=0;eCnt=0;
    
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
    
    //スクロールビュー配置 z:0
    bgSpLayer=[CCSprite spriteWithCGImage:image.CGImage key:nil];
    scrollView=[[CCScrollView alloc]initWithContentNode:bgSpLayer];
    scrollView.horizontalScrollEnabled=NO;
    bgSpLayer.position=CGPointMake(0, 0);
    [self addChild:scrollView z:0];
    
    // Create a back button
    CCButton *backButton = [CCButton buttonWithTitle:@"[タイトル]" fontName:@"Verdana-Bold" fontSize:15.0f];
    backButton.positionType = CCPositionTypeNormalized;
    backButton.position = ccp(0.9f, 0.95f); // Top Right of screen
    [backButton setTarget:self selector:@selector(onBackClicked:)];
    [self addChild:backButton];

    //デバッグラベル
    debugLabel=[CCLabelTTF labelWithString:@"青=000 赤=000" fontName:@"Verdana-Bold" fontSize:10];
    debugLabel.position=ccp(debugLabel.contentSize.width/2, winSize.height-debugLabel.contentSize.height/2);
    [self addChild:debugLabel];
    
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
    
    //我陣地ライン
    CCDrawNode* drawNode1=[CCDrawNode node];
    [drawNode1 drawSegmentFrom:ccp(0,[GameManager getWorldSize].height/5)
                                to:ccp([GameManager getWorldSize].width,[GameManager getWorldSize].height/5)
                                radius:0.5
                                color:[CCColor whiteColor]];
    [bgSpLayer addChild:drawNode1];
    
    //敵陣地ライン
    CCDrawNode* drawNode2=[CCDrawNode node];
    [drawNode2 drawSegmentFrom:ccp(0,[GameManager getWorldSize].height-[GameManager getWorldSize].height/5)
                                to:ccp([GameManager getWorldSize].width,[GameManager getWorldSize].height-[GameManager getWorldSize].height/5)
                                radius:0.5
                                color:[CCColor whiteColor]];
    [bgSpLayer addChild:drawNode2];

    //我逃避限界ライン
    CCDrawNode* drawNode3=[CCDrawNode node];
    [drawNode3 drawSegmentFrom:ccp(0,[GameManager getWorldSize].height/4)
                            to:ccp([GameManager getWorldSize].width,[GameManager getWorldSize].height/4)
                            radius:0.5
                            color:[CCColor blueColor]];
    [bgSpLayer addChild:drawNode3];
    
    //敵逃避限界ライン
    CCDrawNode* drawNode4=[CCDrawNode node];
    [drawNode4 drawSegmentFrom:ccp(0,[GameManager getWorldSize].height-[GameManager getWorldSize].height/4)
                            to:ccp([GameManager getWorldSize].width,[GameManager getWorldSize].height-[GameManager getWorldSize].height/4)
                            radius:0.5
                            color:[CCColor redColor]];
    [bgSpLayer addChild:drawNode4];

    //センターライン
    CCDrawNode* drawNode5=[CCDrawNode node];
    [drawNode5 drawSegmentFrom:ccp(0,[GameManager getWorldSize].height/2)
                            to:ccp([GameManager getWorldSize].width,[GameManager getWorldSize].height/2)
                        radius:0.5
                         color:[CCColor yellowColor]];
    [bgSpLayer addChild:drawNode5];
    
    //我城生成
    playerFortress=[Fortress createFortress:ccp([GameManager getWorldSize].width/2, 15) type:0];
    [bgSpLayer addChild:playerFortress];
    
    //敵城生成
    enemyFortress=[Fortress createFortress:ccp([GameManager getWorldSize].width/2,[GameManager getWorldSize].height-15) type:1];
    [bgSpLayer addChild:enemyFortress];
    
    //「敵」生成
    [self create_Enemy];
    
    //審判スケジュール開始
    [self schedule:@selector(judgement_Schedule:)interval:0.1];
    
}

- (void)onExit
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
                
                if(_player.mode!=1){
                    if(_player.nearPlayerCnt < _enemy.nearEnemyCnt){
                        if(_player.position.y>[GameManager getWorldSize].height/4){
                            collisSurfaceAngle = [self getCollisSurfaceAngle:_player.position pos2:_enemy.position];
                            _player.targetAngle = 2*collisSurfaceAngle-(_player.targetAngle+collisSurfaceAngle);
                            _player.targetAngle = [BasicMath getNormalize_Radian:_player.targetAngle];
                            _player.mode=1;
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
                if(_player.mode!=2){
                    if(_enemy.nearEnemyCnt <= _player.nearPlayerCnt){
                        _player.targetAngle=[BasicMath getAngle_To_Radian:_player.position ePos:_enemy.position];
                        _player.mode=2;
                    }
                    if(_player.position.y<[GameManager getWorldSize].height/4){
                        _player.targetAngle=[BasicMath getAngle_To_Radian:_player.position ePos:_enemy.position];
                        _player.mode=2;
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
                        if(_enemy.position.y<[GameManager getWorldSize].height-[GameManager getWorldSize].height/4){
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
                    if(_enemy.position.y>[GameManager getWorldSize].height-[GameManager getWorldSize].height/4){
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
                _player.ability--;
                _enemy.ability--;
                
                _player.stopFlg=true;
                _enemy.stopFlg=true;
                
                _player.targetAngle=[BasicMath getAngle_To_Radian:_player.position ePos:_enemy.position];
                _enemy.targetAngle=[BasicMath getAngle_To_Radian:_enemy.position ePos:_player.position];
                
                _player.mode=3;
                _enemy.mode=3;
                
                break;
            }
        }
    }
    
    //==============
    //陣地内判定
    //==============
    for(Player* _player in playerArray){
        //敵陣地内に入ったら
        if(_player.position.y>[GameManager getWorldSize].height-[GameManager getWorldSize].height/5){
            _player.targetAngle=[BasicMath getAngle_To_Radian:_player.position ePos:enemyFortress.position];
        }
    }

    for(Enemy* _enemy in enemyArray){
        //プレイヤー陣地内に入ったら
        if(_enemy.position.y<[GameManager getWorldSize].height/5){
            _enemy.targetAngle=[BasicMath getAngle_To_Radian:_enemy.position ePos:playerFortress.position];
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
                    [bgSpLayer removeChild:enemyFortress cleanup:YES];
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
                    [bgSpLayer removeChild:playerFortress cleanup:YES];
                    gameEndFlg=true;
                }
            }
        }
    }
    
    //「敵」作成
    if(eCnt<20){
        [self create_Enemy];
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
    debugLabel.string=[NSString stringWithFormat:@"青=%03d 赤=%03d",pCnt,eCnt];
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
        [bgSpLayer removeChild:_player cleanup:YES];
        pCnt--;
    }
    for(Enemy* _enemy in removeEnemyArray)
    {
        [enemyArray removeObject:_enemy];
        [bgSpLayer removeChild:_enemy cleanup:YES];
        eCnt--;
    }
}

-(void)create_Enemy{
    
    int xOff=0;
    int yOff=0;
    
    for(int i=0;i<20;i++)
    {
        if(i%5==0){
            yOff=yOff+20;
            xOff=0;
        }else{
            xOff=xOff+25;
        }
        enemy=[Enemy createEnemy:ccp(50+xOff,[GameManager getWorldSize].height*0.8+yOff)];
        [bgSpLayer addChild:enemy];
        [enemyArray addObject:enemy];
        eCnt++;
    }
    
    xOff=0;
    yOff=0;
    
    for(int i=0;i<20;i++)
    {
        if(i%5==0){
            yOff=yOff+20;
            xOff=0;
        }else{
            xOff=xOff+25;
        }
        enemy=[Enemy createEnemy:ccp([GameManager getWorldSize].width-150+xOff,[GameManager getWorldSize].height*0.8+yOff)];
        [bgSpLayer addChild:enemy];
        [enemyArray addObject:enemy];
        eCnt++;
    }

}


UITouch* touches;
UIEvent* events;

-(void)create_Player_Schedule:(CCTime)dt
{
    if(pCnt<40){
        if(touches.tapCount>0 && worldLocation.y<[GameManager getWorldSize].height/5){
            player=[Player createPlayer:worldLocation];
            [bgSpLayer addChild:player];
            [playerArray addObject:player];
            [self touchBegan:touches withEvent:events];
            pCnt++;
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
    if(worldLocation.y<[GameManager getWorldSize].height/5){
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
        }
    }

    /*/敵作成
    if(worldLocation.y>[GameManager getWorldSize].height-[GameManager getWorldSize].height/5){
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
    }
}

- (void)onBackClicked:(id)sender
{
    // back to intro scene with transition
    [[CCDirector sharedDirector] replaceScene:[TitleScene scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];

}

@end
