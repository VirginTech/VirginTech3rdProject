//
//  BasicMath.m
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/04/29.
//  Copyright (c) 2014年 VirginTech LLC. All rights reserved.
//

#import "BasicMath.h"

@implementation BasicMath

//========================
// 当たり判定（半径とポイント）
//========================
+(BOOL)RadiusContainsPoint:(CGPoint)pointA pointB:(CGPoint)pointB radius:(float)radius{
    
    BOOL flg=false;
    
    if(sqrtf(powf((pointB.x-pointA.x),2)+powf((pointB.y-pointA.y),2))<=radius){
        flg=true;
    }
    return  flg;
}

//========================
// 当たり判定（半径と半径）
//========================
+(BOOL)RadiusIntersectsRadius:(CGPoint)pointA pointB:(CGPoint)pointB
                                                radius1:(float)radius1 radius2:(float)radius2{
    
    BOOL flg=false;

    if(sqrtf(powf((pointB.x-pointA.x),2)+powf((pointB.y-pointA.y),2))<=radius1+radius2){
        flg=true;
    }
    return  flg;
}

//========================
// 方向(角度)を取得→(ラジアン)
//========================
+(float)getAngle_To_Radian:(CGPoint)sPos ePos:(CGPoint)ePos{
    
    float angle;
    float dx,dy;//差分距離ベクトル
    dx = ePos.x - sPos.x;
    dy = ePos.y - sPos.y;
    //斜辺角度
    angle=atanf(dy/dx);
    
    if(dx<0 && dy>0){//座標左上
        angle=M_PI+angle;
    }else if(dx<0 && dy<=0){//座標左下
        angle=M_PI+angle;
    }else if(dx>=0 && dy<=0){//座標右下
        angle=M_PI*2+angle;
    }else{//座標右上（修正なし）
    }
    return angle;
}
//========================
// ラジアンを正規化
//========================
+(float)getNormalize_Radian:(float)angle
{
    if(angle<0){
        while(angle<0){
            angle += 2*M_PI;
        }
    }else{
        while(angle>2*M_PI){
            angle -= 2*M_PI;
        }
    }
    return angle;
}
//========================
// 方向(角度)を取得→(度で)
//========================
+(float)getAngle_To_Degree:(CGPoint)sPos ePos:(CGPoint)ePos{
    
    float angle;
    float dx,dy;//差分距離ベクトル
    dx = ePos.x - sPos.x;
    dy = ePos.y - sPos.y;
    
    //斜辺角度(度)
    angle=CC_RADIANS_TO_DEGREES(atanf(dy/dx));
    
    if(dx<0 && dy>0){//座標左上
        angle=270-angle;
    }else if(dx<0 && dy<=0){//座標左下
        angle=270-angle;
    }else if(dx>=0 && dy<=0){//座標右下
        angle=450-angle;
    }else{//座標右上
        angle=90-angle;
    }
    //360度を超えていたら360マイナス
    //要！原因解明・・・後で考える・・・
    if(angle>360){
        angle=angle-360;
    }
    return angle;
}
//========================
// 度を正規化
//========================
+(float)getNormalize_Degree:(float)angle
{
    if(angle<0){
        while(angle<0){
            angle += 360;
        }
    }else{
        while(angle>360){
            angle -= 360;
        }
    }
    return angle;
}
//========================
//　　距離を取得
//========================
+(float)getPosDistance:(CGPoint)pos1 pos2:(CGPoint)pos2{
    
    float distance;
    distance=sqrtf(powf(pos1.x - pos2.x,2) + powf(pos1.y - pos2.y,2));
    return distance;
}

@end
