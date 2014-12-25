//
//  MessageLayer.m
//  VirginTech3rdProject
//
//  Created by VirginTech LLC. on 2014/12/12.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "MessageLayer.h"


@implementation MessageLayer

@synthesize delegate;

CGSize winSize;

+ (MessageLayer *)scene
{
    return [[self alloc] init];
}

-(id)initWithTitle:(NSString*)title
                                msg:(NSString*)msg
                                pos:(CGPoint)pos
                                size:(CGSize)size
                                modal:(bool)modalFlg
                                rotation:(bool)rotationFlg
                                type:(int)type
                                procNum:(int)_procNum
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    if(modalFlg){
        self.userInteractionEnabled = YES;
    }else{
        self.userInteractionEnabled = NO;
    }
    
    winSize=[[CCDirector sharedDirector]viewSize];
    
    procNum=_procNum;
    
    //画像の読込み
    [[CCSpriteFrameCache sharedSpriteFrameCache]removeSpriteFrames];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"message_default.plist"];
    
    //メッセージボックス
    CCSprite* msgBoard=[CCSprite spriteWithSpriteFrame:
                        [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"msgBoard.png"]];
    msgBoard.position=pos;
    msgBoard.scaleX=size.width/msgBoard.contentSize.width;
    msgBoard.scaleY=size.height/msgBoard.contentSize.height;
    [self addChild:msgBoard];
    
    //ボタン
    CCButton* yesBtn=[CCButton buttonWithTitle:NSLocalizedString(@"Yes",NULL)
                                spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"yesBtn.png"]];
    CCButton* noBtn=[CCButton buttonWithTitle:NSLocalizedString(@"No",NULL)
                                spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"noBtn.png"]];
    CCButton* okBtn=[CCButton buttonWithTitle:NSLocalizedString(@"Ok",NULL)
                                  spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"yesBtn.png"]];
    
    yesBtn.scale=0.5;
    noBtn.scale=0.5;
    okBtn.scale=0.5;

    [yesBtn setTarget:self selector:@selector(yesButtonClicked:)];
    [noBtn setTarget:self selector:@selector(noButtonClicked:)];
    [okBtn setTarget:self selector:@selector(okButtonClicked:)];
    
    if(rotationFlg){//反転表示
        //[OK]ボタン
        if(type==0){
            okBtn.position=ccp(winSize.width-msgBoard.position.x, msgBoard.position.y+(msgBoard.contentSize.height*msgBoard.scaleY)/2-(okBtn.contentSize.height*okBtn.scale)/2-5);
            okBtn.rotation=180;
            [self addChild:okBtn];
        }
        //[Yes/No]ボタン
        else if(type==1){
            yesBtn.position=ccp(winSize.width-msgBoard.position.x-(yesBtn.contentSize.width*yesBtn.scale)/2-5, msgBoard.position.y+(msgBoard.contentSize.height*msgBoard.scaleY)/2-(yesBtn.contentSize.height*yesBtn.scale)/2-5);
            yesBtn.rotation=180;
            [self addChild:yesBtn];
            noBtn.position=ccp(winSize.width-msgBoard.position.x+(noBtn.contentSize.width*noBtn.scale)/2+5, msgBoard.position.y+(msgBoard.contentSize.height*msgBoard.scaleY)/2-(noBtn.contentSize.height*noBtn.scale)/2-5);
            noBtn.rotation=180;
            [self addChild:noBtn];
        //
        }else{
            
        }
        
        //タイトル
        CCLabelTTF* lbl_title=[CCLabelTTF labelWithString:title fontName:@"Verdana-Bold" fontSize:15];
        lbl_title.position=ccp(winSize.width-msgBoard.position.x,msgBoard.position.y-msgBoard.contentSize.height*msgBoard.scaleY/2+lbl_title.contentSize.height/2+10);
        lbl_title.rotation=180;
        [self addChild:lbl_title];
        
        //メッセージ本文
        CCLabelTTF* lbl_msg=[CCLabelTTF labelWithString:msg fontName:@"Verdana-Bold" fontSize:10];
        lbl_msg.position=ccp(winSize.width-msgBoard.position.x,msgBoard.position.y-msgBoard.contentSize.height*msgBoard.scaleY/2+lbl_msg.contentSize.height/2+40);
        lbl_msg.rotation=180;
        [self addChild:lbl_msg];
    
    }else{
        
        //[OK]ボタン
        if(type==0){
            okBtn.position=ccp(winSize.width-msgBoard.position.x, msgBoard.position.y-(msgBoard.contentSize.height*msgBoard.scaleY)/2+(okBtn.contentSize.height*okBtn.scale)/2+5);
            [self addChild:okBtn];
        }
        //[Yes/No]ボタン
        else if(type==1){
            yesBtn.position=ccp(winSize.width-msgBoard.position.x+(yesBtn.contentSize.width*yesBtn.scale)/2+5, msgBoard.position.y-(msgBoard.contentSize.height*msgBoard.scaleY)/2+(yesBtn.contentSize.height*yesBtn.scale)/2+5);
            [self addChild:yesBtn];
            noBtn.position=ccp(winSize.width-msgBoard.position.x-(noBtn.contentSize.width*noBtn.scale)/2-5, msgBoard.position.y-(msgBoard.contentSize.height*msgBoard.scaleY)/2+(noBtn.contentSize.height*noBtn.scale)/2+5);
            [self addChild:noBtn];
            //
        }else{
            
        }
        
        //タイトル
        CCLabelTTF* lbl_title=[CCLabelTTF labelWithString:title fontName:@"Verdana-Bold" fontSize:15];
        lbl_title.position=ccp(winSize.width-msgBoard.position.x,msgBoard.position.y+msgBoard.contentSize.height*msgBoard.scaleY/2-lbl_title.contentSize.height/2-10);
        [self addChild:lbl_title];
        
        //メッセージ本文
        CCLabelTTF* lbl_msg=[CCLabelTTF labelWithString:msg fontName:@"Verdana-Bold" fontSize:10];
        lbl_msg.position=ccp(winSize.width-msgBoard.position.x,msgBoard.position.y+msgBoard.contentSize.height*msgBoard.scaleY/2-lbl_msg.contentSize.height/2-40);
        [self addChild:lbl_msg];
    }
    
    return self;
}

-(void)yesButtonClicked:(id)sender
{
    if([self.delegate respondsToSelector:@selector(onMessageLayerBtnClocked:procNum:)])
    {
        [self sendDelegate:2]; //2:YES
        [self removeFromParentAndCleanup:YES];
    }
}

-(void)noButtonClicked:(id)sender
{
    if([self.delegate respondsToSelector:@selector(onMessageLayerBtnClocked:procNum:)])
    {
        [self sendDelegate:1]; //1:No
        [self removeFromParentAndCleanup:YES];
    }
}

-(void)okButtonClicked:(id)sender
{
    if([self.delegate respondsToSelector:@selector(onMessageLayerBtnClocked:procNum:)])
    {
        [self sendDelegate:0]; //0:OK
        [self removeFromParentAndCleanup:YES];
    }
}

-(void)sendDelegate:(int)btnNum
{
    [delegate onMessageLayerBtnClocked:btnNum procNum:procNum];
}


-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
}

-(void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
}

-(void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
}

@end
