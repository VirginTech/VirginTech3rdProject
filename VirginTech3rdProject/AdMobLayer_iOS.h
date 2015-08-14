//
//  AdMobLayer_iOS.h
//  VirginTech5stProject
//
//  Created by VirginTech LLC. on 2015/07/27.
//  Copyright 2015年 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

//@import GoogleMobileAds;
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface AdMobLayer_iOS : CCScene <GADBannerViewDelegate>
{
    GADBannerView* adBannerView;
    bool adViewIsVisible;
}

+ (AdMobLayer_iOS *)scene;
- (id)init;

-(void)removeLayer;

@end
