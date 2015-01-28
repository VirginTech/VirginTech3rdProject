//
//  AdGenerLayer.m
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/08/31.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "AdGenerLayer.h"
#import "GameManager.h"

@implementation AdGenerLayer

CGSize winSize;

+ (AdGenerLayer*)scene
{
    return [[self alloc] init];
}

- (id)init
{
    self = [super init];
    if (!self) return(nil);
    
    winSize=[[CCDirector sharedDirector]viewSize];
    
    NSDictionary *adgparam;
    
    if([GameManager getDevice]==3){//iPad
        adgparam = @{
                     @"locationid" : @"16036", //管理画面から払い出された広告枠ID(16036)
                     @"adtype" : @(kADG_AdType_Tablet), //管理画面にて入力した枠サイズ(kADG_AdType_Sp：320x50, kADG_AdType_Large:320x100, kADG_AdType_Rect:300x250, kADG_AdType_Tablet:728x90, kADG_AdType_Free
                     @"originx" : @(20), //広告枠設置起点のx座標
                     @"originy" : @(winSize.height*2), //広告枠設置起点のy座標
                     @"w" : @(0), //広告枠横幅
                     @"h" : @(0)  //広告枠高さ
                };
    }else{
        adgparam = @{
                     @"locationid" : @"16037", //管理画面から払い出された広告枠ID(16037)
                     @"adtype" : @(kADG_AdType_Sp), //管理画面にて入力した枠サイズ(kADG_AdType_Sp：320x50, kADG_AdType_Large:320x100, kADG_AdType_Rect:300x250, kADG_AdType_Tablet:728x90, kADG_AdType_Free
                     @"originx" : @(0), //広告枠設置起点のx座標
                     @"originy" : @(winSize.height-50), //広告枠設置起点のy座標
                     @"w" : @(0), //広告枠横幅
                     @"h" : @(0)  //広告枠高さ
                };
    }
    
    adg_ =[[ADGManagerViewController alloc]initWithAdParams:adgparam adView:[[CCDirector sharedDirector]view]];
    
    adViewFlg=false;
    adg_.delegate = self;
    [adg_ loadRequest];
    
    return self;
}

-(void)removeLayer
{
    adg_.delegate = nil;
    [adg_.view removeFromSuperview];
    adg_ = nil;
}

- (void) dealloc
{
    adg_.delegate = nil;
    [adg_.view removeFromSuperview];
    adg_ = nil;
}

- (void)ADGManagerViewControllerReceiveAd:(ADGManagerViewController *)adgManagerViewController
{
    if(!adViewFlg)
    {
        [UIView animateWithDuration:0.3 animations:^
        {
            adg_.view.frame=CGRectOffset(adg_.view.frame, 0,-adg_.view.frame.size.height);
        }];
        adViewFlg=true;
    }
}

@end
