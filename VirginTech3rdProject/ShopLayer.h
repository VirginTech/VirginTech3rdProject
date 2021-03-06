//
//  ShopLayer.h
//  VirginTech3rdProject
//
//  Created by VirginTech LLC. on 2014/12/09.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "cocos2d-ui.h"
#import <StoreKit/StoreKit.h>
#import "PaymentManager.h"

@interface ShopLayer : CCScene <SKProductsRequestDelegate>
{
    UIActivityIndicatorView* indicator;
}

+ (ShopLayer *)scene;
- (id)init;

+(void)coin_Update;

@end
