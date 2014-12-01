//
//  MatchMakeScene.m
//  VirginTech3rdProject
//
//  Created by VirginTech LLC. on 2014/11/27.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "MatchMakeScene.h"
#import "GameManager.h"
#import "TitleScene.h"
#import "Fortress.h"
#import "mPlayer.h"
#import "mEnemy.h"

struct Msg_Data {
    int msgNum;//メッセージ種別
    float x;//posX
    float y;//posY
};
typedef struct Msg_Data Msg_Data;

@implementation MatchMakeScene

CGSize winSize;
GKMatch* currentMatch;

CGSize offSet;
CGPoint touchPos;
bool createObjectFlg;

mPlayer* m_player;
mEnemy* m_enemy;

Fortress* playerFortress;
Fortress* enemyFortress;

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
    return currentMatch;
}
+(void)setCurrentMatch:(GKMatch*)match
{
    currentMatch=match;
}

+(MatchMakeScene *)scene
{
    return [[self alloc] init];
}

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    winSize=[[CCDirector sharedDirector]viewSize];

    self.userInteractionEnabled = YES;
    
    //GKMatchデリゲート
    currentMatch.delegate=self;
    
    //初期化
    createObjectFlg=false;
    pTotalCnt=0;
    pCnt=0;
    pMaxCnt=250;
    
    eTotalCnt=0;
    eCnt=0;
    eMaxCnt=250;
    
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
    CCDrawNode* worldLine_v1=[CCDrawNode node];
    [worldLine_v1 drawSegmentFrom:ccp(offSet.width+0,offSet.height+0)
                            to:ccp(offSet.width+0,offSet.height+[GameManager getWorldSize].height)
                            radius:0.5
                            color:[CCColor whiteColor]];
    [self addChild:worldLine_v1];

    CCDrawNode* worldLine_v2=[CCDrawNode node];
    [worldLine_v2 drawSegmentFrom:ccp(offSet.width+[GameManager getWorldSize].width,offSet.height+0)
                               to:ccp(offSet.width+[GameManager getWorldSize].width,offSet.height+[GameManager getWorldSize].height)
                           radius:0.5
                            color:[CCColor whiteColor]];
    [self addChild:worldLine_v2];

    CCDrawNode* worldLine_h1=[CCDrawNode node];
    [worldLine_h1 drawSegmentFrom:ccp(offSet.width+0,offSet.height+0)
                               to:ccp(offSet.width+[GameManager getWorldSize].width,offSet.height+0)
                           radius:0.5
                            color:[CCColor whiteColor]];
    [self addChild:worldLine_h1];

    CCDrawNode* worldLine_h2=[CCDrawNode node];
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
    currentMatch.delegate=nil;
    [currentMatch disconnect];
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
    
    
    
    
    //デバッグラベル更新
    debugLabel3.string=[NSString stringWithFormat:@"青=%03d 赤=%03d",pCnt,eCnt];
    debugLabel4.string=[NSString stringWithFormat:@"pTotle=%04d",pTotalCnt];
    debugLabel5.string=[NSString stringWithFormat:@"eTotle=%04d",eTotalCnt];
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
                m_player=[mPlayer createPlayer:touchPos];
                [self addChild:m_player];
                pCnt++;
                pTotalCnt++;
                //データ送信
                [self sendDataToAllPlayers:0 pos:touchPos];
            }else{
                //カウント超過停止
                createObjectFlg=false;
                [self unschedule:@selector(create_Object_Schedule:)];
            }
        }else{//赤(Enemy)
            if(eCnt<40 && eTotalCnt<eMaxCnt){
                m_enemy=[mEnemy createEnemy:touchPos];
                [self addChild:m_enemy];
                eCnt++;
                eTotalCnt++;
                //データ送信
                [self sendDataToAllPlayers:0 pos:touchPos];
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
    currentMatch.delegate=nil;
    [currentMatch disconnect];
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
-(void)sendDataToAllPlayers:(int)_msgNum pos:(CGPoint)_pos;
{
    Msg_Data msgData;

    msgData.msgNum=_msgNum;
    msgData.x=_pos.x-offSet.width;
    msgData.y=_pos.y-offSet.height;

    NSError *error = nil;
    NSData *packetData = [NSData dataWithBytes:&msgData length:sizeof(Msg_Data)];
    [currentMatch sendDataToAllPlayers:packetData withDataMode:GKMatchSendDataUnreliable error:&error];
    
    if (error != nil){
        NSLog(@"%@",error);
    }
}
//==========================
// 　　　受信メソッド
//==========================
-(void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID
{
    Msg_Data* msgData;
    msgData=(Msg_Data*)[data bytes];
    
    int _msgNum=msgData->msgNum;
    //同じ位置なら
    float _x=msgData->x+offSet.width;
    float _y=msgData->y+offSet.height;

    //======================
    // 相手オブジェクト配置
    //======================
    if(_msgNum==0)
    {
        //対称軸へ置く
        _x=winSize.width-msgData->x-offSet.width;
        _y=winSize.height-msgData->y-offSet.height;
        
        if([GameManager getHost]){
            m_enemy=[mEnemy createEnemy:ccp(_x,_y)];
            [self addChild:m_enemy];
            eCnt++;
            eTotalCnt++;
        }else{
            m_player=[mPlayer createPlayer:ccp(_x,_y)];
            [self addChild:m_player];
            pCnt++;
            pTotalCnt++;
        }
    }
    //======================
    //
    //======================
    else if(_msgNum==1)
    {
    
    }
    //======================
    //
    //======================
    else if(_msgNum==2)
    {
        
    }
    //======================
    //
    //======================
    else
    {
        
    }
}

@end
