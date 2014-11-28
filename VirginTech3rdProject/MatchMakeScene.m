//
//  MatchMakeScene.m
//  VirginTech3rdProject
//
//  Created by VirginTech LLC. on 2014/11/27.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "MatchMakeScene.h"
#import "TitleScene.h"

@implementation MatchMakeScene

CGSize winSize;
GKMatch* currentMatch;

typedef struct {
    int a;
    int b;
} MyData;

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
    
    // Create a colored background (Dark Grey)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];
    [self addChild:background];
    
    // Create a back button
    CCButton *backButton = [CCButton buttonWithTitle:@"[タイトル]" fontName:@"Verdana-Bold" fontSize:15.0f];
    backButton.positionType = CCPositionTypeNormalized;
    backButton.position = ccp(0.9f, 0.95f); // Top Right of screen
    [backButton setTarget:self selector:@selector(onBackClicked:)];
    [self addChild:backButton];
    
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
}

-(void)onExit
{
    // always call super onExit last
    [super onExit];
}

-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    [self sendDataToAllPlayers];
}

-(void)onBackClicked:(id)sender
{
    // back to intro scene with transition
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

-(void)sendDataToAllPlayers
{
    NSLog(@"送信されました！");
    
    MyData data;
    data.a=10;
    data.b=20;
    
    NSError *error = nil;
    NSData *packetData = [NSData dataWithBytes:&data length:sizeof(MyData)];
    [currentMatch sendDataToAllPlayers:packetData withDataMode:GKMatchSendDataUnreliable error:&error];
    if (error != nil){
        NSLog(@"%@",error);
    }
}

-(void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString*)playerID
{
    NSLog(@"受信されました！");
    
    MyData* data1;
    data1=(MyData*)[data bytes];
    
    NSLog(@"A=%d B=%d",data1->a,data1->b);
}

@end
