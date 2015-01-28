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
#import "SoundManager.h"

#import "IAdLayer.h"
#import "IMobileLayer.h"
#import "AdGenerLayer.h"

@implementation ItemInventoryLayer

CGSize winSize;
MessageLayer* msgBox;

CCLabelTTF* lbl_Item_01;
CCLabelTTF* lbl_Item_02;
CCLabelTTF* lbl_Item_03;
CCLabelTTF* lbl_Item_04;
CCLabelTTF* lbl_Item_05;

CCLabelBMFont* coinLabel;

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
    //CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];
    //[self addChild:background];
    
    if([GameManager getLocale]==1){//日本語なら
        //i-Mobile広告(フッター、アイコン)
        IMobileLayer* iMobileAd=[[IMobileLayer alloc]init:false];
        [self addChild:iMobileAd];
    }else{//それ以外
        //iAd広告
        IAdLayer* iAdLayer=[[IAdLayer alloc]init];
        [self addChild:iAdLayer];
    }

    /*/iPadならAdGene広告(iPadフッター)
    if([GameManager getDevice]==3){
        AdGenerLayer* adgene=[[AdGenerLayer alloc]init];
        [self addChild:adgene];
    }*/
    
    //背景
    CCSprite* bg=[CCSprite spriteWithImageNamed:@"itemLayer.png"];
    bg.scale=0.6;
    bg.position=ccp(winSize.width/2,winSize.height/2);
    [self addChild:bg];
    
    //画像読み込み
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"item_default.plist"];
    
    //現在コイン数
    CCSprite* coin=[CCSprite spriteWithSpriteFrame:
                    [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"coin_500.png"]];
    coin.scale=0.3;
    coin.position=ccp((coin.contentSize.width*coin.scale)/2, winSize.height-(coin.contentSize.height*coin.scale)/2);
    [self addChild:coin];
    
    coinLabel=[CCLabelBMFont labelWithString:
                           [NSString stringWithFormat:@"%05d",[GameManager load_Coin]] fntFile:@"scoreFont.fnt"];
    coinLabel.scale=0.3;
    coinLabel.position=ccp(coin.position.x+(coin.contentSize.width*coin.scale)/2+(coinLabel.contentSize.width*coinLabel.scale)/2,coin.position.y);
    [self addChild:coinLabel];
    
    //フレームのスケール取得
    float scale;
    if([GameManager getDevice]==1){//iPhone5,6
        scale=0.6;
    }else if([GameManager getDevice]==2){//iPhone4
        scale=0.55;
    }else if([GameManager getDevice]==3){//iPad
        scale=0.55;
    }else{
        scale=0.6;
    }
    //=================
    // 爆 弾
    //=================
    CCSprite* frame_Item_01=[CCSprite spriteWithSpriteFrame:
                             [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"frame.png"]];
    frame_Item_01.scale=scale;
    frame_Item_01.position=ccp(winSize.width/2-(frame_Item_01.contentSize.width*frame_Item_01.scale)/2,
                               winSize.height/2+frame_Item_01.contentSize.height*frame_Item_01.scale);
    [self addChild:frame_Item_01];
    
    CCSprite* item_01=[CCSprite spriteWithSpriteFrame:
                             [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"item00.png"]];
    item_01.scale=0.7;
    item_01.position=ccp(frame_Item_01.contentSize.width/2,frame_Item_01.contentSize.height/2);
    [frame_Item_01 addChild:item_01];
    
    CCLabelTTF* lbl_Name_01=[CCLabelTTF labelWithString:NSLocalizedString(@"Item01",NULL)
                                                    fontName:@"Verdana-Bold" fontSize:20];
    lbl_Name_01.position=ccp(frame_Item_01.contentSize.width/2,
                             frame_Item_01.contentSize.height-lbl_Name_01.contentSize.height-10);
    [frame_Item_01 addChild:lbl_Name_01];

    CCLabelTTF* lbl_Descript_01=[CCLabelTTF labelWithString:NSLocalizedString(@"descript_01",NULL)
                                                    fontName:@"Verdana-Bold" fontSize:12];
    lbl_Descript_01.position=ccp(frame_Item_01.contentSize.width/2,
                                 frame_Item_01.contentSize.height-lbl_Name_01.contentSize.height-30);
    [frame_Item_01 addChild:lbl_Descript_01];
    
    CCLabelTTF* lbl_Cnt_01=[CCLabelTTF labelWithString:@"×10" fontName:@"Verdana-Bold" fontSize:30];
    lbl_Cnt_01.position=ccp(item_01.contentSize.width,item_01.contentSize.height/2);
    [item_01 addChild:lbl_Cnt_01];
    
    lbl_Item_01=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@: %03d",
                                            NSLocalizedString(@"quantity",NULL),
                                            [GameManager load_Item_Individual:0]] fontName:@"Verdana-Bold" fontSize:15];
    lbl_Item_01.position=ccp(frame_Item_01.contentSize.width/2,frame_Item_01.contentSize.height/2-60);
    [frame_Item_01 addChild:lbl_Item_01];
    
    //CCButton* btn_Item_01=[CCButton buttonWithTitle:@"[購入]" fontName:@"Verdana-Bold" fontSize:15];
    CCButton* btn_Item_01=[CCButton buttonWithTitle:@"   ×10" spriteFrame:
                           [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"itemBtn.png"]];
    btn_Item_01.position=ccp(frame_Item_01.contentSize.width/2,btn_Item_01.contentSize.height/2+20);
    btn_Item_01.name=[NSString stringWithFormat:@"%d",0];
    [btn_Item_01 setTarget:self selector:@selector(onAddItemClicked:)];
    [frame_Item_01 addChild:btn_Item_01];
    
    //=================
    // シールド
    //=================
    CCSprite* frame_Item_02=[CCSprite spriteWithSpriteFrame:
                             [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"frame.png"]];
    frame_Item_02.scale=scale;
    frame_Item_02.position=ccp(frame_Item_01.position.x+frame_Item_02.contentSize.width*frame_Item_02.scale,
                                                                                        frame_Item_01.position.y);
    [self addChild:frame_Item_02];
    
    CCSprite* item_02=[CCSprite spriteWithSpriteFrame:
                       [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"item01.png"]];
    item_02.scale=0.7;
    item_02.position=ccp(frame_Item_02.contentSize.width/2,frame_Item_02.contentSize.height/2);
    [frame_Item_02 addChild:item_02];
    
    CCLabelTTF* lbl_Name_02=[CCLabelTTF labelWithString:NSLocalizedString(@"Item02",NULL)
                                               fontName:@"Verdana-Bold" fontSize:20];
    lbl_Name_02.position=ccp(frame_Item_02.contentSize.width/2,
                             frame_Item_02.contentSize.height-lbl_Name_02.contentSize.height-10);
    [frame_Item_02 addChild:lbl_Name_02];
    
    CCLabelTTF* lbl_Descript_02=[CCLabelTTF labelWithString:NSLocalizedString(@"descript_02",NULL)
                                                   fontName:@"Verdana-Bold" fontSize:12];
    lbl_Descript_02.position=ccp(frame_Item_02.contentSize.width/2,
                                 frame_Item_02.contentSize.height-lbl_Name_02.contentSize.height-30);
    [frame_Item_02 addChild:lbl_Descript_02];
    
    CCLabelTTF* lbl_Cnt_02=[CCLabelTTF labelWithString:@"×10" fontName:@"Verdana-Bold" fontSize:30];
    lbl_Cnt_02.position=ccp(item_02.contentSize.width,item_02.contentSize.height/2);
    [item_02 addChild:lbl_Cnt_02];

    lbl_Item_02=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@: %03d",
                                        NSLocalizedString(@"quantity",NULL),
                                        [GameManager load_Item_Individual:1]] fontName:@"Verdana-Bold" fontSize:15];
    lbl_Item_02.position=ccp(frame_Item_02.contentSize.width/2,frame_Item_02.contentSize.height/2-60);
    [frame_Item_02 addChild:lbl_Item_02];

    //CCButton* btn_Item_02=[CCButton buttonWithTitle:@"[購入]" fontName:@"Verdana-Bold" fontSize:15];
    CCButton* btn_Item_02=[CCButton buttonWithTitle:@"   ×10" spriteFrame:
                           [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"itemBtn.png"]];
    btn_Item_02.position=ccp(frame_Item_02.contentSize.width/2,btn_Item_02.contentSize.height/2+20);
    btn_Item_02.name=[NSString stringWithFormat:@"%d",1];
    [btn_Item_02 setTarget:self selector:@selector(onAddItemClicked:)];
    [frame_Item_02 addChild:btn_Item_02];
    
    //=================
    // 突進モード
    //=================
    CCSprite* frame_Item_03=[CCSprite spriteWithSpriteFrame:
                             [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"frame.png"]];
    frame_Item_03.scale=scale;
    frame_Item_03.position=ccp(frame_Item_01.position.x,
                               frame_Item_01.position.y-frame_Item_03.contentSize.height*frame_Item_03.scale);
    [self addChild:frame_Item_03];
    
    CCSprite* item_03=[CCSprite spriteWithSpriteFrame:
                       [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"item02.png"]];
    item_03.scale=0.7;
    item_03.position=ccp(frame_Item_03.contentSize.width/2,frame_Item_03.contentSize.height/2);
    [frame_Item_03 addChild:item_03];
    
    CCLabelTTF* lbl_Name_03=[CCLabelTTF labelWithString:NSLocalizedString(@"Item03",NULL)
                                               fontName:@"Verdana-Bold" fontSize:20];
    lbl_Name_03.position=ccp(frame_Item_03.contentSize.width/2,
                             frame_Item_03.contentSize.height-lbl_Name_03.contentSize.height-10);
    [frame_Item_03 addChild:lbl_Name_03];
    
    CCLabelTTF* lbl_Descript_03=[CCLabelTTF labelWithString:NSLocalizedString(@"descript_03",NULL)
                                                   fontName:@"Verdana-Bold" fontSize:12];
    lbl_Descript_03.position=ccp(frame_Item_03.contentSize.width/2,
                                 frame_Item_03.contentSize.height-lbl_Name_03.contentSize.height-30);
    [frame_Item_03 addChild:lbl_Descript_03];

    CCLabelTTF* lbl_Cnt_03=[CCLabelTTF labelWithString:@"×10" fontName:@"Verdana-Bold" fontSize:30];
    lbl_Cnt_03.position=ccp(item_03.contentSize.width,item_03.contentSize.height/2);
    [item_03 addChild:lbl_Cnt_03];
    
    lbl_Item_03=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@: %03d",
                                        NSLocalizedString(@"quantity",NULL),
                                        [GameManager load_Item_Individual:2]] fontName:@"Verdana-Bold" fontSize:15];
    lbl_Item_03.position=ccp(frame_Item_03.contentSize.width/2,frame_Item_03.contentSize.height/2-60);
    [frame_Item_03 addChild:lbl_Item_03];

    //CCButton* btn_Item_03=[CCButton buttonWithTitle:@"[購入]" fontName:@"Verdana-Bold" fontSize:15];
    CCButton* btn_Item_03=[CCButton buttonWithTitle:@"   ×10" spriteFrame:
                           [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"itemBtn.png"]];
    btn_Item_03.position=ccp(frame_Item_03.contentSize.width/2,btn_Item_03.contentSize.height/2+20);
    btn_Item_03.name=[NSString stringWithFormat:@"%d",2];
    [btn_Item_03 setTarget:self selector:@selector(onAddItemClicked:)];
    [frame_Item_03 addChild:btn_Item_03];
    
    //=================
    // 攻撃アップ
    //=================
    CCSprite* frame_Item_04=[CCSprite spriteWithSpriteFrame:
                             [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"frame.png"]];
    frame_Item_04.scale=scale;
    frame_Item_04.position=ccp(frame_Item_02.position.x,frame_Item_03.position.y);
    [self addChild:frame_Item_04];
    
    CCSprite* item_04=[CCSprite spriteWithSpriteFrame:
                       [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"item03.png"]];
    item_04.scale=0.7;
    item_04.position=ccp(frame_Item_04.contentSize.width/2,frame_Item_04.contentSize.height/2);
    [frame_Item_04 addChild:item_04];
    
    CCLabelTTF* lbl_Name_04=[CCLabelTTF labelWithString:NSLocalizedString(@"Item04",NULL)
                                               fontName:@"Verdana-Bold" fontSize:20];
    lbl_Name_04.position=ccp(frame_Item_04.contentSize.width/2,
                             frame_Item_04.contentSize.height-lbl_Name_04.contentSize.height-10);
    [frame_Item_04 addChild:lbl_Name_04];
    
    CCLabelTTF* lbl_Descript_04=[CCLabelTTF labelWithString:NSLocalizedString(@"descript_04",NULL)
                                                   fontName:@"Verdana-Bold" fontSize:12];
    lbl_Descript_04.position=ccp(frame_Item_04.contentSize.width/2,
                                 frame_Item_04.contentSize.height-lbl_Name_04.contentSize.height-30);
    [frame_Item_04 addChild:lbl_Descript_04];
    
    CCLabelTTF* lbl_Cnt_04=[CCLabelTTF labelWithString:@"×10" fontName:@"Verdana-Bold" fontSize:30];
    lbl_Cnt_04.position=ccp(item_04.contentSize.width,item_04.contentSize.height/2);
    [item_04 addChild:lbl_Cnt_04];
    
    lbl_Item_04=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@: %03d",
                                        NSLocalizedString(@"quantity",NULL),
                                        [GameManager load_Item_Individual:3]] fontName:@"Verdana-Bold" fontSize:15];
    lbl_Item_04.position=ccp(frame_Item_04.contentSize.width/2,frame_Item_04.contentSize.height/2-60);
    [frame_Item_04 addChild:lbl_Item_04];

    //CCButton* btn_Item_04=[CCButton buttonWithTitle:@"[購入]" fontName:@"Verdana-Bold" fontSize:15];
    
    CCButton* btn_Item_04=[CCButton buttonWithTitle:@"   ×10" spriteFrame:
                           [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"itemBtn.png"]];
    btn_Item_04.position=ccp(frame_Item_04.contentSize.width/2,btn_Item_04.contentSize.height/2+20);
    btn_Item_04.name=[NSString stringWithFormat:@"%d",3];
    [btn_Item_04 setTarget:self selector:@selector(onAddItemClicked:)];
    [frame_Item_04 addChild:btn_Item_04];
    
    //=================
    // 高速モード
    //=================
    CCSprite* frame_Item_05=[CCSprite spriteWithSpriteFrame:
                             [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"frame.png"]];
    frame_Item_05.scale=scale;
    frame_Item_05.position=ccp(frame_Item_03.position.x,
                               frame_Item_04.position.y-frame_Item_05.contentSize.height*frame_Item_05.scale);
    [self addChild:frame_Item_05];
    
    CCSprite* item_05=[CCSprite spriteWithSpriteFrame:
                       [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"item04.png"]];
    item_05.scale=0.7;
    item_05.position=ccp(frame_Item_05.contentSize.width/2,frame_Item_05.contentSize.height/2);
    [frame_Item_05 addChild:item_05];
    
    CCLabelTTF* lbl_Name_05=[CCLabelTTF labelWithString:NSLocalizedString(@"Item05",NULL)
                                               fontName:@"Verdana-Bold" fontSize:20];
    lbl_Name_05.position=ccp(frame_Item_05.contentSize.width/2,
                             frame_Item_05.contentSize.height-lbl_Name_05.contentSize.height-10);
    [frame_Item_05 addChild:lbl_Name_05];
    
    CCLabelTTF* lbl_Descript_05=[CCLabelTTF labelWithString:NSLocalizedString(@"descript_05",NULL)
                                                   fontName:@"Verdana-Bold" fontSize:12];
    lbl_Descript_05.position=ccp(frame_Item_05.contentSize.width/2,
                                 frame_Item_05.contentSize.height-lbl_Name_05.contentSize.height-30);
    [frame_Item_05 addChild:lbl_Descript_05];

    CCLabelTTF* lbl_Cnt_05=[CCLabelTTF labelWithString:@"×10" fontName:@"Verdana-Bold" fontSize:30];
    lbl_Cnt_05.position=ccp(item_05.contentSize.width,item_05.contentSize.height/2);
    [item_05 addChild:lbl_Cnt_05];
    
    lbl_Item_05=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@: %03d",
                                        NSLocalizedString(@"quantity",NULL),
                                        [GameManager load_Item_Individual:4]] fontName:@"Verdana-Bold" fontSize:15];
    lbl_Item_05.position=ccp(frame_Item_05.contentSize.width/2,frame_Item_05.contentSize.height/2-60);
    [frame_Item_05 addChild:lbl_Item_05];

    //CCButton* btn_Item_05=[CCButton buttonWithTitle:@"[購入]" fontName:@"Verdana-Bold" fontSize:15];
    CCButton* btn_Item_05=[CCButton buttonWithTitle:@"   ×10" spriteFrame:
                           [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"itemBtn.png"]];
    btn_Item_05.position=ccp(frame_Item_05.contentSize.width/2,btn_Item_05.contentSize.height/2+20);
    btn_Item_05.name=[NSString stringWithFormat:@"%d",4];
    [btn_Item_05 setTarget:self selector:@selector(onAddItemClicked:)];
    [frame_Item_05 addChild:btn_Item_05];
    
    //=================
    //余り分
    //=================
    CCSprite* frame_Item_06=[CCSprite spriteWithSpriteFrame:
                             [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"frame.png"]];
    frame_Item_06.scale=scale;
    frame_Item_06.position=ccp(frame_Item_04.position.x,frame_Item_05.position.y);
    [self addChild:frame_Item_06];
    
    
    //画像読み込み
    [[CCSpriteFrameCache sharedSpriteFrameCache]removeSpriteFrames];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"btn_default.plist"];
    
    CCButton *titleButton = [CCButton buttonWithTitle:@"" spriteFrame:
                             [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"titleBtn.png"]];
    //titleButton.positionType = CCPositionTypeNormalized;
    titleButton.scale=0.6;
    titleButton.position = ccp(winSize.width-(titleButton.contentSize.width*titleButton.scale)/2,
                               winSize.height-titleButton.contentSize.height/2);
    [titleButton setTarget:self selector:@selector(onBackClicked:)];
    [self addChild:titleButton];
    
    return self;
}

-(void)updata_Item_Value
{
    lbl_Item_01.string=[NSString stringWithFormat:@"%@: %03d",NSLocalizedString(@"quantity",NULL),
                                                                        [GameManager load_Item_Individual:0]];
    lbl_Item_02.string=[NSString stringWithFormat:@"%@: %03d",NSLocalizedString(@"quantity",NULL),
                                                                        [GameManager load_Item_Individual:1]];
    lbl_Item_03.string=[NSString stringWithFormat:@"%@: %03d",NSLocalizedString(@"quantity",NULL),
                                                                        [GameManager load_Item_Individual:2]];
    lbl_Item_04.string=[NSString stringWithFormat:@"%@: %03d",NSLocalizedString(@"quantity",NULL),
                                                                        [GameManager load_Item_Individual:3]];
    lbl_Item_05.string=[NSString stringWithFormat:@"%@: %03d",NSLocalizedString(@"quantity",NULL),
                                                                        [GameManager load_Item_Individual:4]];
}

-(void)updata_Coin_Value
{
    coinLabel.string=[NSString stringWithFormat:@"%05d",[GameManager load_Coin]];
}

- (void)onAddItemClicked:(id)sender
{
    //サウンドエフェクト
    [SoundManager click_Effect];
    
    CCButton* btn=(CCButton*)sender;
    if([GameManager load_Coin]-10>=0)
    {
        int num=[btn.name intValue];
        NSString* itemName;
        if(num==0){
            itemName=NSLocalizedString(@"Item01",NULL);
        }else if(num==1){
            itemName=NSLocalizedString(@"Item02",NULL);
        }else if(num==2){
            itemName=NSLocalizedString(@"Item03",NULL);
        }else if(num==3){
            itemName=NSLocalizedString(@"Item04",NULL);
        }else if(num==4){
            itemName=NSLocalizedString(@"Item05",NULL);
        }
        
        //カスタムアラートメッセージ
        msgBox=[[MessageLayer alloc]initWithTitle:NSLocalizedString(@"GetItem",NULL)
                                                msg:[NSString stringWithFormat:@"%@%@",
                                                     itemName,
                                                     NSLocalizedString(@"ItemPurchase",NULL)]
                                                pos:ccp(winSize.width/2,winSize.height/2)
                                                size:CGSizeMake(200, 100)
                                                modal:true
                                                rotation:false
                                                type:1
                                                procNum:num];//アイテム番号
        msgBox.delegate=self;//デリゲートセット
        [self addChild:msgBox z:1];
    }
    else
    {
        //カスタムアラートメッセージ
        msgBox=[[MessageLayer alloc]initWithTitle:NSLocalizedString(@"NotCoin",NULL)
                                                msg:NSLocalizedString(@"ShopPurchase",NULL)
                                                pos:ccp(winSize.width/2,winSize.height/2)
                                                size:CGSizeMake(200, 100)
                                                modal:true
                                                rotation:false
                                                type:0
                                                procNum:0];//処理なし
        msgBox.delegate=self;//デリゲートセット
        [self addChild:msgBox z:1];
    }
}

//=====================
// デリゲートメソッド
//=====================
-(void)onMessageLayerBtnClocked:(int)btnNum procNum:(int)procNum
{
    //NSLog(@"%d が選択されました",btnNum);
    if(btnNum==2){//Yesだったら
        //int num=[btn.name intValue];
        [GameManager save_Item_Individual:procNum value:[GameManager load_Item_Individual:procNum]+10];
        [self updata_Item_Value];
        //コイン更新
        [GameManager save_Coin:[GameManager load_Coin]-10];
        [self updata_Coin_Value];
    }
    msgBox.delegate=nil;//デリゲート解除
}

- (void)onBackClicked:(id)sender
{
    // back to intro scene with transition
    [SoundManager click_Effect];
    //[[CCDirector sharedDirector] replaceScene:[TitleScene scene]
    //                           withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];
    [[CCDirector sharedDirector] replaceScene:[TitleScene scene] withTransition:
                    [CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:0.3f]];
    //インターステイシャル広告表示
    [ImobileSdkAds showBySpotID:@"359467"];
}

@end
