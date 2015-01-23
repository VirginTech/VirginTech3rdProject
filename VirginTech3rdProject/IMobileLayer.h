//
//  IMobileLayer.h
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/08/22.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ImobileSdkAds/ImobileSdkAds.h"
#import "ImobileSdkAds/ImobileSdkAdsIconParams.h"

@interface IMobileLayer : CCScene <IMobileSdkAdsDelegate>{
    
    UIView *adView;
    UIViewController* viewCon;
}

+ (IMobileLayer *)scene;
- (id)init:(bool)iconFlg;

-(void)removeLayer;

@end
