//
//  InfoLayer.m
//  VirginTech3rdProject
//
//  Created by VirginTech LLC. on 2014/12/15.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "InfoLayer.h"
#import "InitObjManager.h"
#import "GameManager.h"

@implementation InfoLayer

@synthesize pMaxCnt;
@synthesize eMaxCnt;
@synthesize pTotalCnt;
@synthesize eTotalCnt;
@synthesize pCnt;
@synthesize eCnt;
@synthesize repCnt;

CGSize winSize;

/*CCLabelTTF* debugLabel1;
CCLabelTTF* debugLabel2;
CCLabelTTF* debugLabel3;
CCLabelTTF* debugLabel4;
CCLabelTTF* debugLabel5;*/

//スコアボード
CCLabelBMFont* scoreBoard;

//プレイヤーインジケーター
float nowRatio;
CCSprite* pBack_Indicator1;
CCSprite* pBack_Indicator2;
CCSprite* pInput_Indicator;
CCSprite* pSpent_Indicator;
CCLabelTTF* pLbl1;
CCLabelTTF* pLbl2;

//「敵」インジケーター
//float nowRatio;
CCSprite* eBack_Indicator1;
CCSprite* eBack_Indicator2;
CCSprite* eInput_Indicator;
CCSprite* eSpent_Indicator;
CCLabelTTF* eLbl1;
CCLabelTTF* eLbl2;


+ (InfoLayer *)scene
{
    return [[self alloc] init];
}

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    winSize=[[CCDirector sharedDirector]viewSize];
    
    //初期化
    repCnt=0;
    pTotalCnt=0;
    eTotalCnt=0;
    pCnt=0;
    eCnt=0;
    
    if([GameManager getMatchMode]==0){//シングル
        //プレイヤーMax数
        pMaxCnt=[InitObjManager NumPlayerMax:[GameManager getStageLevel]];
        //敵Max数
        eMaxCnt=(int)[InitObjManager init_Enemy_Pattern:[GameManager getStageLevel]].count*([InitObjManager NumOfRepeat:[GameManager getStageLevel]]+1);
    }else{//対戦
        pMaxCnt=250;
        eMaxCnt=250;
    }
    
    //=============================
    //プレイヤー投入可能インジケーター
    //=============================
    [[CCSpriteFrameCache sharedSpriteFrameCache]removeSpriteFrames];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"info_default.plist"];
    
    CCSprite* pFrame=[CCSprite spriteWithSpriteFrame:
                      [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"pFrame.png"]];
    pFrame.scale=0.5;
    if([GameManager getMatchMode]==0){//シングル
        pFrame.position=ccp((pFrame.contentSize.width*pFrame.scale)/2,(pFrame.contentSize.height*pFrame.scale)/2+60);
    }else{
        pFrame.position=ccp((pFrame.contentSize.width*pFrame.scale)/2,(pFrame.contentSize.height*pFrame.scale)/2);
    }
        [self addChild:pFrame];
    
    pBack_Indicator1=[CCSprite spriteWithSpriteFrame:
                [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"back_Indicator.png"]];
    pBack_Indicator1.scale=0.7;
    pBack_Indicator1.position=CGPointMake((pBack_Indicator1.contentSize.width*pBack_Indicator1.scale)/2+80,
                                             pBack_Indicator1.contentSize.height+10);
    [pFrame addChild:pBack_Indicator1];
    
    pInput_Indicator=[CCSprite spriteWithSpriteFrame:
                [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"input_Indicator.png"]];
    nowRatio=(100.0f/40.0f)*(40.0f-pCnt);
    pInput_Indicator.scaleX=nowRatio*0.01;
    pInput_Indicator.position=CGPointMake((nowRatio*0.01)*(pBack_Indicator1.contentSize.width/2),
                                         pBack_Indicator1.contentSize.height/2);
    //input_Indicator.scale=0.8;
    [pBack_Indicator1 addChild:pInput_Indicator];
    
    //ラベル
    pLbl1=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%02d/40",40-pCnt] fontName:@"Verdana-Bold" fontSize:12];
    pLbl1.position=ccp(pBack_Indicator1.position.x+(pBack_Indicator1.contentSize.width*pBack_Indicator1.scale)/2+pLbl1.contentSize.width/2, pBack_Indicator1.position.y);
    [pFrame addChild:pLbl1];
    
    //========================
    //プレイヤー残存インジケーター
    //========================
    pBack_Indicator2=[CCSprite spriteWithSpriteFrame:
                    [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"back_Indicator.png"]];
    pBack_Indicator2.scale=0.7;
    pBack_Indicator2.position=CGPointMake((pBack_Indicator2.contentSize.width*pBack_Indicator2.scale)/2+80,
                                             pBack_Indicator2.contentSize.height-7);
    [pFrame addChild:pBack_Indicator2];
    
    pSpent_Indicator=[CCSprite spriteWithSpriteFrame:
                     [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"spent_Indicator.png"]];
    nowRatio=(100.0f/40.0f)*(40.0f-pCnt);
    pSpent_Indicator.scaleX=nowRatio*0.01;
    pSpent_Indicator.position=CGPointMake((nowRatio*0.01)*(pBack_Indicator2.contentSize.width/2),
                                         pBack_Indicator2.contentSize.height/2);
    //input_Indicator.scale=0.8;
    [pBack_Indicator2 addChild:pSpent_Indicator];
    
    //ラベル
    pLbl2=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%03d/%03d",pMaxCnt-pTotalCnt,pMaxCnt] fontName:@"Verdana-Bold" fontSize:12];
    pLbl2.position=ccp(pBack_Indicator2.position.x+(pBack_Indicator2.contentSize.width*pBack_Indicator2.scale)/2+pLbl2.contentSize.width/2, pBack_Indicator2.position.y);
    [pFrame addChild:pLbl2];

    
    
    if([GameManager getMatchMode]!=0){//対戦モードであれば
        
        //=============================
        //「敵」投入可能インジケーター
        //=============================
        //[[CCSpriteFrameCache sharedSpriteFrameCache]removeSpriteFrames];
        //[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"info_default.plist"];
        
        CCSprite* eFrame=[CCSprite spriteWithSpriteFrame:
                          [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"eFrame.png"]];
        eFrame.scale=0.5;
        eFrame.position=ccp(winSize.width-(eFrame.contentSize.width*eFrame.scale)/2,
                            winSize.height-(eFrame.contentSize.height*eFrame.scale)/2);
        eFrame.rotation=180;
        [self addChild:eFrame];

        eBack_Indicator1=[CCSprite spriteWithSpriteFrame:
                         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"back_Indicator.png"]];
        eBack_Indicator1.scale=0.7;
        eBack_Indicator1.position=CGPointMake((eBack_Indicator1.contentSize.width*eBack_Indicator1.scale)/2+80,
                                        eBack_Indicator1.contentSize.height+10);
        //eBack_Indicator1.rotation=180;
        [eFrame addChild:eBack_Indicator1];
        
        eInput_Indicator=[CCSprite spriteWithSpriteFrame:
                         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"input_Indicator.png"]];
        nowRatio=(100.0f/40.0f)*(40.0f-pCnt);
        eInput_Indicator.scaleX=nowRatio*0.01;
        eInput_Indicator.position=CGPointMake((nowRatio*0.01)*(eBack_Indicator1.contentSize.width/2),
                                             eBack_Indicator1.contentSize.height/2);
        //input_Indicator.scale=0.8;
        //eInput_Indicator.rotation=180;
        [eBack_Indicator1 addChild:eInput_Indicator];
        
        //ラベル
        eLbl1=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%02d/40",40-eCnt] fontName:@"Verdana-Bold" fontSize:12];
        eLbl1.position=ccp(eBack_Indicator1.position.x+(eBack_Indicator1.contentSize.width*eBack_Indicator1.scale)/2+eLbl1.contentSize.width/2, eBack_Indicator1.position.y);
        //eLbl1.rotation=180;
        [eFrame addChild:eLbl1];
        
        //========================
        //「敵」残存インジケーター
        //========================
        eBack_Indicator2=[CCSprite spriteWithSpriteFrame:
                         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"back_Indicator.png"]];
        eBack_Indicator2.scale=0.7;
        eBack_Indicator2.position=CGPointMake((eBack_Indicator2.contentSize.width*eBack_Indicator2.scale)/2+80,
                                                 eBack_Indicator2.contentSize.height-7);
        //eBack_Indicator2.rotation=180;
        [eFrame addChild:eBack_Indicator2];
        
        eSpent_Indicator=[CCSprite spriteWithSpriteFrame:
                         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"spent_Indicator.png"]];
        nowRatio=(100.0f/40.0f)*(40.0f-pCnt);
        eSpent_Indicator.scaleX=nowRatio*0.01;
        eSpent_Indicator.position=CGPointMake((nowRatio*0.01)*(eBack_Indicator2.contentSize.width/2),
                                             eBack_Indicator2.contentSize.height/2);
        //input_Indicator.scale=0.8;
        //eSpent_Indicator.rotation=180;
        [eBack_Indicator2 addChild:eSpent_Indicator];
        
        //ラベル
        eLbl2=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%03d/%03d",eMaxCnt-eTotalCnt,eMaxCnt] fontName:@"Verdana-Bold" fontSize:12];
        eLbl2.position=ccp(eBack_Indicator2.position.x+(eBack_Indicator2.contentSize.width*eBack_Indicator2.scale)/2+eLbl2.contentSize.width/2, eBack_Indicator2.position.y);
        //eLbl2.rotation=180;
        [eFrame addChild:eLbl2];
        
        
        if([GameManager getMatchMode]==2){//ネット対戦で
            if([GameManager getHost]){//ホストなら
                
                eFrame.rotation=0;
                
                /*pBack_Indicator1.position=eBack_Indicator1.position;
                pBack_Indicator2.position=eBack_Indicator2.position;
                pInput_Indicator.position=eInput_Indicator.position;
                pSpent_Indicator.position=eSpent_Indicator.position;
                pLbl1.position=eLbl1.position;
                pLbl2.position=eLbl2.position;

                pBack_Indicator1.rotation=180;
                pBack_Indicator2.rotation=180;
                pInput_Indicator.rotation=180;
                pSpent_Indicator.rotation=180;
                pLbl1.rotation=180;
                pLbl2.rotation=180;
                
                eBack_Indicator1.position=CGPointMake((eBack_Indicator1.contentSize.width*eBack_Indicator1.scale)/2,
                                                      eBack_Indicator1.contentSize.height+20);
                eBack_Indicator2.position=CGPointMake((eBack_Indicator2.contentSize.width*eBack_Indicator2.scale)/2,
                                                      eBack_Indicator2.contentSize.height+10);
                eInput_Indicator.position=CGPointMake((nowRatio*0.01)*(eBack_Indicator1.contentSize.width/2),
                                                      eBack_Indicator1.contentSize.height/2);
                eSpent_Indicator.position=CGPointMake((nowRatio*0.01)*(eBack_Indicator2.contentSize.width/2),
                                                      eBack_Indicator2.contentSize.height/2);
                eLbl1.position=ccp(eBack_Indicator1.position.x+(eBack_Indicator1.contentSize.width*eBack_Indicator1.scale)/2+eLbl1.contentSize.width/2, eBack_Indicator1.position.y);
                eLbl2.position=ccp(eBack_Indicator2.position.x+(eBack_Indicator2.contentSize.width*eBack_Indicator2.scale)/2+eLbl2.contentSize.width/2, eBack_Indicator2.position.y);

                eBack_Indicator1.rotation=0;
                eBack_Indicator2.rotation=0;
                eInput_Indicator.rotation=0;
                eSpent_Indicator.rotation=0;
                eLbl1.rotation=0;
                eLbl2.rotation=0;*/
                
            }else{//クライアントなら反転
                pFrame.position=eFrame.position;
                pFrame.rotation=0;
                eFrame.position=ccp((pFrame.contentSize.width*pFrame.scale)/2,(pFrame.contentSize.height*pFrame.scale)/2);
                eFrame.rotation=0;
            }
        }
        
    }
    
    //======================
    // スコアボード
    //======================
    if([GameManager getMatchMode]==0){//シングル戦
        //scoreBoard=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"Score:%05ld",[GameManager load_Score]]
        //                          fontName:@"Verdana-Bold" fontSize:15];
        scoreBoard=[CCLabelBMFont labelWithString:
                    [NSString stringWithFormat:@"SCORE\n%05ld",[GameManager load_Score]]fntFile:@"font.fnt"];
        scoreBoard.scale=0.3;
        scoreBoard.position=ccp((scoreBoard.contentSize.width*scoreBoard.scale)/2,
                                winSize.height-(scoreBoard.contentSize.height*scoreBoard.scale)/2);
        [self addChild:scoreBoard];
    }else if([GameManager getMatchMode]==2){//ネット対戦
        //scoreBoard=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"対戦成績\n%02d勝",[GameManager load_Match_Point]]
        //                              fontName:@"Verdana-Bold" fontSize:15];
        scoreBoard=[CCLabelBMFont labelWithString:
                    [NSString stringWithFormat:@"対戦成績\n%02d勝",[GameManager load_Match_Point]]fntFile:@"font.fnt"];
        scoreBoard.scale=0.3;
        scoreBoard.position=ccp((scoreBoard.contentSize.width*scoreBoard.scale)/2,
                                winSize.height-(scoreBoard.contentSize.height*scoreBoard.scale)/2);
        [self addChild:scoreBoard];
    }

    
    /*/デバッグラベル
    if([GameManager getMatchMode]==0)
    {
         debugLabel1=[CCLabelTTF labelWithString:@"青=000 赤=000" fontName:@"Verdana-Bold" fontSize:10];
         debugLabel1.position=ccp(debugLabel1.contentSize.width/2, winSize.height-debugLabel1.contentSize.height/2);
         [self addChild:debugLabel1];
         
         debugLabel2=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"PlayerMax=%d",pMaxCnt] fontName:@"Verdana-Bold" fontSize:10];
         debugLabel2.position=ccp(debugLabel2.contentSize.width/2, debugLabel1.position.y-debugLabel2.contentSize.height);
         [self addChild:debugLabel2];
         
         debugLabel3=[CCLabelTTF labelWithString:@"Totle=0000" fontName:@"Verdana-Bold" fontSize:10];
         debugLabel3.position=ccp(debugLabel3.contentSize.width/2, debugLabel2.position.y-debugLabel3.contentSize.height);
         [self addChild:debugLabel3];
         
         debugLabel4=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"eRepeat: 0/0"]fontName:@"Verdana-Bold" fontSize:10];
         debugLabel4.position=ccp(debugLabel4.contentSize.width/2, debugLabel3.position.y-debugLabel4.contentSize.height);
         [self addChild:debugLabel4];
         
         debugLabel5=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"EnemyMax=%d",eMaxCnt]fontName:@"Verdana-Bold" fontSize:10];
         debugLabel5.position=ccp(debugLabel5.contentSize.width/2, debugLabel4.position.y-debugLabel5.contentSize.height);
         [self addChild:debugLabel5];
    }
    else
    {
        debugLabel1=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"PlayerMax=%d",pMaxCnt] fontName:@"Verdana-Bold" fontSize:10];
        debugLabel1.position=ccp(debugLabel1.contentSize.width/2, winSize.height-debugLabel1.contentSize.height/2);
        [self addChild:debugLabel1];
        
        debugLabel2=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"EnemyMax=%d",eMaxCnt] fontName:@"Verdana-Bold" fontSize:10];
        debugLabel2.position=ccp(debugLabel2.contentSize.width/2, debugLabel1.position.y-debugLabel2.contentSize.height);
        [self addChild:debugLabel2];
        
        debugLabel3=[CCLabelTTF labelWithString:@"青=000 赤=000" fontName:@"Verdana-Bold" fontSize:10];
        debugLabel3.position=ccp(debugLabel3.contentSize.width/2, debugLabel2.position.y-debugLabel3.contentSize.height);
        [self addChild:debugLabel3];
        
        debugLabel4=[CCLabelTTF labelWithString:@"pTotal=0000" fontName:@"Verdana-Bold" fontSize:10];
        debugLabel4.position=ccp(debugLabel4.contentSize.width/2, debugLabel3.position.y-debugLabel4.contentSize.height);
        [self addChild:debugLabel4];
        
        debugLabel5=[CCLabelTTF labelWithString:@"eTotle=0000" fontName:@"Verdana-Bold" fontSize:10];
        debugLabel5.position=ccp(debugLabel5.contentSize.width/2, debugLabel4.position.y-debugLabel5.contentSize.height);
        [self addChild:debugLabel5];
    }*/
    
    return self;
}

-(void)score_Update
{
    if([GameManager getMatchMode]==0){//シングル
        scoreBoard.string=[NSString stringWithFormat:@"SCORE\n%05ld",[GameManager load_Score]];
    }else if([GameManager getMatchMode]==2){//ネット対戦
        scoreBoard.string=[NSString stringWithFormat:@"対戦成績\n%02d勝",[GameManager load_Match_Point]];
    }
}

-(void)stats_Update
{
    //=======================
    //プレイヤー側インジケーター
    //=======================
    if(pMaxCnt-pTotalCnt > 40-pCnt){//悩んだよ！
        nowRatio=(100.0f/40.0f)*(40.0f-pCnt);
        pLbl1.string=[NSString stringWithFormat:@"%02d/40",40-pCnt];
    }else{
        nowRatio=(100.0f/40.0f)*(pMaxCnt-pTotalCnt);
        pLbl1.string=[NSString stringWithFormat:@"%02d/40",pMaxCnt-pTotalCnt];
    }
    pInput_Indicator.scaleX=nowRatio*0.01;
    pInput_Indicator.position=CGPointMake((nowRatio*0.01)*(pBack_Indicator1.contentSize.width/2),
                                                                    pBack_Indicator1.contentSize.height/2);
    
    nowRatio=(100.0f/pMaxCnt)*(pMaxCnt-pTotalCnt);
    pSpent_Indicator.scaleX=nowRatio*0.01;
    pSpent_Indicator.position=CGPointMake((nowRatio*0.01)*(pBack_Indicator1.contentSize.width/2),
                                                                    pBack_Indicator1.contentSize.height/2);
    pLbl2.string=[NSString stringWithFormat:@"%03d/%03d",pMaxCnt-pTotalCnt,pMaxCnt];

    //=======================
    //「敵」側インジケーター
    //=======================
    if(eMaxCnt-eTotalCnt > 40-eCnt){
        nowRatio=(100.0f/40.0f)*(40.0f-eCnt);
        eLbl1.string=[NSString stringWithFormat:@"%02d/40",40-eCnt];
    }else{
        nowRatio=(100.0f/40.0f)*(eMaxCnt-eTotalCnt);
        eLbl1.string=[NSString stringWithFormat:@"%02d/40",eMaxCnt-eTotalCnt];
    }
    eInput_Indicator.scaleX=nowRatio*0.01;
    eInput_Indicator.position=CGPointMake((nowRatio*0.01)*(eBack_Indicator1.contentSize.width/2),
                                          eBack_Indicator1.contentSize.height/2);
    
    nowRatio=(100.0f/eMaxCnt)*(eMaxCnt-eTotalCnt);
    eSpent_Indicator.scaleX=nowRatio*0.01;
    eSpent_Indicator.position=CGPointMake((nowRatio*0.01)*(eBack_Indicator1.contentSize.width/2),
                                          eBack_Indicator1.contentSize.height/2);
    eLbl2.string=[NSString stringWithFormat:@"%03d/%03d",eMaxCnt-eTotalCnt,eMaxCnt];
    
    
    /*/デバッグラベル更新
    if([GameManager getMatchMode]==0)
    {
        debugLabel1.string=[NSString stringWithFormat:@"青=%03d 赤=%03d",pCnt,eCnt];
        debugLabel3.string=[NSString stringWithFormat:@"Totle=%04d",pTotalCnt];
        debugLabel4.string=[NSString stringWithFormat:@"eRepeat:%d／%d",repCnt,[InitObjManager NumOfRepeat:[GameManager getStageLevel]]+1];
    }
    else
    {
        debugLabel3.string=[NSString stringWithFormat:@"青=%03d 赤=%03d",pCnt,eCnt];
        debugLabel4.string=[NSString stringWithFormat:@"pTotle=%04d",pTotalCnt];
        debugLabel5.string=[NSString stringWithFormat:@"eTotle=%04d",eTotalCnt];
    }*/
}

@end
