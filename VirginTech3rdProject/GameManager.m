//
//  GameManager.m
//  VirginTech3rdProject
//
//  Created by VirginTech LLC. on 2014/11/11.
//  Copyright (c) 2014年 VirginTech LLC. All rights reserved.
//

#import "GameManager.h"

@implementation GameManager

CGSize worldSize;//ワールドサイズ

//ワールドサイズ
+(void)setWorldSize:(CGSize)size{
    worldSize=size;
}
+(CGSize)getWorldSize{
    return worldSize;
}


@end
