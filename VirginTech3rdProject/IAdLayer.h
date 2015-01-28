//
//  IAdLayer.h
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/05/13.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <iAd/iAd.h>
#import "cocos2d.h"

@interface IAdLayer : CCScene <ADBannerViewDelegate>
{
    ADBannerView* iAdView;
    bool _bannerIsVisible;
}

+ (IAdLayer *)scene;
- (id)init;

-(void)removeLayer;

@end
