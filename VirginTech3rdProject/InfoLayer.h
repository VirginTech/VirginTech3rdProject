//
//  InfoLayer.h
//  VirginTech3rdProject
//
//  Created by VirginTech LLC. on 2014/12/15.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "cocos2d-ui.h"

@interface InfoLayer : CCScene
{
    //カウンター
    int pMaxCnt;
    int eMaxCnt;
    int pTotalCnt;
    int eTotalCnt;
    int pCnt;
    int eCnt;
    int repCnt;
    
}

@property int pMaxCnt;
@property int eMaxCnt;
@property int pTotalCnt;
@property int eTotalCnt;
@property int pCnt;
@property int eCnt;
@property int repCnt;

+ (InfoLayer *)scene;
- (id)init;

-(void)stats_Update;

@end
