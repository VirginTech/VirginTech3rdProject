//
//  NaviLayer.h
//  VirginTech3rdProject
//
//  Created by VirginTech LLC. on 2014/12/14.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "cocos2d-ui.h"

@interface NaviLayer : CCScene{
    
}

+ (NaviLayer *)scene;
- (id)init;

-(void)pause;
-(void)resume;

@end
