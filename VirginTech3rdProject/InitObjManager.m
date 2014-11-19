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

+(int)NumPlayerMax:(int)stageNum
{
    int pMaxCnt=100;
    
    if(stageNum==1){
        pMaxCnt=100;
    }else if(stageNum==2){
        pMaxCnt=100;
    }else if(stageNum==3){
        pMaxCnt=120;
    }else if(stageNum==4){
        pMaxCnt=100;
    }else if(stageNum==5){
        pMaxCnt=120;
    }else if(stageNum==6){
        pMaxCnt=100;
    }else if(stageNum==7){
        pMaxCnt=120;
    }else if(stageNum==8){
        pMaxCnt=100;
    }else if(stageNum==9){
        pMaxCnt=100;
    }else if(stageNum==10){
        pMaxCnt=100;
    }

    return pMaxCnt;
}
+(int)NumOfRepeat:(int)stageNum
{
    int repeat=0;
    
    if(stageNum==1){
        repeat=1;//２回
    }else if(stageNum==2){
        repeat=3;//４回
    }else if(stageNum==3){
        repeat=2;//３回
    }else if(stageNum==4){
        repeat=3;//４回
    }else if(stageNum==5){
        repeat=3;//４回
    }else if(stageNum==6){
        repeat=4;//５回
    }else if(stageNum==7){
        repeat=3;//４回
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
        interval=10;
    }else if(stageNum==3){
        interval=20;
    }else if(stageNum==4){
        interval=15;
    }else if(stageNum==5){
        interval=20;
    }else if(stageNum==6){
        interval=15;
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
    CGPoint sPoint;
    int xOff;
    int yOff;

    //==============
    //ステージ０１（４０×２）
    //==============
    if(stageNum==1){
        xOff=0;
        yOff=0;
        sPoint=ccp(50,[GameManager getWorldSize].height*0.8);
        for(int i=0;i<20;i++)
        {
            if(i%5==0){
                yOff=yOff+20;
                xOff=0;
            }else{
                xOff=xOff+25;
            }
            pos=ccp(sPoint.x+xOff,sPoint.y+yOff);
            value=[NSValue valueWithCGPoint:pos];
            [enemyArray addObject:value];
        }
        xOff=0;
        yOff=0;
        sPoint=ccp([GameManager getWorldSize].width-150,[GameManager getWorldSize].height*0.8);
        for(int i=0;i<20;i++)
        {
            if(i%5==0){
                yOff=yOff+20;
                xOff=0;
            }else{
                xOff=xOff+25;
            }
            pos=ccp(sPoint.x+xOff,sPoint.y+yOff);
            value=[NSValue valueWithCGPoint:pos];
            [enemyArray addObject:value];
        }
    }
    //==============
    //ステージ０２（２０×４）
    //==============
    if(stageNum==2){
        xOff=0;
        yOff=0;
        if([GameManager getDevice]==3){//iPad
            sPoint=ccp(80,[GameManager getWorldSize].height*0.8);
        }else{
            sPoint=ccp(50,[GameManager getWorldSize].height*0.8);
        }
        for(int i=0;i<20;i++)
        {
            if(i%10==0){
                yOff=yOff+20;
                xOff=0;
            }else{
                xOff=xOff+25;
            }
            pos=ccp(sPoint.x+xOff,sPoint.y+yOff);
            value=[NSValue valueWithCGPoint:pos];
            [enemyArray addObject:value];
        }
    }
    
    //==============
    //ステージ０３（３６×３）
    //==============
    if(stageNum==3){
        for(int j=0;j<4;j++){
            xOff=0;
            yOff=0;
            if([GameManager getDevice]==3){//iPad
                sPoint=ccp(50+(j*80),[GameManager getWorldSize].height*0.8);
            }else{
                sPoint=ccp(20+(j*80),[GameManager getWorldSize].height*0.8);
            }
            for(int i=0;i<9;i++)
            {
                if(i%3==0){
                    yOff=yOff+20;
                    xOff=0;
                }else{
                    xOff=xOff+15;
                }
                pos=ccp(sPoint.x+xOff,sPoint.y+yOff);
                value=[NSValue valueWithCGPoint:pos];
                [enemyArray addObject:value];
            }
        }
    }
    //==============
    //ステージ０４（２０×４）
    //==============
    if(stageNum==4){
        for(int j=0;j<2;j++){
            xOff=0;
            yOff=0;
            if([GameManager getDevice]==3){//iPad
                sPoint=ccp(100+(j*170),[GameManager getWorldSize].height*0.8);
            }else{
                sPoint=ccp(80+(j*150),[GameManager getWorldSize].height*0.8);
            }
            for(int i=0;i<10;i++){
                if(i%2==0){
                    yOff=yOff+20;
                    xOff=0;
                }else{
                    xOff=xOff+20;
                }
                pos=ccp(sPoint.x+xOff,sPoint.y+yOff);
                value=[NSValue valueWithCGPoint:pos];
                [enemyArray addObject:value];
            }
        }
    }
    //==============
    //ステージ０５（２５×４）
    //==============
    if(stageNum==5){
        xOff=0;
        yOff=0;
        if([GameManager getDevice]==3){//iPad
            sPoint=ccp(50,[GameManager getWorldSize].height*0.8);
        }else{
            sPoint=ccp(20,[GameManager getWorldSize].height*0.8);
        }
        for(int i=0;i<25;i++){
            if(i%5==0){
                yOff=yOff+20;
                xOff=0;
            }else{
                xOff=xOff+70;
            }
            pos=ccp(sPoint.x+xOff,sPoint.y+yOff);
            value=[NSValue valueWithCGPoint:pos];
            [enemyArray addObject:value];
        }
    }
    //==============
    //ステージ０６（１８×５）
    //==============
    if(stageNum==6){
        for(int i=0;i<2;i++){
            if([GameManager getDevice]==3){//iPad
                sPoint=ccp(100+(i*180),[GameManager getWorldSize].height*0.8);
            }else{
                sPoint=ccp(80+(i*160),[GameManager getWorldSize].height*0.8);
            }
            pos=ccp(sPoint.x,sPoint.y);
            value=[NSValue valueWithCGPoint:pos];
            [enemyArray addObject:value];
            
            pos=ccp(sPoint.x-15,sPoint.y+20);
            value=[NSValue valueWithCGPoint:pos];
            [enemyArray addObject:value];

            pos=ccp(sPoint.x+15,sPoint.y+20);
            value=[NSValue valueWithCGPoint:pos];
            [enemyArray addObject:value];

            pos=ccp(sPoint.x-30,sPoint.y+40);
            value=[NSValue valueWithCGPoint:pos];
            [enemyArray addObject:value];
            
            pos=ccp(sPoint.x,sPoint.y+40);
            value=[NSValue valueWithCGPoint:pos];
            [enemyArray addObject:value];

            pos=ccp(sPoint.x+30,sPoint.y+40);
            value=[NSValue valueWithCGPoint:pos];
            [enemyArray addObject:value];

            pos=ccp(sPoint.x-15,sPoint.y+60);
            value=[NSValue valueWithCGPoint:pos];
            [enemyArray addObject:value];
            
            pos=ccp(sPoint.x+15,sPoint.y+60);
            value=[NSValue valueWithCGPoint:pos];
            [enemyArray addObject:value];

            pos=ccp(sPoint.x,sPoint.y+80);
            value=[NSValue valueWithCGPoint:pos];
            [enemyArray addObject:value];
        }
    }
    //==============
    //ステージ０７（２７×４）
    //==============
    if(stageNum==7){
        for(int i=0;i<3;i++){
            if([GameManager getDevice]==3){//iPad
                sPoint=ccp(100+(i*90),[GameManager getWorldSize].height*0.95);
                if(i==1){
                    sPoint=ccp(100+(i*90),[GameManager getWorldSize].height*0.8);
                }
            }else{
                sPoint=ccp(80+(i*80),[GameManager getWorldSize].height*0.95);
                if(i==1){
                    sPoint=ccp(80+(i*80),[GameManager getWorldSize].height*0.8);
                }
            }
            pos=ccp(sPoint.x,sPoint.y);
            value=[NSValue valueWithCGPoint:pos];
            [enemyArray addObject:value];
            
            pos=ccp(sPoint.x-15,sPoint.y+20);
            value=[NSValue valueWithCGPoint:pos];
            [enemyArray addObject:value];
            
            pos=ccp(sPoint.x+15,sPoint.y+20);
            value=[NSValue valueWithCGPoint:pos];
            [enemyArray addObject:value];
            
            pos=ccp(sPoint.x-30,sPoint.y+40);
            value=[NSValue valueWithCGPoint:pos];
            [enemyArray addObject:value];
            
            pos=ccp(sPoint.x,sPoint.y+40);
            value=[NSValue valueWithCGPoint:pos];
            [enemyArray addObject:value];
            
            pos=ccp(sPoint.x+30,sPoint.y+40);
            value=[NSValue valueWithCGPoint:pos];
            [enemyArray addObject:value];
            
            pos=ccp(sPoint.x-15,sPoint.y+60);
            value=[NSValue valueWithCGPoint:pos];
            [enemyArray addObject:value];
            
            pos=ccp(sPoint.x+15,sPoint.y+60);
            value=[NSValue valueWithCGPoint:pos];
            [enemyArray addObject:value];
            
            pos=ccp(sPoint.x,sPoint.y+80);
            value=[NSValue valueWithCGPoint:pos];
            [enemyArray addObject:value];
        }
    }
    
    return enemyArray;
}

@end
