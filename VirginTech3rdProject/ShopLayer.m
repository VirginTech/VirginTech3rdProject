//
//  ShopLayer.m
//  VirginTech3rdProject
//
//  Created by VirginTech LLC. on 2014/12/09.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "ShopLayer.h"
#import "TitleScene.h"
#import "GameManager.h"

@implementation ShopLayer

CGSize winSize;
SKProductsRequest *productsRequest;
PaymentManager* paymane;

SKProduct* product01;
SKProduct* product02;
SKProduct* product03;
SKProduct* product04;
SKProduct* product05;

CCLabelTTF* coinLabel;

+ (ShopLayer *)scene
{
    return [[self alloc] init];
}

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    winSize=[[CCDirector sharedDirector]viewSize];
    
    // Create a colored background (Dark Grey)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];
    [self addChild:background];
    
    CCButton *titleButton = [CCButton buttonWithTitle:@"[タイトル]" fontName:@"Verdana-Bold" fontSize:15.0f];
    titleButton.positionType = CCPositionTypeNormalized;
    titleButton.position = ccp(0.9f, 0.95f); // Top Right of screen
    [titleButton setTarget:self selector:@selector(onTitleClicked:)];
    [self addChild:titleButton];
    
    //初期化
    paymane = [[PaymentManager alloc]init];
    
    //画像読み込み
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"btn_default.plist"];
    
    //現在コイン数
    CCSprite* coin=[CCSprite spriteWithSpriteFrame:
                      [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"coin.png"]];
    coin.scale=0.2;
    coin.position=ccp((coin.contentSize.width*coin.scale)/2, winSize.height-(coin.contentSize.height*coin.scale)/2);
    [self addChild:coin];
    
    coinLabel=[CCLabelTTF labelWithString:
                    [NSString stringWithFormat:@"%05d",[GameManager load_Coin]] fontName:@"Verdana-Bold" fontSize:18];
    coinLabel.position=ccp(coin.position.x+(coin.contentSize.width*coin.scale)/2+coinLabel.contentSize.width/2,coin.position.y);
    [self addChild:coinLabel];
    
    //インジケータ
    if([indicator isAnimating]==false)
    {
        indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [[[CCDirector sharedDirector] view] addSubview:indicator];
        if([GameManager getDevice]==3){
            indicator.center = ccp(winSize.width, winSize.height);
        }else{
            indicator.center = ccp(winSize.width/2, winSize.height/2);
        }
        [indicator startAnimating];
    }
    
    //アイテム情報の取得
    [self getItemInfo];
    
    return self;
}

-(void)getItemInfo
{
    NSSet *set = [NSSet setWithObjects:@"VirginTech3rdProject_Coin_100",
                  @"VirginTech3rdProject_Coin_200",
                  @"VirginTech3rdProject_Coin_300",
                  @"VirginTech3rdProject_Coin_500",
                  @"VirginTech3rdProject_Coin_1000",
                  nil];
    productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
    productsRequest.delegate = self;
    [productsRequest start];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    // 無効なアイテムがないかチェック
    if ([response.invalidProductIdentifiers count] > 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error",NULL)
                                                        message:NSLocalizedString(@"ItemIdIsInvalid",NULL)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"Ok",NULL)
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    //アイテム情報の取得
    product01=[response.products objectAtIndex:0];// 100Pack
    product02=[response.products objectAtIndex:2];// 200Pack
    product03=[response.products objectAtIndex:3];// 300Pack
    product04=[response.products objectAtIndex:4];// 500Pack
    product05=[response.products objectAtIndex:1];// 1000Pack
    
    //コインパック
    CCSprite* coin01=[CCSprite spriteWithSpriteFrame:
                     [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"coin.png"]];
    coin01.position=ccp(40, winSize.height -130);
    coin01.scale=0.2;
    [self addChild:coin01];
    
    CCSprite* coin02=[CCSprite spriteWithSpriteFrame:
                     [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"coin.png"]];
    coin02.position=ccp(coin01.position.x, coin01.position.y -40);
    coin02.scale=0.2;
    [self addChild:coin02];
    
    CCSprite* coin03=[CCSprite spriteWithSpriteFrame:
                     [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"coin.png"]];
    coin03.position=ccp(coin01.position.x, coin01.position.y -80);
    coin03.scale=0.2;
    [self addChild:coin03];
    
    CCSprite* coin04=[CCSprite spriteWithSpriteFrame:
                     [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"coin.png"]];
    coin04.position=ccp(coin01.position.x, coin01.position.y -120);
    coin04.scale=0.2;
    [self addChild:coin04];
    
    CCSprite* coin05=[CCSprite spriteWithSpriteFrame:
                     [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"coin.png"]];
    coin05.position=ccp(coin01.position.x, coin01.position.y -160);
    coin05.scale=0.2;
    [self addChild:coin05];
    
    //ラベル
    CCLabelTTF* label01=[CCLabelTTF labelWithString:product01.localizedTitle fontName:@"Verdana-Bold" fontSize:18.0f];
    label01.position = ccp(coin01.position.x+110, coin01.position.y);
    [self addChild:label01];
    
    CCLabelTTF* label02=[CCLabelTTF labelWithString:product02.localizedTitle fontName:@"Verdana-Bold" fontSize:18.0f];
    label02.position = ccp(coin02.position.x+110, coin02.position.y);
    [self addChild:label02];
    
    CCLabelTTF* label03=[CCLabelTTF labelWithString:product03.localizedTitle fontName:@"Verdana-Bold" fontSize:18.0f];
    label03.position = ccp(coin03.position.x+110, coin03.position.y);
    [self addChild:label03];
    
    CCLabelTTF* label04=[CCLabelTTF labelWithString:product04.localizedTitle fontName:@"Verdana-Bold" fontSize:18.0f];
    label04.position = ccp(coin04.position.x+110, coin04.position.y);
    [self addChild:label04];
    
    CCLabelTTF* label05=[CCLabelTTF labelWithString:product05.localizedTitle fontName:@"Verdana-Bold" fontSize:18.0f];
    label05.position = ccp(coin05.position.x+110, coin05.position.y);
    [self addChild:label05];
    
    //購入ボタン
    CCButton* button01=[CCButton buttonWithTitle:@"" spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"buyBtn.png"]];
    button01.position = ccp(label01.position.x+130, coin01.position.y);
    [button01 setTarget:self selector:@selector(button01_Clicked:)];
    button01.scale=0.6;
    [self addChild:button01];
    CCLabelTTF* labelBtn01=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@%@",[product01.priceLocale objectForKey:NSLocaleCurrencySymbol],product01.price] fontName:@"Verdana-Italic" fontSize:18.0f];
    labelBtn01.position=ccp(button01.contentSize.width/2,button01.contentSize.height/2);
    labelBtn01.color=[CCColor whiteColor];
    [button01 addChild:labelBtn01];
    
    CCButton* button02=[CCButton buttonWithTitle:@"" spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"buyBtn.png"]];
    button02.position = ccp(label02.position.x+130, coin02.position.y);
    [button02 setTarget:self selector:@selector(button02_Clicked:)];
    button02.scale=0.6;
    [self addChild:button02];
    CCLabelTTF* labelBtn02=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@%@",[product02.priceLocale objectForKey:NSLocaleCurrencySymbol],product02.price] fontName:@"Verdana-Italic" fontSize:18.0f];
    labelBtn02.position=ccp(button02.contentSize.width/2,button02.contentSize.height/2);
    labelBtn02.color=[CCColor whiteColor];
    [button02 addChild:labelBtn02];
    
    CCButton* button03=[CCButton buttonWithTitle:@"" spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"buyBtn.png"]];
    button03.position = ccp(label03.position.x+130, coin03.position.y);
    [button03 setTarget:self selector:@selector(button03_Clicked:)];
    button03.scale=0.6;
    [self addChild:button03];
    CCLabelTTF* labelBtn03=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@%@",[product03.priceLocale objectForKey:NSLocaleCurrencySymbol],product03.price] fontName:@"Verdana-Italic" fontSize:18.0f];
    labelBtn03.position=ccp(button03.contentSize.width/2,button03.contentSize.height/2);
    labelBtn03.color=[CCColor whiteColor];
    [button03 addChild:labelBtn03];
    
    CCButton* button04=[CCButton buttonWithTitle:@"" spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"buyBtn.png"]];
    button04.position = ccp(label04.position.x+130, coin04.position.y);
    [button04 setTarget:self selector:@selector(button04_Clicked:)];
    button04.scale=0.6;
    [self addChild:button04];
    CCLabelTTF* labelBtn04=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@%@",[product04.priceLocale objectForKey:NSLocaleCurrencySymbol],product04.price] fontName:@"Verdana-Italic" fontSize:18.0f];
    labelBtn04.position=ccp(button04.contentSize.width/2,button04.contentSize.height/2);
    labelBtn04.color=[CCColor whiteColor];
    [button04 addChild:labelBtn04];
    
    CCButton* button05=[CCButton buttonWithTitle:@"" spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"buyBtn.png"]];
    button05.position = ccp(label05.position.x+130, coin05.position.y);
    [button05 setTarget:self selector:@selector(button05_Clicked:)];
    button05.scale=0.6;
    [self addChild:button05];
    CCLabelTTF* labelBtn05=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@%@",[product05.priceLocale objectForKey:NSLocaleCurrencySymbol],product05.price] fontName:@"Verdana-Italic" fontSize:18.0f];
    labelBtn05.position=ccp(button05.contentSize.width/2,button05.contentSize.height/2);
    labelBtn05.color=[CCColor whiteColor];
    [button05 addChild:labelBtn05];
    
    // インジケータを非表示にする
    if([indicator isAnimating])
    {
        [indicator stopAnimating];
        [indicator removeFromSuperview];
    }
}

- (void)button01_Clicked:(id)sender
{
    [paymane buyProduct:product01];
}
- (void)button02_Clicked:(id)sender
{
    [paymane buyProduct:product02];
}
- (void)button03_Clicked:(id)sender
{
    [paymane buyProduct:product03];
}
- (void)button04_Clicked:(id)sender
{
    [paymane buyProduct:product04];
}
- (void)button05_Clicked:(id)sender
{
    [paymane buyProduct:product05];
}

+(void)coin_Update
{
    coinLabel.string=[NSString stringWithFormat:@"%05d",[GameManager load_Coin]];
}

- (void)onTitleClicked:(id)sender
{
    //プロダクトリクエストをキャンセル
    [productsRequest cancel];
    // インジケータを非表示にする
    if([indicator isAnimating]){
        [indicator stopAnimating];
        [indicator removeFromSuperview];
    }
    [[CCDirector sharedDirector] replaceScene:[TitleScene scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];
    
}

@end
