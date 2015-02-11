//
//  NoticeScene.m
//  VirginTech3rdProject
//
//  Created by VirginTech LLC. on 2015/02/04.
//  Copyright 2015年 VirginTech LLC. All rights reserved.
//

#import "NoticeScene.h"
#import "TitleScene.h"
#import "GameManager.h"
#import "SoundManager.h"

@implementation NoticeScene

CGSize winSize;
UIWebView *webview;
UIActivityIndicatorView* indicator;

int giftVolume;

MessageLayer* msgBox;

+ (NoticeScene *)scene
{
    return [[self alloc] init];
}

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    winSize=[[CCDirector sharedDirector]viewSize];
    
    //タイトル画面
    CCSprite* title=[CCSprite spriteWithImageNamed:@"title.png"];
    title.positionType = CCPositionTypeNormalized;
    title.position=ccp(0.5f,0.6f);
    title.scale=0.8;
    [self addChild:title];
    
    //WebViewの生成
    if([GameManager getDevice]==3){//iPad
        webview = [[UIWebView alloc] initWithFrame:CGRectMake(winSize.width*2*0.1,winSize.height*2*0.1,
                                                            winSize.width*2*0.8, winSize.height*2*0.8)];
    }else{
        webview = [[UIWebView alloc] initWithFrame:CGRectMake(winSize.width*0.1,winSize.height*0.1,
                                                            winSize.width*0.8, winSize.height*0.8)];
    }
    //delegateの使い方はお好みで
    webview.delegate = self;
    //参照先URLの設定
    NSURL *url = [NSURL URLWithString:@"http://www.virgintech.co.jp/notice/notice_home.html"];
    //お決まりの構文
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //読み込み開始
    [webview loadRequest:request];
    //ここもお好みで(画面サイズにページを合わせるか)
    webview.scalesPageToFit = YES;
    //cocos2dの上に乗っける
    [[[CCDirector sharedDirector] view] addSubview:webview];
    
    //画像読み込み
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"btn_default.plist"];
    
    CCButton *titleButton;
    if([GameManager getLocale]==1){
        titleButton = [CCButton buttonWithTitle:@"" spriteFrame:
                       [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"titleBtn.png"]];
    }else{
        titleButton = [CCButton buttonWithTitle:@"" spriteFrame:
                       [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"titleBtn_en.png"]];
    }
    //titleButton.positionType = CCPositionTypeNormalized;
    titleButton.scale=0.6;
    titleButton.position = ccp(winSize.width-(titleButton.contentSize.width*titleButton.scale)/2,
                               winSize.height-titleButton.contentSize.height/2);
    [titleButton setTarget:self selector:@selector(onTitleClicked:)];
    [self addChild:titleButton];
    
    return self;
}

- (void) dealloc
{
    // インジケータを非表示にする
    if([indicator isAnimating])
    {
        [indicator stopAnimating];
        [indicator removeFromSuperview];
    }
    //Webビュー削除
    webview.delegate=nil;
    [webview removeFromSuperview];
}

// ページ読込開始時にインジケータ表示
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    //インジケーター
    if([indicator isAnimating]==false)
    {
        indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        indicator.color=[UIColor blackColor];
        [[[CCDirector sharedDirector] view] addSubview:indicator];
        if([GameManager getDevice]==3){
            indicator.center = ccp(winSize.width, winSize.height);
        }else{
            indicator.center = ccp(winSize.width/2, winSize.height/2);
        }
        [indicator startAnimating];
    }
}

// ページ読込完了時にインジケータ非表示
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // インジケータを非表示にする
    if([indicator isAnimating])
    {
        [indicator stopAnimating];
        [indicator removeFromSuperview];
    }
}

//画面推移時に呼ばれるデリゲートメソッド
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
                                                navigationType:(UIWebViewNavigationType)navigationType
{    
    //キャッシュを全て消去
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    //「jp.co.virgintech.VirginTech3rdProject」スキーマ以外は通常にページ遷移をさせる
    NSString* scheme = [[request URL] scheme];
    if (![scheme isEqualToString:@"jp.co.virgintech.virgintech3rdproject"]) {
        return YES;
    }
    
    //=========================
    // 特典コード認証 準備
    //=========================
    
    //クエリ文字列をパースする
    NSString* query = [[request URL] query];
    NSArray *array = [query componentsSeparatedByString:@"="];
    
    //Webビューから送信された情報を受信する
    NSString* giftKey=[array objectAtIndex:0];
    int inputId=[[array objectAtIndex:1]intValue];
    int giftId=[[array objectAtIndex:2]intValue];
    giftVolume=[[array objectAtIndex:3]intValue];
    
    //認証処理
    [self gift_certification:inputId giftKey:giftKey giftId:giftId];
    
    return NO;
}

//=========================
// 特典コード認証 処理
//=========================
-(void)gift_certification:(int)inputId giftKey:(NSString*)giftKey giftId:(int)giftId
{
    if(inputId==giftId){//有効なIDなら
        /*/カスタムアラートメッセージ
        msgBox=[[MessageLayer alloc]initWithTitle:NSLocalizedString(@"Gift",NULL)
                                                msg:NSLocalizedString(@"Gift_Get",NULL)
                                                pos:ccp(winSize.width/2,winSize.height/2)
                                                size:CGSizeMake(250, 180)
                                                modal:true
                                                rotation:false
                                                type:0
                                                procNum:1];//特典付与
        msgBox.delegate=self;//デリゲートセット
        [self addChild:msgBox z:1];*/
        
        NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] persistentDomainForName:appDomain];
        
        if([dict valueForKey:giftKey]==nil)//まだ貰ってなければ
        {
            //ギフトを保存
            [GameManager save_Gift_Acquired:giftKey flg:true];
            
            NSString* msg=[NSString stringWithFormat:@"%@%d%@",
                           NSLocalizedString(@"Gift_Koban",NULL),giftVolume,NSLocalizedString(@"Gift_Get",NULL)];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Gift",NULL)
                                                                message:msg
                                                                delegate:self
                                                                cancelButtonTitle:nil
                                                                otherButtonTitles:NSLocalizedString(@"Ok",NULL), nil];
            alert.tag=1;//特典付与
            [alert show];
        }
        else//もうすでに貰っていれば
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Gift",NULL)
                                                                message:NSLocalizedString(@"Gift_Not",NULL)
                                                                delegate:nil
                                                                cancelButtonTitle:nil
                                                                otherButtonTitles:NSLocalizedString(@"Ok",NULL), nil];
            alert.tag=0;//何もなし
            [alert show];
        }
    }else{
        /*/カスタムアラートメッセージ
        msgBox=[[MessageLayer alloc]initWithTitle:NSLocalizedString(@"Gift",NULL)
                                                msg:NSLocalizedString(@"Gift_Error",NULL)
                                                pos:ccp(winSize.width/2,winSize.height/2)
                                                size:CGSizeMake(250, 180)
                                                modal:true
                                                rotation:false
                                                type:0
                                                procNum:0];//何もなし
        msgBox.delegate=self;//デリゲートセット
        [self addChild:msgBox z:1];*/
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Gift",NULL)
                                                            message:NSLocalizedString(@"Gift_Error",NULL)
                                                            delegate:nil
                                                            cancelButtonTitle:nil
                                                            otherButtonTitles:NSLocalizedString(@"Ok",NULL), nil];
        alert.tag=0;//何もなし
        [alert show];
    }
}

//==============================
// アラートメッセージ デリゲートメソッド
//==============================
-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==0){
        //何もなし
    }else{
        //特典付与
        [GameManager save_Coin:[GameManager load_Coin]+giftVolume];
    }
}

//============================
// カスタムアラート デリゲートメソッド
//============================
-(void)onMessageLayerBtnClocked:(int)btnNum procNum:(int)procNum
{
    if(procNum==1){//特典付与
        [GameManager save_Coin:[GameManager load_Coin]+giftVolume];
    }else{
        //何もなし
    }
    msgBox.delegate=nil;
}

- (void)onTitleClicked:(id)sender
{
    // back to intro scene with transition
    [SoundManager click_Effect];
    [[CCDirector sharedDirector] replaceScene:[TitleScene scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];
    //インターステイシャル広告表示
    //[ImobileSdkAds showBySpotID:@"359467"];
}

@end
