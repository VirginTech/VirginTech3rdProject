//
//  mEnemy.m
//  VirginTech3rdProject
//
//  Created by VirginTech LLC. on 2014/11/29.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "mEnemy.h"


@implementation mEnemy

-(id)initWithEnemy:(CGPoint)pos
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"object_default.plist"];
    
    if(self=[super initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"enemy.png"]])
    {
        self.position=pos;
        self.scale=0.7;
        
        
    }
    return self;
}

+(id)createEnemy:(CGPoint)pos
{
    return [[self alloc] initWithEnemy:pos];
}

@end
