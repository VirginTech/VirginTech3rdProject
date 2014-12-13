//
//  LeaderboardView.m
//  GalacticSaga
//
//  Created by OOTANI,Kenji on 2013/02/10.
//
//

#import "GKitController.h"
#import "MatchMakeScene.h"
#import "GameManager.h"

@implementation GKitController

GKitController *viewController;
GKMatch* currentMatch;
int hostNum;
bool flg=false;

//=====================
//　リーダーボード画面
//=====================
- (void) showLeaderboard
{
    // LeaderboardのView Controllerを生成する
    GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
    
    // LeaderboardのView Controllerの生成に失敗した場合は処理を終了する
    if (leaderboardController == nil) {
        return;
    }
    
    // View Controllerを取得する
    viewController = (GKitController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    
    // delegateを設定する
    leaderboardController.leaderboardDelegate = viewController;
    
    // Leaderboardを表示する
    //[viewController presentModalViewController:leaderboardController animated:YES];
    [viewController presentViewController:leaderboardController animated:YES completion:^(void){}];
}

/*- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeRight;
}*/

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
    //[self dismissModalViewControllerAnimated:YES];
    [viewController dismissViewControllerAnimated:YES completion:^(void){}];
}

//=====================
//　マッチメイク画面
//=====================
-(void)showRequestMatch
{
    GKMatchRequest *request = [[GKMatchRequest alloc] init];
    request.minPlayers = 2;
    request.maxPlayers = 2;
    [self showMatchmakerWithRequest:request];
}

//招待ハンドラ
- (void)initMatchInviteHandler
{
    //if(gameCenterAvailable) {
    [GKMatchmaker sharedMatchmaker].inviteHandler = ^(GKInvite *acceptedInvite, NSArray *playersToInvite) {
        // 既存のマッチングを破棄する
        [MatchMakeScene setCurrentMatch:nil];
        currentMatch=nil;
        
        if (acceptedInvite) {
            // ゲーム招待を利用してマッチメイク画面を開く
            [self showMatchmakerWithInvite:acceptedInvite];
        } else if (playersToInvite) {
            // 招待するユーザを指定してマッチメイク要求を作成する
            GKMatchRequest *request = [[GKMatchRequest alloc] init];
            request.minPlayers = 2;
            request.maxPlayers = 2;
            request.playersToInvite = playersToInvite;
            
            [self showMatchmakerWithRequest:request];
        }
    };
    //}
}

//マッチメイク要求
- (void)showMatchmakerWithRequest:(GKMatchRequest *)request
{
    //初期化
    flg=false;
    hostNum=arc4random()%1000;
    [MatchMakeScene setCurrentMatch:nil];
    currentMatch=nil;
    
    GKMatchmakerViewController *mmvc = [[GKMatchmakerViewController alloc] initWithMatchRequest:request];
    viewController = (GKitController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    mmvc.matchmakerDelegate = self;
    [viewController presentViewController:mmvc animated:YES completion:nil];
}
//ゲーム招待
- (void)showMatchmakerWithInvite:(GKInvite *)invite
{
    //初期化
    flg=false;
    hostNum=arc4random()%1000;
    [MatchMakeScene setCurrentMatch:nil];
    currentMatch=nil;
    
    GKMatchmakerViewController *mmvc = [[GKMatchmakerViewController alloc] initWithInvite:invite];
    viewController = (GKitController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    mmvc.matchmakerDelegate = self;
    [viewController presentViewController:mmvc animated:YES completion:nil];
}

- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFindMatch:(GKMatch *)match
{
    [viewController dismissViewControllerAnimated:YES completion:nil];

    currentMatch=match;
    match.delegate = self;

    // 全ユーザが揃ったかどうか
    if (match.expectedPlayerCount == 0) {
        //親決め
        [self sendDataToAllPlayers];
    }
}

-(void)matchmakerViewControllerWasCancelled:(GKMatchmakerViewController*)viewController
{
    [viewController dismissViewControllerAnimated:YES completion:nil]; // ゲームに固有のコードをここに実装する。
    /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"GKMatchエラー"
                                                    message:@"GKMatchの取得に失敗しました(1)"
                                                    delegate:nil
                                                    cancelButtonTitle:nil
                                                    otherButtonTitles:@"OK", nil];
    [alert show];*/
}

-(void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFailWithError:(NSError *)error
{
    [viewController dismissViewControllerAnimated:YES completion:nil]; // ゲームに固有のコードをここに実装する。
    /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"GKMatchエラー"
                                                    message:@"GKMatchの取得に失敗しました(2)"
                                                    delegate:nil
                                                    cancelButtonTitle:nil
                                                    otherButtonTitles:@"OK", nil];
    [alert show];*/
}

//=============
// 送信メソッド
//=============
-(void)sendDataToAllPlayers;
{
    //NSLog(@"%dを送信しました",hostNum);
    NSError *error = nil;
    //ダミーヘッダー番号付与（対戦シーンへの誤データ送信防止）
    int header=99;
    NSMutableData* tmpData=[NSMutableData dataWithBytes:&header length:sizeof(header)];//ヘッダー部
    NSData *packetData = [[NSString stringWithFormat:@"%d",hostNum] dataUsingEncoding:NSUTF8StringEncoding];//本体部
    //合体
    [tmpData appendData:packetData];
    //送信
    [currentMatch sendDataToAllPlayers:tmpData withDataMode:GKMatchSendDataReliable error:&error];
    
    if (error != nil){
        NSLog(@"%@",error);
    }
}
//=============
// 受信メソッド
//=============
-(void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString*)playerID
{
    //ダミーヘッダー番号の取り出し
    int *header=malloc(sizeof(*header));//メモリー確保
    memset(header, 0, sizeof(*header));//初期化
    [data getBytes:header range:NSMakeRange(0, sizeof(*header))];//部分コピー
    //int _msgNum=*header;
    free(header);//解放
    
    //本体の取り出し
    long diffLength=data.length-sizeof(*header);//本体サイズ取得
    char *msg=malloc(diffLength);//メモリー確保
    memset(msg, 0, diffLength);//初期化
    [data getBytes:msg range:NSMakeRange(sizeof(*header), diffLength)];//部分コピー
    
    //NSDataへ変換
    NSData* dData=[NSData dataWithBytes:msg length:diffLength];
    
    //bool flg=true;
    if(!flg){//重複受信防止
        int _host = [[[NSString alloc] initWithData:dData encoding:NSUTF8StringEncoding]intValue];
        //NSLog(@"%dを受信しました",_host);
        if(hostNum > _host){
            flg=true;
            [GameManager setHost:true];
        }else if(hostNum < _host){
            flg=true;
            [GameManager setHost:false];
        }else{
            //もう一度
            //NSLog(@"もう一度");
            flg=false;
            hostNum=arc4random()%1000;
            [self sendDataToAllPlayers];
        }
        
        //ゲーム開始の処理
        if(flg){
            //マッチの保持
            [MatchMakeScene setCurrentMatch:match];
            [[CCDirector sharedDirector] replaceScene:[MatchMakeScene scene]withTransition:
                                                                [CCTransition transitionCrossFadeWithDuration:1.0]];
        }
    }
}

@end
