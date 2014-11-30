//
//  mPlayer.m
//  VirginTech3rdProject
//
//  Created by VirginTech LLC. on 2014/11/29.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "mPlayer.h"
#import "BasicMath.h"

@implementation mPlayer

-(void)move_Schedule:(CCTime)dt
{
    nextPos=CGPointMake(self.position.x+velocity*cosf(targetAngle),self.position.y+velocity*sinf(targetAngle));
    self.rotation=[BasicMath getAngle_To_Degree:self.position ePos:nextPos];
    self.position=nextPos;
}

-(id)initWithPlayer:(CGPoint)pos
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"object_default.plist"];
    
    if(self=[super initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"player.png"]])
    {
        self.position=pos;
        self.scale=0.7;
        velocity=0.2f;
        
        nextPos=ccp(self.position.x,self.position.y+velocity);
        targetAngle=[BasicMath getAngle_To_Radian:self.position ePos:nextPos];
        
        [self schedule:@selector(move_Schedule:)interval:0.01];
    }
    return self;
}

+(id)createPlayer:(CGPoint)pos
{
    return [[self alloc] initWithPlayer:pos];
}

@end
