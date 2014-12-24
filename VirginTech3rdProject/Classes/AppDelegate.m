//
//  AppDelegate.m
//  VirginTech3rdProject
//
//  Created by VirginTech LLC. on 2014/10/19.
//  Copyright VirginTech LLC. 2014年. All rights reserved.
//
// -----------------------------------------------------------------------

#import "AppDelegate.h"
#import "TitleScene.h"
#import "GameManager.h"
#import "GKitController.h"

@implementation AppDelegate

// 
-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// This is the only app delegate method you need to implement when inheriting from CCAppDelegate.
	// This method is a good place to add one time setup code that only runs when your app is first launched.
	
	// Setup Cocos2D with reasonable defaults for everything.
	// There are a number of simple options you can change.
	// If you want more flexibility, you can configure Cocos2D yourself instead of calling setupCocos2dWithOptions:.
	[self setupCocos2dWithOptions:@{
		// Show the FPS and draw call label.
		CCSetupShowDebugStats: @(NO),
		
		// More examples of options you might want to fiddle with:
		// (See CCAppDelegate.h for more information)
		
		// Use a 16 bit color buffer: 
//		CCSetupPixelFormat: kEAGLColorFormatRGB565,
		// Use a simplified coordinate system that is shared across devices.
//		CCSetupScreenMode: CCScreenModeFixed,
		// Run in portrait mode.
		CCSetupScreenOrientation: CCScreenOrientationPortrait,
		// Run at a reduced framerate.
//		CCSetupAnimationInterval: @(1.0/30.0),
		// Run the fixed timestep extra fast.
//		CCSetupFixedUpdateInterval: @(1.0/180.0),
		// Make iPad's act like they run at a 2x content scale. (iPad retina 4x)
		CCSetupTabletScale2X: @(YES),
	}];
	
    //OSバージョン登録
    [GameManager setOsVersion:[[[UIDevice currentDevice]systemVersion]floatValue]];
    
    //GameCenterへ認証
    GKLocalPlayer* localPlayer = [GKLocalPlayer localPlayer];
    if ([GameManager getOsVersion]>=6.0f)
    {
        GKitController *gkc = (GKitController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        localPlayer.authenticateHandler = ^(UIViewController* viewController, NSError* error)
        {
            if(viewController!=nil){
                [gkc presentViewController:viewController animated:YES completion:nil];
            }
            if(error==nil) {
                // ゲーム招待を処理するためのハンドラを設定する
                [gkc initMatchInviteHandler];
            }
        };
    }else
    {
        localPlayer.authenticateHandler = ^(UIViewController* viewController, NSError* error){};
    }

    
	return YES;
}

-(CCScene *)startScene
{
    //デバイス登録
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if(screenBounds.size.height==568 || screenBounds.size.width==568){ //iPhone5,6 (568,320px)
        [GameManager setDevice:1];
    }else if(screenBounds.size.height==480 || screenBounds.size.width==480){ //iPhone4 (480,320px)
        [GameManager setDevice:2];
    }else if(screenBounds.size.height==1024 || screenBounds.size.width==1024){ //iPad2 (1024,768px)
        [GameManager setDevice:3];
    }else{
        [GameManager setDevice:0];
    }

	// This method should return the very first scene to be run when your app starts.
	return [TitleScene scene];
}

@end
