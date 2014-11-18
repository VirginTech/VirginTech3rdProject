//
//  InitObjManager.h
//  VirginTech3rdProject
//
//  Created by VirginTech LLC. on 2014/11/18.
//  Copyright (c) 2014年 VirginTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface InitObjManager : NSObject
{
    
}

+(int)NumOfRepeat:(int)stageNum;
+(int)NumOfInterval:(int)stageNum;
+(NSMutableArray*)init_Enemy_Pattern:(int)stageNum;

@end
