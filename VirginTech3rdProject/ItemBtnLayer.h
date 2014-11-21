//
//  ItemBtnLayer.h
//  VirginTech3rdProject
//
//  Created by VirginTech LLC. on 2014/11/21.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "cocos2d-ui.h"

@interface ItemBtnLayer : CCScene {
    
}

+ (ItemBtnLayer *)scene;
- (id)init;

-(void)btnSelectedDisable;

@end
