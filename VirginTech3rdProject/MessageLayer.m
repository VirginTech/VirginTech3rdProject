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

-(id)init:(CGSize)size type:(int)type title:(NSString*)title msg:(NSString*)msg
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    self.userInteractionEnabled = YES;
    winSize=[[CCDirector sharedDirector]viewSize];
    
    //画像の読込み
    [[CCSpriteFrameCache sharedSpriteFrameCache]removeSpriteFrames];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"message_default.plist"];
    
    //メッセージボックス
    CCSprite* msgBoard=[CCSprite spriteWithSpriteFrame:
                        [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"msgBoard.png"]];
    msgBoard.position=ccp(winSize.width/2,winSize.height/2);
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
    
    if(type==1){
        yesBtn.position=ccp(winSize.width-msgBoard.position.x+yesBtn.contentSize.width*yesBtn.scale/2+5, winSize.height-msgBoard.position.y-msgBoard.contentSize.height*msgBoard.scaleY/2+yesBtn.contentSize.height*yesBtn.scale/2+(msgBoard.contentSize.height*msgBoard.scaleY)*0.05);
        [self addChild:yesBtn];
        noBtn.position=ccp(winSize.width-msgBoard.position.x-noBtn.contentSize.width*noBtn.scale/2-5, winSize.height-msgBoard.position.y-msgBoard.contentSize.height*msgBoard.scaleY/2+noBtn.contentSize.height*noBtn.scale/2+(msgBoard.contentSize.height*msgBoard.scaleY)*0.05);
        [self addChild:noBtn];
    }else{
        okBtn.position=ccp(winSize.width-msgBoard.position.x, winSize.height-msgBoard.position.y-msgBoard.contentSize.height*msgBoard.scaleY/2+okBtn.contentSize.height*okBtn.scale/2+(msgBoard.contentSize.height*msgBoard.scaleY)*0.05);
        [self addChild:okBtn];
    }
    
    //タイトル
    CCLabelTTF* lbl_title=[CCLabelTTF labelWithString:title fontName:@"Verdana-Bold" fontSize:15];
    lbl_title.position=ccp(winSize.width-msgBoard.position.x,winSize.height-msgBoard.position.y+msgBoard.contentSize.height*msgBoard.scaleY/2-lbl_title.contentSize.height-msgBoard.contentSize.height*msgBoard.scaleY*0.05);
    [self addChild:lbl_title];
    
    //メッセージ本文
    CCLabelTTF* lbl_msg=[CCLabelTTF labelWithString:msg fontName:@"Verdana-Bold" fontSize:10];
    lbl_msg.position=ccp(winSize.width-msgBoard.position.x,winSize.height-msgBoard.position.y+msgBoard.contentSize.height*msgBoard.scaleY/2-lbl_msg.contentSize.height-msgBoard.contentSize.height*msgBoard.scaleY*0.3);
    [self addChild:lbl_msg];
    
    return self;
}

-(void)yesButtonClicked:(id)sender
{
    if([self.delegate respondsToSelector:@selector(onMessageLayerBtnClocked:)])
    {
        [self sendDelegate:1];
        [self removeFromParentAndCleanup:YES];
    }
}

-(void)noButtonClicked:(id)sender
{
    if([self.delegate respondsToSelector:@selector(onMessageLayerBtnClocked:)])
    {
        [self sendDelegate:0];
        [self removeFromParentAndCleanup:YES];
    }
}

-(void)okButtonClicked:(id)sender
{
    if([self.delegate respondsToSelector:@selector(onMessageLayerBtnClocked:)])
    {
        [self sendDelegate:-1];
        [self removeFromParentAndCleanup:YES];
    }
}

-(void)sendDelegate:(int)btnNum
{
    [delegate onMessageLayerBtnClocked:btnNum];
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
