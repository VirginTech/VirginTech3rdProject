//
//  AdMobLayer_iOS.m
//  VirginTech5stProject
//
//  Created by VirginTech LLC. on 2015/07/27.
//  Copyright 2015年 Apportable. All rights reserved.
//

#import "AdMobLayer_iOS.h"
#import "GameManager.h"

@implementation AdMobLayer_iOS

CGSize winSize;

+ (AdMobLayer_iOS*)scene
{
    return [[self alloc] init];
}

- (id)init
{
    self = [super init];
    if (!self) return(nil);
    
    winSize=[[CCDirector sharedDirector]viewSize];
    
    if([GameManager getDevice]==3)//iPad
    {
        adBannerView=[[GADBannerView alloc]initWithAdSize:kGADAdSizeLeaderboard];
    }else{
        adBannerView=[[GADBannerView alloc]initWithAdSize:kGADAdSizeBanner];
    }

    adBannerView.adUnitID = @"ca-app-pub-6893326232013491/7357178763";
    adBannerView.rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    
    [[[CCDirector sharedDirector]view]addSubview:adBannerView];
    adBannerView.frame = CGRectOffset(adBannerView.frame,
                                  [[UIScreen mainScreen] bounds].size.width/2-adBannerView.frame.size.width/2,
                                  [[UIScreen mainScreen] bounds].size.height);
    adBannerView.delegate=self;
    
    GADRequest* req=[GADRequest request];

#if DEBUG
    NSArray* tester=[NSArray arrayWithObjects:@"65f1a7e40f6f014d4546ca94c0e704e5",
                                            @"5c87fca98711811671926fe16192fc07",
                                            nil];
    req.testDevices=tester;
#endif
    
    [adBannerView loadRequest:req];
    
    adViewIsVisible = NO;
    
    return self;
}

- (void)dealloc
{
    
    [adBannerView removeFromSuperview];
    adBannerView.delegate = nil;
    
}

-(void)removeLayer
{
    [adBannerView removeFromSuperview];
    adBannerView.delegate = nil;
}

//AdMob取得処理
- (void)loadAdmobViewRequest
{

}

//AdMob取得成功
- (void)adViewDidReceiveAd:(GADBannerView *)view
{
    if (!adViewIsVisible) {
        [UIView animateWithDuration:0.3 animations:^{
            adBannerView.frame = CGRectOffset(view.frame, 0, -view.frame.size.height);
        }];
        adViewIsVisible = YES;
    }
}

//AdMob取得失敗
- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error
{
    [adBannerView removeFromSuperview];
    adBannerView.delegate = nil;
}

@end
