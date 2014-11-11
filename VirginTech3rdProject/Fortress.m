//
//  Fortress.m
//  VirginTech3rdProject
//
//  Created by VirginTech LLC. on 2014/11/11.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "Fortress.h"
#import "GameManager.h"

@implementation Fortress

-(id)initWithFortress:(CGPoint)pos type:(int)type
{
    NSString* fileName;
    if(type==0){//我
        fileName=@"fortress_01.png";//青
    }else{//敵
        fileName=@"fortress_00.png";//赤
    }

    if(self=[super initWithImageNamed:fileName])
    {
        self.position=pos;
    }
    return self;
}

+(id)createFortress:(CGPoint)pos type:(int)type
{
    return [[self alloc] initWithFortress:pos type:type];
}

@end
