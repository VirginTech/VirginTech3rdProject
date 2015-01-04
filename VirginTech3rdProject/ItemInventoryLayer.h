//
//  ItemInventoryLayer.h
//  VirginTech3rdProject
//
//  Created by VirginTech LLC. on 2014/12/08.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "MessageLayer.h"

@interface ItemInventoryLayer : CCScene <MsgLayerDelegate>
{
    
}

+ (ItemInventoryLayer *)scene;
- (id)init;

@end
