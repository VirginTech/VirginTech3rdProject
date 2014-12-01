//
//  mEnemy.m
//  VirginTech3rdProject
//
//  Created by VirginTech LLC. on 2014/11/29.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "mEnemy.h"
#import "BasicMath.h"
#import "GameManager.h"

@implementation mEnemy

-(void)move_Schedule:(CCTime)dt
{
    nextPos=CGPointMake(self.position.x+velocity*cosf(targetAngle),self.position.y+velocity*sinf(targetAngle));
    self.rotation=[BasicMath getAngle_To_Degree:self.position ePos:nextPos];
    self.position=nextPos;
}

-(id)initWithEnemy:(CGPoint)pos
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"object_default.plist"];
    
    if(self=[super initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"enemy.png"]])
    {
        self.position=pos;
        self.scale=0.7;
        velocity=0.2;
        
        if([GameManager getHost]){
            nextPos=ccp(self.position.x,self.position.y-velocity);
        }else{
            nextPos=ccp(self.position.x,self.position.y+velocity);
        }
        
        targetAngle=[BasicMath getAngle_To_Radian:self.position ePos:nextPos];
        
        [self schedule:@selector(move_Schedule:)interval:0.01];
    }
    return self;
}

+(id)createEnemy:(CGPoint)pos
{
    return [[self alloc] initWithEnemy:pos];
}

@end
