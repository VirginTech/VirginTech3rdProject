//
//  BasicMath.h
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/04/29.
//  Copyright (c) 2014年 VirginTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface BasicMath : NSObject

+(BOOL)RadiusContainsPoint:(CGPoint)pointA pointB:(CGPoint)pointB radius:(float)radius;
+(BOOL)RadiusIntersectsRadius:(CGPoint)pointA pointB:(CGPoint)pointB
                                            radius1:(float)radius1 radius2:(float)radius2;
+(float)getAngle_To_Radian:(CGPoint)sPos ePos:(CGPoint)ePos;
+(float)getAngle_To_Degree:(CGPoint)sPos ePos:(CGPoint)ePos;
+(float)getPosDistance:(CGPoint)pos1 pos2:(CGPoint)pos2;

+(float)getNormalize_Radian:(float)angle;
+(float)getNormalize_Degree:(float)angle;

@end
