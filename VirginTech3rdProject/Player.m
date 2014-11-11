//
//  Player.m
//  VirginTech3rdProject
//
//  Created by VirginTech LLC. on 2014/11/11.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "Player.h"
#import "GameManager.h"
#import "BasicMath.h"

@implementation Player

@synthesize targetPos;

-(void)move_Schedule:(CCTime)dt
{
    targetAngle=[BasicMath getAngle_To_Radian:self.position ePos:targetPos];
    targetDistance = sqrtf(powf(self.position.x - targetPos.x,2) + powf(self.position.y - targetPos.y,2));
    nextPos=CGPointMake(velocity*cosf(targetAngle),velocity*sinf(targetAngle));
    
    self.position=CGPointMake(self.position.x+nextPos.x, self.position.y+nextPos.y);
    self.rotation=[BasicMath getAngle_To_Degree:self.position ePos:targetPos];
    
    if(targetDistance < 5.0){
        [self unschedule:@selector(move_Schedule:)];
    }
}

-(id)initWithPlayer:(CGPoint)pos
{
    if(self=[super initWithImageNamed:@"player.png"])
    {
        self.position=pos;
        self.scale=0.5;
        
        velocity=0.2;
        targetPos=ccp(self.position.x,[GameManager getWorldSize].height);
        
        [self schedule:@selector(move_Schedule:)interval:0.01];
    }
    return self;
}

+(id)createPlayer:(CGPoint)pos
{
    return [[self alloc] initWithPlayer:pos];
}

@end
