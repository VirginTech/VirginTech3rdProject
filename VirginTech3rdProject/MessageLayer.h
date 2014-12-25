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

-(void)onMessageLayerBtnClocked:(int)btnNum procNum:(int)procNum;

@end

@interface MessageLayer : CCScene
{
    int procNum;
}

// デリゲート・プロパティ
@property (nonatomic, assign) id<MsgLayerDelegate> delegate;

// デリゲート用メソッド
-(void)sendDelegate:(int)btnNum;

+(MessageLayer *)scene;
-(id)initWithTitle:(NSString*)title //タイトル
                            msg:(NSString*)msg //本文
                            pos:(CGPoint)pos//位置
                            size:(CGSize)size //サイズ
                            modal:(bool)modalFlg
                            rotation:(bool)rotationFlg
                            type:(int)type //0:OKボタン 1:Yes/Noボタン
                            procNum:(int)_procNum; //処理ナンバー

@end
