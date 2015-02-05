//
//  NoticeScene.h
//  VirginTech3rdProject
//
//  Created by VirginTech LLC. on 2015/02/04.
//  Copyright 2015年 VirginTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "MessageLayer.h"

@interface NoticeScene : CCScene <UIWebViewDelegate,MsgLayerDelegate> {
    
}

+ (NoticeScene *)scene;
- (id)init;

@end
