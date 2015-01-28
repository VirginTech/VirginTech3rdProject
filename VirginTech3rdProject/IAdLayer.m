//
//  IAdLayer.m
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/05/13.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "IAdLayer.h"
#import "GameManager.h"

@implementation IAdLayer

CGSize winSize;

+ (IAdLayer*)scene
{
    return [[self alloc] init];
}

- (id)init
{    
    self = [super init];
    if (!self) return(nil);
    
    winSize=[[CCDirector sharedDirector]viewSize];
    
    // iAd設定
    iAdView = [[ADBannerView alloc] initWithFrame:CGRectZero];
    //iAdView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
    [[[CCDirector sharedDirector] view] addSubview:iAdView];
    
    iAdView.frame = CGRectOffset(iAdView.frame, 0, [[UIScreen mainScreen] bounds].size.height);
    iAdView.delegate = self;
    _bannerIsVisible = NO;
    
    return self;
}

- (void)dealloc
{
    [iAdView removeFromSuperview];
    iAdView.delegate = nil;
}

-(void)removeLayer
{
    [iAdView removeFromSuperview];
    iAdView.delegate = nil;
}

-(BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    return YES;
}

//iAd広告取得成功時の処理
- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    if (!_bannerIsVisible)
    {
        [UIView animateWithDuration:0.3 animations:^
        {
            iAdView.frame = CGRectOffset(banner.frame, 0, -banner.frame.size.height);
        }];
        _bannerIsVisible = YES;
    }
    
}

//iAd広告取得失敗時の処理
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    [iAdView removeFromSuperview];
    iAdView = nil;
}

@end
