//
//  IntroScene.m
//  VirginTech3rdProject
//
//  Created by VirginTech LLC. on 2014/10/19.
//  Copyright VirginTech LLC. 2014年. All rights reserved.
//
// -----------------------------------------------------------------------

// Import the interfaces
#import "TitleScene.h"
#import "GameManager.h"
#import "SelectScene.h"
#import "RealBattleScene.h"
#import "Reachability.h"
#import "ItemInventoryLayer.h"

@implementation TitleScene

+ (TitleScene *)scene
{
	return [[self alloc] init];
}

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    // Create a colored background (Dark Grey)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];
    [self addChild:background];
    
    //データ初期化
    [GameManager initialize_Item];
    
    //ゲームキット初期化
    gkc=[[GKitController alloc]init];
    
    // Hello world
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"3rd Project" fontName:@"Chalkduster" fontSize:36.0f];
    label.positionType = CCPositionTypeNormalized;
    label.color = [CCColor redColor];
    label.position = ccp(0.5f, 0.5f); // Middle of screen
    [self addChild:label];
    
    // Helloworld scene button
    CCButton *helloWorldButton = [CCButton buttonWithTitle:@"[シングルモード]" fontName:@"Verdana-Bold" fontSize:18.0f];
    helloWorldButton.positionType = CCPositionTypeNormalized;
    helloWorldButton.position = ccp(0.5f, 0.35f);
    [helloWorldButton setTarget:self selector:@selector(onSpinningClicked:)];
    [self addChild:helloWorldButton];

    CCButton *realBattleButton = [CCButton buttonWithTitle:@"[リアル対戦モード]" fontName:@"Verdana-Bold" fontSize:18.0f];
    realBattleButton.positionType = CCPositionTypeNormalized;
    realBattleButton.position = ccp(0.5f, 0.30f);
    [realBattleButton setTarget:self selector:@selector(onRealBattleClicked:)];
    [self addChild:realBattleButton];

    CCButton *matchMakeButton = [CCButton buttonWithTitle:@"[オンライン対戦モード]" fontName:@"Verdana-Bold" fontSize:18.0f];
    matchMakeButton.positionType = CCPositionTypeNormalized;
    matchMakeButton.position = ccp(0.5f, 0.25f);
    [matchMakeButton setTarget:self selector:@selector(onMatchMakeClicked:)];
    [self addChild:matchMakeButton];
    
    CCButton *itemInventoryButton = [CCButton buttonWithTitle:@"[アイテム倉庫]" fontName:@"Verdana-Bold" fontSize:18.0f];
    itemInventoryButton.positionType = CCPositionTypeNormalized;
    itemInventoryButton.position = ccp(0.5f, 0.20f);
    [itemInventoryButton setTarget:self selector:@selector(onItemInventoryClicked:)];
    [self addChild:itemInventoryButton];
    
    

    // done
	return self;
}

- (void)onItemInventoryClicked:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[ItemInventoryLayer scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];
}

- (void)onMatchMakeClicked:(id)sender
{
    //ネット接続できるか確認
    Reachability *internetReach = [Reachability reachabilityForInternetConnection];
    //[internetReach startNotifier];
    NetworkStatus netStatus = [internetReach currentReachabilityStatus];
    if(netStatus == NotReachable)
    {
        //ネットワーク接続なし
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ネットワークエラー"
                                                        message:@"ネットワーク接続がありません"
                                                        delegate:nil
                                                        cancelButtonTitle:nil
                                                        otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }else{
        //ネットワークOK!
        [gkc showRequestMatch];
    }
}

- (void)onRealBattleClicked:(id)sender
{
    // start spinning scene with transition
    [[CCDirector sharedDirector] replaceScene:[RealBattleScene scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];
    
}

- (void)onSpinningClicked:(id)sender
{
    // start spinning scene with transition
    [[CCDirector sharedDirector] replaceScene:[SelectScene scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];

}

@end
