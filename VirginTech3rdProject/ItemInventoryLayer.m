//
//  ItemInventoryLayer.m
//  VirginTech3rdProject
//
//  Created by VirginTech LLC. on 2014/12/08.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "ItemInventoryLayer.h"
#import "TitleScene.h"
#import "GameManager.h"

@implementation ItemInventoryLayer

CGSize winSize;

CCLabelTTF* lbl_Item_01;
CCLabelTTF* lbl_Item_02;
CCLabelTTF* lbl_Item_03;
CCLabelTTF* lbl_Item_04;
CCLabelTTF* lbl_Item_05;

+ (ItemInventoryLayer *)scene
{
    return [[self alloc] init];
}

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);

    winSize=[[CCDirector sharedDirector]viewSize];
    
    // Create a colored background (Dark Grey)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];
    [self addChild:background];
    
    //=================
    // 爆 弾
    //=================
    lbl_Item_01=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"爆　　弾（現有数＝%03d）",[GameManager load_Item_Individual:0]] fontName:@"Verdana-Bold" fontSize:20];
    lbl_Item_01.position=ccp(lbl_Item_01.contentSize.width/2+20,winSize.height-100);
    [self addChild:lbl_Item_01];
    
    CCButton* btn_Item_01=[CCButton buttonWithTitle:@"[購　入]" fontName:@"Verdana-Bold" fontSize:20];
    btn_Item_01.position=ccp(winSize.width-btn_Item_01.contentSize.width/2-10,lbl_Item_01.position.y);
    btn_Item_01.name=[NSString stringWithFormat:@"%d",0];
    [btn_Item_01 setTarget:self selector:@selector(onAddItemClicked:)];
    [self addChild:btn_Item_01];
    
    //=================
    // シールド
    //=================
    lbl_Item_02=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"シールド（現有数＝%03d）",[GameManager load_Item_Individual:1]] fontName:@"Verdana-Bold" fontSize:20];
    lbl_Item_02.position=ccp(lbl_Item_02.contentSize.width/2+20,lbl_Item_01.position.y-50);
    [self addChild:lbl_Item_02];

    CCButton* btn_Item_02=[CCButton buttonWithTitle:@"[購　入]" fontName:@"Verdana-Bold" fontSize:20];
    btn_Item_02.position=ccp(winSize.width-btn_Item_02.contentSize.width/2-10,lbl_Item_02.position.y);
    btn_Item_02.name=[NSString stringWithFormat:@"%d",1];
    [btn_Item_02 setTarget:self selector:@selector(onAddItemClicked:)];
    [self addChild:btn_Item_02];
    
    //=================
    // 突進モード
    //=================
    lbl_Item_03=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"突進モード（現有数＝%03d）",[GameManager load_Item_Individual:2]] fontName:@"Verdana-Bold" fontSize:20];
    lbl_Item_03.position=ccp(lbl_Item_03.contentSize.width/2+20,lbl_Item_02.position.y-50);
    [self addChild:lbl_Item_03];

    CCButton* btn_Item_03=[CCButton buttonWithTitle:@"[購　入]" fontName:@"Verdana-Bold" fontSize:20];
    btn_Item_03.position=ccp(winSize.width-btn_Item_03.contentSize.width/2-10,lbl_Item_03.position.y);
    btn_Item_03.name=[NSString stringWithFormat:@"%d",2];
    [btn_Item_03 setTarget:self selector:@selector(onAddItemClicked:)];
    [self addChild:btn_Item_03];
    
    //=================
    // 攻撃アップ
    //=================
    lbl_Item_04=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"攻撃力UP（現有数＝%03d）",[GameManager load_Item_Individual:3]] fontName:@"Verdana-Bold" fontSize:20];
    lbl_Item_04.position=ccp(lbl_Item_04.contentSize.width/2+20,lbl_Item_03.position.y-50);
    [self addChild:lbl_Item_04];

    CCButton* btn_Item_04=[CCButton buttonWithTitle:@"[購　入]" fontName:@"Verdana-Bold" fontSize:20];
    btn_Item_04.position=ccp(winSize.width-btn_Item_04.contentSize.width/2-10,lbl_Item_04.position.y);
    btn_Item_04.name=[NSString stringWithFormat:@"%d",3];
    [btn_Item_04 setTarget:self selector:@selector(onAddItemClicked:)];
    [self addChild:btn_Item_04];
    
    //=================
    // 高速モード
    //=================
    lbl_Item_05=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"高速モード（現有数＝%03d）",[GameManager load_Item_Individual:4]] fontName:@"Verdana-Bold" fontSize:20];
    lbl_Item_05.position=ccp(lbl_Item_05.contentSize.width/2+20,lbl_Item_04.position.y-50);
    [self addChild:lbl_Item_05];

    CCButton* btn_Item_05=[CCButton buttonWithTitle:@"[購　入]" fontName:@"Verdana-Bold" fontSize:20];
    btn_Item_05.position=ccp(winSize.width-btn_Item_05.contentSize.width/2-10,lbl_Item_05.position.y);
    btn_Item_05.name=[NSString stringWithFormat:@"%d",4];
    [btn_Item_05 setTarget:self selector:@selector(onAddItemClicked:)];
    [self addChild:btn_Item_05];
    
    
    
    CCButton *backButton = [CCButton buttonWithTitle:@"[タイトル]" fontName:@"Verdana-Bold" fontSize:15.0f];
    backButton.positionType = CCPositionTypeNormalized;
    backButton.position = ccp(0.9f, 0.95f); // Top Right of screen
    [backButton setTarget:self selector:@selector(onBackClicked:)];
    [self addChild:backButton];
    
    return self;
}

-(void)updata_Item_Value
{
    lbl_Item_01.string=[NSString stringWithFormat:@"爆　　弾（現有数＝%03d）",[GameManager load_Item_Individual:0]];
    lbl_Item_02.string=[NSString stringWithFormat:@"シールド（現有数＝%03d）",[GameManager load_Item_Individual:1]];
    lbl_Item_03.string=[NSString stringWithFormat:@"突進モード（現有数＝%03d）",[GameManager load_Item_Individual:2]];
    lbl_Item_04.string=[NSString stringWithFormat:@"攻撃力UP（現有数＝%03d）",[GameManager load_Item_Individual:3]];
    lbl_Item_05.string=[NSString stringWithFormat:@"高速モード（現有数＝%03d）",[GameManager load_Item_Individual:4]];
}

- (void)onAddItemClicked:(id)sender
{
    CCButton* btn=(CCButton*)sender;
    int num=[btn.name intValue];
    [GameManager save_Item_Individual:num value:[GameManager load_Item_Individual:num]+10];
    [self updata_Item_Value];
}

- (void)onBackClicked:(id)sender
{
    // back to intro scene with transition
    [[CCDirector sharedDirector] replaceScene:[TitleScene scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];
    
}

@end
