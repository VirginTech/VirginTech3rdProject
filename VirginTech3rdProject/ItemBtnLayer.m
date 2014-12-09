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
CCLabelTTF* bombValue;
CCLabelTTF* shieldValue;
CCLabelTTF* onrushValue;
CCLabelTTF* attackupValue;
CCLabelTTF* speedupValue;

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
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"item_default.plist"];
    
    for(int i=0;i<5;i++){
        CCButton* btn=[CCButton buttonWithTitle:@""
                                    spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"item01.png"]
                         highlightedSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"item02.png"]
                            disabledSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:nil]];
        
        btn.togglesSelectedState=YES;
        btn.scale=0.5;
        btn.position=ccp(winSize.width/2-(btn.contentSize.width*btn.scale)*2+(i*btn.contentSize.width*btn.scale),
                         (btn.contentSize.height*btn.scale)/2);
        [btn setTarget:self selector:@selector(onButtonClicked:)];
        btn.name=[NSString stringWithFormat:@"%d",i];
        if(i==0){
            btn.title=@"爆　弾";
            bombValue=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",[GameManager load_Item_Individual:0]] fontName:@"Verdana-Bold" fontSize:30];
            bombValue.position=ccp(btn.contentSize.width/2,bombValue.contentSize.height/2);
            [btn addChild:bombValue];
        }else if(i==1){
            btn.title=@"シールド";
            shieldValue=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",[GameManager load_Item_Individual:1]] fontName:@"Verdana-Bold" fontSize:30];
            shieldValue.position=ccp(btn.contentSize.width/2,shieldValue.contentSize.height/2);
            [btn addChild:shieldValue];
        }else if(i==2){
            btn.title=@"突撃モード";
            onrushValue=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",[GameManager load_Item_Individual:2]] fontName:@"Verdana-Bold" fontSize:30];
            onrushValue.position=ccp(btn.contentSize.width/2,onrushValue.contentSize.height/2);
            [btn addChild:onrushValue];
        }else if(i==3){
            btn.title=@"攻撃アップ";
            attackupValue=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",[GameManager load_Item_Individual:3]] fontName:@"Verdana-Bold" fontSize:30];
            attackupValue.position=ccp(btn.contentSize.width/2,attackupValue.contentSize.height/2);
            [btn addChild:attackupValue];
        }else if(i==4){
            btn.title=@"高速モード";
            speedupValue=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",[GameManager load_Item_Individual:4]] fontName:@"Verdana-Bold" fontSize:30];
            speedupValue.position=ccp(btn.contentSize.width/2,speedupValue.contentSize.height/2);
            [btn addChild:speedupValue];
        }
        [btnArray addObject:btn];
        [self addChild:btn];
    }
    return self;
}

-(void)updata_Item_Value
{
    bombValue.string=[NSString stringWithFormat:@"%d",[GameManager load_Item_Individual:0]];
    shieldValue.string=[NSString stringWithFormat:@"%d",[GameManager load_Item_Individual:1]];
    onrushValue.string=[NSString stringWithFormat:@"%d",[GameManager load_Item_Individual:2]];
    attackupValue.string=[NSString stringWithFormat:@"%d",[GameManager load_Item_Individual:3]];
    speedupValue.string=[NSString stringWithFormat:@"%d",[GameManager load_Item_Individual:4]];
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
        if([GameManager load_Item_Individual:[btn.name intValue]]>0){//アイテム在庫があれば
            [GameManager setItem:[btn.name intValue]+1];
        }else{//なければ
            btn.selected=NO;
        }
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
