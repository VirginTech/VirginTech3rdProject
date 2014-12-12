//
//  IntroScene.h
//  VirginTech3rdProject
//
//  Created by VirginTech LLC. on 2014/10/19.
//  Copyright VirginTech LLC. 2014年. All rights reserved.
//
// -----------------------------------------------------------------------

// Importing cocos2d.h and cocos2d-ui.h, will import anything you need to start using cocos2d-v3
#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "GKitController.h"
#import <StoreKit/StoreKit.h>
#import "MessageLayer.h"
// -----------------------------------------------------------------------

/**
 *  The intro scene
 *  Note, that scenes should now be based on CCScene, and not CCLayer, as previous versions
 *  Main usage for CCLayer now, is to make colored backgrounds (rectangles)
 *
 */
@interface TitleScene : CCScene <MsgLayerDelegate>
{
    GKitController* gkc;
}
// -----------------------------------------------------------------------

+ (TitleScene *)scene;
- (id)init;

// -----------------------------------------------------------------------
@end