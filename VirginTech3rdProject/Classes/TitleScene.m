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
#import "PreferencesLayer.h"
#import "CreditLayer.h"
#import "ShopLayer.h"
#import "SoundManager.h"

@implementation TitleScene

CGSize winSize;
MessageLayer* msgBox;

CCLabelBMFont* coinLabel;

+ (TitleScene *)scene
{
	return [[self alloc] init];
}

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    winSize=[[CCDirector sharedDirector]viewSize];
    
    //オープニングBGM
    [SoundManager playBGM:@"opening_bgm01.mp3"];
    
    // Create a colored background (Dark Grey)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];
    [self addChild:background];
    
    //初回起動時ウェルカムメッセージ
    //NSDate* currentDate= [NSDate dateWithTimeIntervalSinceNow:[[NSTimeZone systemTimeZone] secondsFromGMT]];
    NSDate* currentDate=[NSDate date];//GMTで貫く
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] persistentDomainForName:appDomain];
    if([dict valueForKey:@"LoginDate"]==nil){//初回なら
        [GameManager save_login_Date:currentDate];
        
        //カスタムアラートメッセージ
        msgBox=[[MessageLayer alloc]initWithTitle:NSLocalizedString(@"Welcome",NULL)
                                                msg:NSLocalizedString(@"FirstLogin",NULL)
                                                pos:ccp(winSize.width/2,winSize.height/2)
                                                size:CGSizeMake(250, 180)
                                                modal:true
                                                rotation:false
                                                type:0
                                                procNum:1];//初回ログインボーナスメッセージへ
        msgBox.delegate=self;//デリゲートセット
        [self addChild:msgBox z:3];
    }
    
    //日付変更監視スケジュール(デイリーボーナス)
    [self schedule:@selector(status_Schedule:) interval:1.0];
    
    //初回時データ初期化
    [GameManager initialize_Save_Data];
    
    //ゲームキット初期化
    gkc=[[GKitController alloc]init];
    
    //タイトル
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"戦国HERO" fontName:@"Chalkduster" fontSize:36.0f];
    label.positionType = CCPositionTypeNormalized;
    label.color = [CCColor redColor];
    label.position = ccp(0.5f, 0.5f); // Middle of screen
    [self addChild:label];
    
    //画像読み込み
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"btn_default.plist"];
    
    //バージョン表記
    CCLabelTTF* version=[CCLabelTTF labelWithString:@"VirginTech© v1.0.0" fontName:@"Verdana" fontSize:10];
    version.position=ccp(winSize.width/2,winSize.height-version.contentSize.height/2);
    version.color=[CCColor whiteColor];
    [self addChild:version];

    //現在コイン数
    CCSprite* coin=[CCSprite spriteWithSpriteFrame:
                    [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"coin.png"]];
    coin.scale=0.2;
    coin.position=ccp((coin.contentSize.width*coin.scale)/2, winSize.height-(coin.contentSize.height*coin.scale)/2);
    [self addChild:coin];
    
    coinLabel=[CCLabelBMFont labelWithString:
               [NSString stringWithFormat:@"%05d",[GameManager load_Coin]]fntFile:@"scoreFont.fnt"];
    coinLabel.scale=0.3;
    coinLabel.position=ccp(coin.position.x+(coin.contentSize.width*coin.scale)/2+(coinLabel.contentSize.width*coinLabel.scale)/2,coin.position.y);
    [self addChild:coinLabel];
    
    //ハイスコア
    CCLabelBMFont* highScoreBoard=[CCLabelBMFont labelWithString:
            [NSString stringWithFormat:@"HIGHSCORE\n     %07ld",[GameManager load_High_Score]]fntFile:@"scoreFont.fnt"];
    highScoreBoard.scale=0.3;
    highScoreBoard.position=ccp(winSize.width-(highScoreBoard.contentSize.width*highScoreBoard.scale)/2,
                                winSize.height-(highScoreBoard.contentSize.height*highScoreBoard.scale)/2);
    [self addChild:highScoreBoard];
    
    // Helloworld scene button
    CCButton *helloWorldButton = [CCButton buttonWithTitle:@"[シングルモード]" fontName:@"Verdana-Bold" fontSize:18.0f];
    helloWorldButton.positionType = CCPositionTypeNormalized;
    helloWorldButton.position = ccp(0.5f, 0.35f);
    [helloWorldButton setTarget:self selector:@selector(onPlayClicked:)];
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
    
    // GameCenterボタン
    CCButton *gameCenterButton = [CCButton buttonWithTitle:@"" spriteFrame:
                                  [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"gamecenter.png"]];
    gameCenterButton.positionType = CCPositionTypeNormalized;
    gameCenterButton.position = ccp(0.95f, 0.15f);
    gameCenterButton.scale=0.5;
    [gameCenterButton setTarget:self selector:@selector(onGameCenterClicked:)];
    [self addChild:gameCenterButton];
    
    //Twitter
    CCButton *twitterButton = [CCButton buttonWithTitle:@"" spriteFrame:
                               [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"twitter.png"]];
    twitterButton.positionType = CCPositionTypeNormalized;
    twitterButton.position = ccp(0.95f, 0.22f);
    twitterButton.scale=0.5;
    [twitterButton setTarget:self selector:@selector(onTwitterClicked:)];
    [self addChild:twitterButton];
    
    //Facebook
    CCButton *facebookButton = [CCButton buttonWithTitle:@"" spriteFrame:
                                [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"facebook.png"]];
    facebookButton.positionType = CCPositionTypeNormalized;
    facebookButton.position = ccp(0.95f, 0.29f);
    facebookButton.scale=0.5;
    [facebookButton setTarget:self selector:@selector(onFacebookClicked:)];
    [self addChild:facebookButton];

    //In-AppPurchaseボタン
    CCButton *inAppButton = [CCButton buttonWithTitle:@"" spriteFrame:
                             [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"shopBtn.png"]];
    inAppButton.positionType = CCPositionTypeNormalized;
    inAppButton.position = ccp(0.05f, 0.15f);
    inAppButton.scale=0.5;
    [inAppButton setTarget:self selector:@selector(onInAppPurchaseClicked:)];
    [self addChild:inAppButton];
    
    //環境設定
    CCButton *preferencesButton = [CCButton buttonWithTitle:@"" spriteFrame:
                                   [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"configBtn.png"]];
    preferencesButton.positionType = CCPositionTypeNormalized;
    preferencesButton.position = ccp(0.05f, 0.22f);
    preferencesButton.scale=0.5;
    [preferencesButton setTarget:self selector:@selector(onPreferencesButtonClicked:)];
    [self addChild:preferencesButton];
    
    //クレジット
    CCButton *creditButton = [CCButton buttonWithTitle:@"" spriteFrame:
                              [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"creditBtn.png"]];
    creditButton.positionType = CCPositionTypeNormalized;
    creditButton.position = ccp(0.05f, 0.29f);
    creditButton.scale=0.5;
    [creditButton setTarget:self selector:@selector(onCreditButtonClicked:)];
    [self addChild:creditButton];
    
    // done
	return self;
}

- (void)dealloc
{
    // clean up code goes here
}

-(void)onEnter
{
    [super onEnter];
}

- (void)onExit
{
    // always call super onExit last
    [super onExit];
}

//===================
// 状態監視スケジュール
//===================
-(void)status_Schedule:(CCTime)dt
{
    //デイリー・ボーナス
    NSDate* recentDate=[GameManager load_Login_Date];
    NSDate* currentDate=[NSDate date];//GMTで貫く
    //日付のみに変換
    NSCalendar *calen = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents *comps = [calen components:unitFlags fromDate:currentDate];
    //[comps setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];//GMTで貫く
    currentDate = [calen dateFromComponents:comps];
    
    if([currentDate compare:recentDate]==NSOrderedDescending){//日付が変わってるなら「1」
        [GameManager save_login_Date:currentDate];
        
        //カスタムアラートメッセージ
        msgBox=[[MessageLayer alloc]initWithTitle:NSLocalizedString(@"BonusGet",NULL)
                                                msg:NSLocalizedString(@"DailyBonus",NULL)
                                                pos:ccp(winSize.width/2,winSize.height/2)
                                                size:CGSizeMake(200, 100)
                                                modal:true
                                                rotation:false
                                                type:0
                                                procNum:3];//デイリーボーナス付与
        msgBox.delegate=self;//デリゲートセット
        [self addChild:msgBox z:3];
    }
}

//=====================
// デリゲートメソッド
//=====================
-(void)onMessageLayerBtnClocked:(int)btnNum procNum:(int)procNum
{
    if(procNum==0)
    {
        msgBox.delegate=nil;//デリゲート解除
    }
    else if(procNum==1)//初回ボーナスメッセージ
    {
        //カスタムアラートメッセージ
        msgBox=[[MessageLayer alloc]initWithTitle:NSLocalizedString(@"BonusGet",NULL)
                                                msg:NSLocalizedString(@"FirstBonus",NULL)
                                                pos:ccp(winSize.width/2,winSize.height/2)
                                                size:CGSizeMake(200, 100)
                                                modal:true
                                                rotation:false
                                                type:0
                                                procNum:2];//初回ログインボーナス付与
        msgBox.delegate=self;//デリゲートセット
        [self addChild:msgBox z:3];
    }
    else if(procNum==2)//初回ボーナス付与
    {
        [GameManager save_Coin:[GameManager load_Coin]+100];
        coinLabel.string=[NSString stringWithFormat:@"%05d",[GameManager load_Coin]];
        msgBox.delegate=nil;//デリゲート解除
    }
    else if(procNum==3)//デイリーボーナス付与
    {
        [GameManager save_Coin:[GameManager load_Coin]+10];
        coinLabel.string=[NSString stringWithFormat:@"%05d",[GameManager load_Coin]];
        msgBox.delegate=nil;//デリゲート解除
    }

}


- (void)onItemInventoryClicked:(id)sender
{
    [SoundManager click_Effect];
    //[[CCDirector sharedDirector] replaceScene:[ItemInventoryLayer scene]
    //                           withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];
    [[CCDirector sharedDirector] replaceScene:[ItemInventoryLayer scene] withTransition:
                                [CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:0.3f]];

}

- (void)onMatchMakeClicked:(id)sender
{
    [SoundManager click_Effect];
    //[SoundManager stopBGM];
    
    //ネット接続できるか確認
    Reachability *internetReach = [Reachability reachabilityForInternetConnection];
    //[internetReach startNotifier];
    NetworkStatus netStatus = [internetReach currentReachabilityStatus];
    if(netStatus == NotReachable)
    {
        /*/ネットワーク接続なし
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error",NULL)
                                                        message:NSLocalizedString(@"NotNetwork",NULL)
                                                        delegate:nil
                                                        cancelButtonTitle:nil
                                                        otherButtonTitles:NSLocalizedString(@"Ok",NULL), nil];
        [alert show];*/
        
        //カスタムアラートメッセージ
        msgBox=[[MessageLayer alloc]initWithTitle:NSLocalizedString(@"Error",NULL)
                                                msg:NSLocalizedString(@"NotNetwork",NULL)
                                                pos:ccp(winSize.width/2,winSize.height/2)
                                                size:CGSizeMake(200, 100)
                                                modal:true
                                                rotation:false
                                                type:0
                                                procNum:0];//処理なし
        msgBox.delegate=self;//デリゲートセット
        [self addChild:msgBox z:3];
        
        return;
    }else{
        //ネットワークOK!
        [gkc showRequestMatch];//マッチ画面表示
    }
}

- (void)onRealBattleClicked:(id)sender
{
    [SoundManager click_Effect];
    [SoundManager stopBGM];
    // start spinning scene with transition
    [GameManager setMatchMode:1];
    [[CCDirector sharedDirector] replaceScene:[RealBattleScene scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:0.5]];
    
}

- (void)onPlayClicked:(id)sender
{
    [SoundManager click_Effect];
    // start spinning scene with transition
    [GameManager setMatchMode:0];
    [[CCDirector sharedDirector] replaceScene:[SelectScene scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:0.5]];

}

-(void)onGameCenterClicked:(id)sender
{
    [SoundManager click_Effect];
    gkc=[[GKitController alloc]init];
    [gkc showLeaderboard];
}

-(void)onTwitterClicked:(id)sender
{
    [SoundManager click_Effect];
    NSURL* url = [NSURL URLWithString:@"https://twitter.com/VirginTechLLC"];
    [[UIApplication sharedApplication]openURL:url];
}

-(void)onFacebookClicked:(id)sender
{
    [SoundManager click_Effect];
    NSURL* url = [NSURL URLWithString:@"https://www.facebook.com/pages/VirginTech-LLC/516907375075432"];
    [[UIApplication sharedApplication]openURL:url];
}

-(void)onInAppPurchaseClicked:(id)sender
{
    [SoundManager click_Effect];
    //アプリ内購入の設定チェック
    if (![SKPaymentQueue canMakePayments]){//ダメ
        /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error",NULL)
                                                        message:NSLocalizedString(@"InAppBillingIslimited",NULL)
                                                        delegate:nil
                                                        cancelButtonTitle:nil
                                                        otherButtonTitles:NSLocalizedString(@"Ok",NULL), nil];
        [alert show];*/
        
        //カスタムアラートメッセージ
        msgBox=[[MessageLayer alloc]initWithTitle:NSLocalizedString(@"Error",NULL)
                                                msg:NSLocalizedString(@"InAppBillingIslimited",NULL)
                                                pos:ccp(winSize.width/2,winSize.height/2)
                                                size:CGSizeMake(200, 100)
                                                modal:true
                                                rotation:false
                                                type:0
                                                procNum:0];//処理なし
        msgBox.delegate=self;//デリゲートセット
        [self addChild:msgBox z:3];

        return;
        
    }else{//OK!
        
        //ネット接続できるか確認
        Reachability *internetReach = [Reachability reachabilityForInternetConnection];
        //[internetReach startNotifier];
        NetworkStatus netStatus = [internetReach currentReachabilityStatus];
        if(netStatus == NotReachable)//ダメ
        {
            /*/ネットワーク接続なし
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error",NULL)
                                                            message:NSLocalizedString(@"NotNetwork",NULL)
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:NSLocalizedString(@"Ok",NULL), nil];
            [alert show];*/
            
            //カスタムアラートメッセージ
            msgBox=[[MessageLayer alloc]initWithTitle:NSLocalizedString(@"Error",NULL)
                                                    msg:NSLocalizedString(@"NotNetwork",NULL)
                                                    pos:ccp(winSize.width/2,winSize.height/2)
                                                    size:CGSizeMake(200, 100)
                                                    modal:true
                                                    rotation:false
                                                    type:0
                                                    procNum:0];//処理なし
            msgBox.delegate=self;//デリゲートセット
            [self addChild:msgBox z:3];

            return;
            
        }else{//ネットワークOK!
            
            //ショップ画面へ
            [[CCDirector sharedDirector] replaceScene:[ShopLayer scene]
                                       withTransition:[CCTransition transitionCrossFadeWithDuration:0.5]];
        }
    }
}

-(void)onPreferencesButtonClicked:(id)sender
{
    [SoundManager click_Effect];
    //[[CCDirector sharedDirector] replaceScene:[PreferencesLayer scene]withTransition:
    //                                              [CCTransition transitionCrossFadeWithDuration:1.0]];
    [[CCDirector sharedDirector] replaceScene:[PreferencesLayer scene] withTransition:
                        [CCTransition transitionRevealWithDirection:CCTransitionDirectionRight duration:0.3f]];

}

-(void)onCreditButtonClicked:(id)sender
{
    [SoundManager click_Effect];
    [[CCDirector sharedDirector] replaceScene:[CreditLayer scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:0.5]];
}

@end
