//
//  LeaderboardView.h
//  GalacticSaga
//
//  Created by OOTANI,Kenji on 2013/02/10.
//
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@interface GKitController : UINavigationController <GKLeaderboardViewControllerDelegate,GKMatchmakerViewControllerDelegate>
{
    //GKitController *viewController;
}

-(void)showLeaderboard;
-(void)showRequestMatch;
-(void)initMatchInviteHandler;

@end
