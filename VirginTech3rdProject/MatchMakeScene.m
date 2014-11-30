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
    CGPoint pos;//ポジション
};
typedef struct Msg_Data Msg_Data;

@implementation MatchMakeScene

CGSize winSize;
GKMatch* currentMatch;

CGPoint touchPos;
float footer;

mPlayer* player;
mEnemy* enemy;

Fortress* playerFortress;
Fortress* enemyFortress;

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
    footer=0;
    
    //レベルに応じた画面の大きさ
    [GameManager setWorldSize:CGSizeMake(winSize.width, winSize.height)];
    
    // Create a colored background (Dark Grey)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];
    [self addChild:background];
    
    // Create a back button
    CCButton *backButton = [CCButton buttonWithTitle:@"[タイトル]" fontName:@"Verdana-Bold" fontSize:15.0f];
    backButton.positionType = CCPositionTypeNormalized;
    backButton.position = ccp(0.9f, 0.95f); // Top Right of screen
    [backButton setTarget:self selector:@selector(onBackClicked:)];
    [self addChild:backButton];
    
    //デバッグラベル
    CCLabelTTF* lbl_1;
    if([GameManager getHost]){
        lbl_1=[CCLabelTTF labelWithString:@"サーバー" fontName:@"Verdana-Bold" fontSize:20];
    }else{
        lbl_1=[CCLabelTTF labelWithString:@"クライアント" fontName:@"Verdana-Bold" fontSize:20];
    }
    lbl_1.position=ccp(lbl_1.contentSize.width/2,winSize.height-lbl_1.contentSize.height/2);
    [self addChild:lbl_1];
    
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
        playerFortress=[Fortress createFortress:ccp([GameManager getWorldSize].width/2,footer+15) type:0];
        [self addChild:playerFortress];
        enemyFortress=[Fortress createFortress:ccp([GameManager getWorldSize].width/2,[GameManager getWorldSize].height-15) type:1];
        [self addChild:enemyFortress];
    }else{
        enemyFortress=[Fortress createFortress:ccp([GameManager getWorldSize].width/2,footer+15) type:1];
        [self addChild:enemyFortress];
        playerFortress=[Fortress createFortress:ccp([GameManager getWorldSize].width/2,[GameManager getWorldSize].height-15) type:0];
        [self addChild:playerFortress];
    }
    
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

}

-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [touch locationInNode:self];
    touchPos=touchLocation;
    player=[mPlayer createPlayer:touchLocation];
    [self addChild:player];
    //データ送信
    [self sendDataToAllPlayers:0 pos:touchPos];
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

//=============
// 送信メソッド
//=============
-(void)sendDataToAllPlayers:(int)_msgNum pos:(CGPoint)_pos;
{
    Msg_Data msgData;

    msgData.msgNum=_msgNum;
    msgData.pos=_pos;
    
    NSError *error = nil;
    NSData *packetData = [NSData dataWithBytes:&msgData length:sizeof(Msg_Data)];
    [currentMatch sendDataToAllPlayers:packetData withDataMode:GKMatchSendDataUnreliable error:&error];
    
    if (error != nil){
        NSLog(@"%@",error);
    }
}
//=============
// 受信メソッド
//=============
-(void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString*)playerID
{
    Msg_Data* msgData;
    msgData=(Msg_Data*)[data bytes];
    
    int _msgNum=msgData->msgNum;
    CGPoint _pos=msgData->pos;
    
    if(_msgNum==0){
        player=[mPlayer createPlayer:ccp(_pos.x,_pos.y)];
        [self addChild:player];
    }else if(_msgNum==1){
    
    }else{
        
    }
}

@end
