//
//  MatchWaitLayer.h
//  VirginTech3rdProject
//
//  Created by VirginTech LLC. on 2014/12/09.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "MessageLayer.h"

@interface MatchWaitLayer : CCScene <MsgLayerDelegate>
{
    bool playerReadyFlg;
    bool enemyReadyFlg;
    
    MessageLayer* pMsgBox;
    MessageLayer* eMsgBox;

    CCLabelBMFont* playerLbl;
    CCLabelBMFont* enemyLbl;
}
@property CCLabelBMFont* playerLbl;
@property CCLabelBMFont* enemyLbl;
@property bool playerReadyFlg;
@property bool enemyReadyFlg;

+ (MatchWaitLayer *)scene;
- (id)init;

-(void)readyWaitStart;

@end
