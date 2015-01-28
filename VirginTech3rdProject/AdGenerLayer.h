//
//  AdGenerLayer.h
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/08/31.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ADGManagerViewController.h"

@interface AdGenerLayer : CCScene <ADGManagerViewControllerDelegate>
{
    ADGManagerViewController *adg_;
    bool adViewFlg;
}

//@property (nonatomic, retain) ADGManagerViewController *adg;

+ (AdGenerLayer *)scene;
- (id)init;

-(void)removeLayer;

@end
