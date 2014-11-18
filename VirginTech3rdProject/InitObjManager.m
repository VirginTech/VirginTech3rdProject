//
//  InitObjManager.m
//  VirginTech3rdProject
//
//  Created by VirginTech LLC. on 2014/11/18.
//  Copyright (c) 2014年 VirginTech LLC. All rights reserved.
//

#import "InitObjManager.h"
#import "GameManager.h"

@implementation InitObjManager

+(int)NumOfRepeat:(int)stageNum
{
    int repeat=0;
    
    if(stageNum==1){
        repeat=1;
    }else if(stageNum==2){
        repeat=1;
    }else if(stageNum==3){
        repeat=1;
    }else if(stageNum==4){
        repeat=1;
    }else if(stageNum==5){
        repeat=1;
    }else if(stageNum==6){
        repeat=1;
    }else if(stageNum==7){
        repeat=1;
    }else if(stageNum==8){
        repeat=1;
    }else if(stageNum==9){
        repeat=1;
    }else if(stageNum==10){
        repeat=1;
    }
    
    return repeat;
}

+(int)NumOfInterval:(int)stageNum
{
    int interval=1;
    
    if(stageNum==1){
        interval=20;
    }else if(stageNum==2){
        interval=20;
    }else if(stageNum==3){
        interval=20;
    }else if(stageNum==4){
        interval=20;
    }else if(stageNum==5){
        interval=20;
    }else if(stageNum==6){
        interval=20;
    }else if(stageNum==7){
        interval=20;
    }else if(stageNum==8){
        interval=20;
    }else if(stageNum==9){
        interval=20;
    }else if(stageNum==10){
        interval=20;
    }
    
    return interval;
}

+(NSMutableArray*)init_Enemy_Pattern:(int)stageNum
{
    NSMutableArray* enemyArray=[[NSMutableArray alloc]init];
    CGPoint pos;
    NSValue* value;
    int xOff;
    int yOff;

    //==============
    //ステージ０１（４０）
    //==============
    if(stageNum==1){
        xOff=0;
        yOff=0;
        for(int i=0;i<20;i++)
        {
            if(i%5==0){
                yOff=yOff+20;
                xOff=0;
            }else{
                xOff=xOff+25;
            }
            pos=ccp(50+xOff,[GameManager getWorldSize].height*0.8+yOff);
            value=[NSValue valueWithCGPoint:pos];
            [enemyArray addObject:value];
        }
        xOff=0;
        yOff=0;
        for(int i=0;i<20;i++)
        {
            if(i%5==0){
                yOff=yOff+20;
                xOff=0;
            }else{
                xOff=xOff+25;
            }
            pos=ccp([GameManager getWorldSize].width-150+xOff,[GameManager getWorldSize].height*0.8+yOff);
            value=[NSValue valueWithCGPoint:pos];
            [enemyArray addObject:value];
        }
    }
    //==============
    //ステージ０１（４０）
    //==============
    if(stageNum==2){
        
        
        
    }
    
    
    
    
    
    return enemyArray;
}

@end
