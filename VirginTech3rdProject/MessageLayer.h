//
//  MessageLayer.h
//  VirginTech3rdProject
//
//  Created by VirginTech LLC. on 2014/12/12.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "cocos2d-ui.h"

// デリゲートを定義
@protocol MsgLayerDelegate <NSObject>

-(void)onMessageLayerBtnClocked:(int)btnNum;

@end

@interface MessageLayer : CCScene {
    
}

// デリゲート・プロパティ
@property (nonatomic, assign) id<MsgLayerDelegate> delegate;

// デリゲート用メソッド
-(void)sendDelegate:(int)btnNum;

+(MessageLayer *)scene;
-(id)init:(CGSize)size type:(int)type title:(NSString*)title msg:(NSString*)msg;

@end
