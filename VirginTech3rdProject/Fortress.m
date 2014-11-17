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

@synthesize ability;

-(void)status_Schedule:(CCTime)dt
{
    //デバッグ用
    energyLabel.string=[NSString stringWithFormat:@"%d",ability];
}

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
        
        ability=1000;
        
        //デバッグ用
        [self schedule:@selector(status_Schedule:)interval:0.1];
        
        energyLabel=[CCLabelTTF labelWithString:
                     [NSString stringWithFormat:@"%d",ability]fontName:@"Verdana-Bold" fontSize:15];
        energyLabel.position=ccp(self.contentSize.width/2,self.contentSize.height/2);
        energyLabel.color=[CCColor whiteColor];
        [self addChild:energyLabel];
        
    }
    return self;
}

+(id)createFortress:(CGPoint)pos type:(int)type
{
    return [[self alloc] initWithFortress:pos type:type];
}

@end
