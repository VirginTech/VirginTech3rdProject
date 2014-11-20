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
    
    if(stageNum%10==1){
        pMaxCnt=100;
    }else if(stageNum%10==2){
        pMaxCnt=100;
    }else if(stageNum%10==3){
        pMaxCnt=120;
    }else if(stageNum%10==4){
        pMaxCnt=100;
    }else if(stageNum%10==5){
        pMaxCnt=120;
    }else if(stageNum%10==6){
        pMaxCnt=100;
    }else if(stageNum%10==7){
        pMaxCnt=120;
    }else if(stageNum%10==8){
        pMaxCnt=100;
    }else if(stageNum%10==9){
        pMaxCnt=140;
    }else if(stageNum%10==0){
        pMaxCnt=100;
    }

    return pMaxCnt;
}
+(int)NumOfRepeat:(int)stageNum
{
    int repeat=0;
    
    if(stageNum%10==1){
        repeat=1;//２回
    }else if(stageNum%10==2){
        repeat=3;//４回
    }else if(stageNum%10==3){
        repeat=2;//３回
    }else if(stageNum%10==4){
        repeat=3;//４回
    }else if(stageNum%10==5){
        repeat=3;//４回
    }else if(stageNum%10==6){
        repeat=4;//５回
    }else if(stageNum%10==7){
        repeat=3;//４回
    }else if(stageNum%10==8){
        repeat=3;//４回
    }else if(stageNum%10==9){
        repeat=2;//３回
    }else if(stageNum%10==0){
        repeat=4;//５回
    }
    
    return repeat;
}

+(int)NumOfInterval:(int)stageNum
{
    int interval=1;
    
    if(stageNum%10==1){
        interval=20;
    }else if(stageNum%10==2){
        interval=10;
    }else if(stageNum%10==3){
        interval=20;
    }else if(stageNum%10==4){
        interval=15;
    }else if(stageNum%10==5){
        interval=20;
    }else if(stageNum%10==6){
        interval=15;
    }else if(stageNum%10==7){
        interval=20;
    }else if(stageNum%10==8){
        interval=10;
    }else if(stageNum%10==9){
        interval=20;
    }else if(stageNum%10==0){
        interval=10;
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
    if(stageNum%10==1){
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
    if(stageNum%10==2){
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
    if(stageNum%10==3){
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
    if(stageNum%10==4){
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
    if(stageNum%10==5){
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
    if(stageNum%10==6){
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
    if(stageNum%10==7){
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
    //==============
    //ステージ０８（２４×４）
    //==============
    if(stageNum%10==8){

        for(int i=0;i<6;i++){
            if([GameManager getDevice]==3){//iPad
                sPoint=ccp(70+(i*50),[GameManager getWorldSize].height*0.8);
            }else{
                sPoint=ccp(40+(i*50),[GameManager getWorldSize].height*0.8);
            }

            pos=ccp(sPoint.x,sPoint.y);
            value=[NSValue valueWithCGPoint:pos];
            [enemyArray addObject:value];
            
            pos=ccp(sPoint.x-10,sPoint.y+15);
            value=[NSValue valueWithCGPoint:pos];
            [enemyArray addObject:value];
            
            pos=ccp(sPoint.x+10,sPoint.y+15);
            value=[NSValue valueWithCGPoint:pos];
            [enemyArray addObject:value];
            
            pos=ccp(sPoint.x,sPoint.y+30);
            value=[NSValue valueWithCGPoint:pos];
            [enemyArray addObject:value];
        }
    }
    //==============
    //ステージ０９（４０×３）
    //==============
    if(stageNum%10==9){
        xOff=0;
        yOff=0;
        if([GameManager getDevice]==3){//iPad
            sPoint=ccp(80,[GameManager getWorldSize].height*0.8);
        }else{
            sPoint=ccp(50,[GameManager getWorldSize].height*0.8);
        }
        for(int i=0;i<20;i++)
        {
            if(i%5==0){
                yOff=yOff+20;
                xOff=-i*3;
            }else{
                xOff=xOff+25;
            }
            pos=ccp(sPoint.x+xOff,sPoint.y+yOff);
            value=[NSValue valueWithCGPoint:pos];
            [enemyArray addObject:value];
        }
        xOff=0;
        yOff=0;
        if([GameManager getDevice]==3){//iPad
            sPoint=ccp([GameManager getWorldSize].width-180,[GameManager getWorldSize].height*0.8);
        }else{
            sPoint=ccp([GameManager getWorldSize].width-150,[GameManager getWorldSize].height*0.8);
        }
        for(int i=0;i<20;i++)
        {
            if(i%5==0){
                yOff=yOff+20;
                xOff=i*3;
            }else{
                xOff=xOff+25;
            }
            pos=ccp(sPoint.x+xOff,sPoint.y+yOff);
            value=[NSValue valueWithCGPoint:pos];
            [enemyArray addObject:value];
        }
    }
    //==============
    //ステージ１０（２０×５）
    //==============
    if(stageNum%10==0){
        for(int i=0;i<2;i++){
            if([GameManager getDevice]==3){//iPad
                sPoint=ccp(100+(i*180),[GameManager getWorldSize].height*0.8);
            }else{
                sPoint=ccp(80+(i*160),[GameManager getWorldSize].height*0.8);
            }
            pos=ccp(sPoint.x,sPoint.y);
            value=[NSValue valueWithCGPoint:pos];
            [enemyArray addObject:value];
            
            //---
            pos=ccp(sPoint.x-15,sPoint.y+20);
            value=[NSValue valueWithCGPoint:pos];
            [enemyArray addObject:value];
            
            pos=ccp(sPoint.x+15,sPoint.y+20);
            value=[NSValue valueWithCGPoint:pos];
            [enemyArray addObject:value];
            
            //---
            pos=ccp(sPoint.x-30,sPoint.y+40);
            value=[NSValue valueWithCGPoint:pos];
            [enemyArray addObject:value];
            
            pos=ccp(sPoint.x,sPoint.y+40);
            value=[NSValue valueWithCGPoint:pos];
            [enemyArray addObject:value];
            
            pos=ccp(sPoint.x+30,sPoint.y+40);
            value=[NSValue valueWithCGPoint:pos];
            [enemyArray addObject:value];
            
            //---
            pos=ccp(sPoint.x-45,sPoint.y+60);
            value=[NSValue valueWithCGPoint:pos];
            [enemyArray addObject:value];
            
            pos=ccp(sPoint.x-15,sPoint.y+60);
            value=[NSValue valueWithCGPoint:pos];
            [enemyArray addObject:value];
            
            pos=ccp(sPoint.x+15,sPoint.y+60);
            value=[NSValue valueWithCGPoint:pos];
            [enemyArray addObject:value];

            pos=ccp(sPoint.x+45,sPoint.y+60);
            value=[NSValue valueWithCGPoint:pos];
            [enemyArray addObject:value];
}
    }
    
    return enemyArray;
}

@end
