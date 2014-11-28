//
//  LeaderboardView.m
//  GalacticSaga
//
//  Created by OOTANI,Kenji on 2013/02/10.
//
//

#import "GKitController.h"
#import "MatchMakeScene.h"

@implementation GKitController

GKitController *viewController;

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
    GKMatchmakerViewController *mmvc = [[GKMatchmakerViewController alloc] initWithMatchRequest:request];
    viewController = (GKitController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    mmvc.matchmakerDelegate = self;
    [viewController presentViewController:mmvc animated:YES completion:nil];
}
//ゲーム招待
- (void)showMatchmakerWithInvite:(GKInvite *)invite
{
    GKMatchmakerViewController *mmvc = [[GKMatchmakerViewController alloc] initWithInvite:invite];
    viewController = (GKitController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    mmvc.matchmakerDelegate = self;
    [viewController presentViewController:mmvc animated:YES completion:nil];
}

- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFindMatch:(GKMatch *)match
{
    [viewController dismissViewControllerAnimated:YES completion:nil];

    //match.delegate = self;
    
    //マッチの保持
    [MatchMakeScene setCurrentMatch:match];
    
    // 全ユーザが揃ったかどうか
    if (match.expectedPlayerCount == 0) {
        // ゲーム開始の処理
        [[CCDirector sharedDirector] replaceScene:[MatchMakeScene scene]
                                   withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];
    }
}

-(void)matchmakerViewControllerWasCancelled:(GKMatchmakerViewController*)viewController
{
    [viewController dismissViewControllerAnimated:YES completion:nil]; // ゲームに固有のコードをここに実装する。
}

-(void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFailWithError:(NSError *)error
{
    [viewController dismissViewControllerAnimated:YES completion:nil]; // ゲームに固有のコードをここに実装する。
}


@end
