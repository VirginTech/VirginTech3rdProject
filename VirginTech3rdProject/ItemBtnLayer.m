//
//  ItemBtnLayer.m
//  VirginTech3rdProject
//
//  Created by VirginTech LLC. on 2014/11/21.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "ItemBtnLayer.h"
#import "GameManager.h"

@implementation ItemBtnLayer

CGSize winSize;
NSMutableArray* btnArray;

+ (ItemBtnLayer *)scene
{
    return [[self alloc] init];
}

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    self.userInteractionEnabled = NO;
    winSize=[[CCDirector sharedDirector]viewSize];
    
    //初期化
    [GameManager setItem:0];//アイテム選択なし
    
    btnArray=[[NSMutableArray alloc]init];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"btn_default.plist"];
    
    for(int i=0;i<5;i++){
        CCButton* btn=[CCButton buttonWithTitle:@""
                                    spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"btn01.png"]
                         highlightedSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"btn02.png"]
                            disabledSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:nil]];
        
        btn.togglesSelectedState=YES;
        btn.scale=0.5;
        btn.position=ccp(winSize.width/2-(btn.contentSize.width*btn.scale)*2+(i*btn.contentSize.width*btn.scale),
                         (btn.contentSize.height*btn.scale)/2);
        [btn setTarget:self selector:@selector(onButtonClicked:)];
        btn.name=[NSString stringWithFormat:@"%d",i];
        [btnArray addObject:btn];
        [self addChild:btn];
    }
    return self;
}

-(void)btnSelectedDisable
{
    [GameManager setItem:0];
    for(CCButton* _btn in btnArray){
        _btn.selected=NO;
    }
}

-(void)onButtonClicked:(id)sender
{
    CCButton* btn=(CCButton*)sender;
    if(btn.selected){
        [GameManager setItem:[btn.name intValue]+1];
    }else{
        [GameManager setItem:0];
    }
    //他の選択を解除
    for(CCButton* _btn in btnArray){
        if([_btn.name intValue]!=[btn.name intValue]){
            _btn.selected=NO;
        }
    }
    
}

@end
