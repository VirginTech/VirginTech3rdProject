//
//  ResultsLayer.m
//  VirginTech3rdProject
//
//  Created by VirginTech LLC. on 2014/12/17.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "ResultsLayer.h"
#import "GameManager.h"
#import "TitleScene.h"
#import "InitObjManager.h"
#import "SelectScene.h"
#import "SoundManager.h"
#import <Social/Social.h>

@implementation ResultsLayer

CGSize winSize;

CCSprite* victorySpr;
CCSprite* defeatSpr;

CCSprite* starB;
CCSprite* starG;
int cnt;
int rep;

CCLabelBMFont* enemyDieLabel;
CCLabelBMFont* playerDieLabel;
CCLabelBMFont* enemyFortressLabel;
CCLabelBMFont* playerFortressLabel;

CCLabelBMFont* enemyDieScore;
CCLabelBMFont* playerDieScore;
CCLabelBMFont* enemyFortressScore;
CCLabelBMFont* playerFortressScore;

int playerDieCount;
int enemyDieCount;
int playerFortressAbility;
int enemyFortressAbility;

int scoreNum;
CCSprite* highScore;
bool highScoreFlg;

MessageLayer* msgBox;

+ (ResultsLayer *)scene
{
    return [[self alloc] init];
}

- (id)initWithWinner:(bool)flg
                            stars:(int)stars
                            playerDie:(int)_playerDieCount
                            enemyDie:(int)_enemyDieCount
                            playerFortress:(int)_playerFortressAbility
                            highScoreFlg:(bool)_highScoreFlg
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    self.userInteractionEnabled = YES;
    winSize=[[CCDirector sharedDirector]viewSize];
    
    //初期化
    cnt=0;
    rep=stars*300;
    playerDieCount=[InitObjManager NumPlayerMax:[GameManager getStageLevel]]-_playerDieCount;
    enemyDieCount=_enemyDieCount;
    playerFortressAbility=_playerFortressAbility;
    enemyFortressAbility=500;
    scoreNum=0;
    highScoreFlg=_highScoreFlg;
    
    // Create a colored background (Dark Grey)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:0.5f]];
    [self addChild:background];
    
    //画像読込み
    [[CCSpriteFrameCache sharedSpriteFrameCache]removeSpriteFrames];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"results_default.plist"];
    
    CCButton *titleButton = [CCButton buttonWithTitle:@"" spriteFrame:
                             [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"titleBtn.png"]];
    titleButton.positionType = CCPositionTypeNormalized;
    if([GameManager getMatchMode]==0){
        titleButton.position = ccp(0.35f, 0.275f); // Top Right of screen
    }else{
        titleButton.position = ccp(0.5f, 0.275f); // Top Right of screen
    }
    [titleButton setTarget:self selector:@selector(onTitleClicked:)];
    titleButton.scale=0.6;
    [self addChild:titleButton];
    
    //=================
    //勝利判定ラベル
    //=================
    victorySpr=[CCSprite spriteWithSpriteFrame:
                        [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"victory_jp.png"]];
    
    defeatSpr=[CCSprite spriteWithSpriteFrame:
                        [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"defeat_jp.png"]];
    victorySpr.visible=false;
    defeatSpr.visible=false;
    
    if([GameManager getMatchMode]==0)//シングル
    {
        //セレクトシーン
        CCButton* selectButton = [CCButton buttonWithTitle:@"" spriteFrame:
                                  [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"selectBtn.png"]];
        selectButton.positionType = CCPositionTypeNormalized;
        selectButton.position = ccp(0.65f, 0.275f); // Top Right of screen
        [selectButton setTarget:self selector:@selector(onSelectClicked:)];
        selectButton.scale=0.6;
        [self addChild:selectButton];
        
        //ツイッターボタン
        CCButton* twitter=[CCButton buttonWithTitle:@"" spriteFrame:
                           [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"twitter.png"]];
        twitter.positionType = CCPositionTypeNormalized;
        twitter.position=ccp(0.3f,0.2f);
        twitter.scale=0.7;
        [twitter setTarget:self selector:@selector(onTwitterClicked:)];
        [self addChild:twitter];
        
        //フェイスブックボタン
        CCButton* facebook=[CCButton buttonWithTitle:@"" spriteFrame:
                           [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"facebook.png"]];
        facebook.positionType = CCPositionTypeNormalized;
        facebook.position=ccp(0.7f,0.2f);
        facebook.scale=0.7;
        [facebook setTarget:self selector:@selector(onFacebookClicked:)];
        [self addChild:facebook];
        
        //三ツ星描画（黒）
        for(int i=0;i<3;i++){
            starB=[CCSprite spriteWithSpriteFrame:
                        [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"star_B.png"]];
            if(i==0){
                starB.position=ccp(winSize.width/2-100,winSize.height/2+100);
            }else if(i==1){
                starB.position=ccp(winSize.width/2,winSize.height/2+130);
            }else{
                starB.position=ccp(winSize.width/2+100,winSize.height/2+100);
            }
            starB.scale=0.7;
            [self addChild:starB];
        }
        
        //判定ラベル
        if(flg){//勝利
            //三ツ星描画（ゴールド）
            [self schedule:@selector(star_Schedule:) interval:0.001 repeat:rep delay:0.25];
            
            //ラベル
            CCSprite* enemy=[CCSprite spriteWithSpriteFrame:
                              [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"enemy.png"]];
            enemy.scale=0.3;
            if([GameManager getDevice]==3){
                enemy.position=ccp((enemy.contentSize.width*enemy.scale)/2+100,winSize.height/2+15);
            }else{
                enemy.position=ccp((enemy.contentSize.width*enemy.scale)/2+50,winSize.height/2+15);
            }
            [self addChild:enemy];
            
            enemyDieLabel=[CCLabelBMFont labelWithString:@"たおした敵兵の数 : " fntFile:@"results.fnt"];
            enemyDieLabel.scale=0.3;
            enemyDieLabel.position=ccp(enemy.position.x+(enemy.contentSize.width*enemy.scale)/2+(enemyDieLabel.contentSize.width*enemyDieLabel.scale)/2,enemy.position.y);
            [self addChild:enemyDieLabel];
            
            enemyDieScore=[CCLabelBMFont labelWithString:
                        [NSString stringWithFormat:@"%05d",enemyDieCount]fntFile:@"results.fnt"];
            enemyDieScore.scale=0.5;
            enemyDieScore.position=ccp(enemyDieLabel.position.x+(enemyDieLabel.contentSize.width*enemyDieLabel.scale)/2+(enemyDieScore.contentSize.width*enemyDieScore.scale)/2,enemyDieLabel.position.y);
            [self addChild:enemyDieScore];
            
            //----------
            CCSprite* player=[CCSprite spriteWithSpriteFrame:
                              [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"player.png"]];
            player.scale=0.3;
            player.position=ccp(enemy.position.x,enemy.position.y-(enemy.contentSize.height*enemy.scale)/2-(player.contentSize.height*player.scale)/2);
            [self addChild:player];
            
            playerDieLabel=[CCLabelBMFont labelWithString:@"生残った我兵の数 : " fntFile:@"results.fnt"];
            playerDieLabel.scale=0.3;
            playerDieLabel.position=ccp(player.position.x+(player.contentSize.width*player.scale)/2+(playerDieLabel.contentSize.width*playerDieLabel.scale)/2,player.position.y);
            [self addChild:playerDieLabel];

            playerDieScore=[CCLabelBMFont labelWithString:
                            [NSString stringWithFormat:@"%05d",playerDieCount]fntFile:@"results.fnt"];
            playerDieScore.scale=0.5;
            playerDieScore.position=ccp(playerDieLabel.position.x+(playerDieLabel.contentSize.width*playerDieLabel.scale)/2+(playerDieScore.contentSize.width*playerDieScore.scale)/2,playerDieLabel.position.y);
            [self addChild:playerDieScore];

            //----------
            CCSprite* eFortress=[CCSprite spriteWithSpriteFrame:
                              [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"eFortress.png"]];
            eFortress.scale=0.3;
            eFortress.position=ccp(player.position.x,player.position.y-(player.contentSize.height*player.scale)/2-(eFortress.contentSize.height*eFortress.scale)/2);
            [self addChild:eFortress];
            
            enemyFortressLabel=[CCLabelBMFont labelWithString:@"敵城破壊ポイント : " fntFile:@"results.fnt"];
            enemyFortressLabel.scale=0.3;
            enemyFortressLabel.position=ccp(eFortress.position.x+(eFortress.contentSize.width*eFortress.scale)/2+(enemyFortressLabel.contentSize.width*enemyFortressLabel.scale)/2,eFortress.position.y);
            [self addChild:enemyFortressLabel];

            enemyFortressScore=[CCLabelBMFont labelWithString:
                                [NSString stringWithFormat:@"%05d",enemyFortressAbility] fntFile:@"results.fnt"];
            enemyFortressScore.scale=0.5;
            enemyFortressScore.position=ccp(enemyFortressLabel.position.x+(enemyFortressLabel.contentSize.width*enemyFortressLabel.scale)/2+(enemyFortressScore.contentSize.width*enemyFortressScore.scale)/2,enemyFortressLabel.position.y);
            [self addChild:enemyFortressScore];

            //----------
            CCSprite* pFortress=[CCSprite spriteWithSpriteFrame:
                                 [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"pFortress.png"]];
            pFortress.scale=0.3;
            pFortress.position=ccp(eFortress.position.x,eFortress.position.y-(eFortress.contentSize.height*player.scale)/2-(pFortress.contentSize.height*pFortress.scale)/2);
            [self addChild:pFortress];
            
            playerFortressLabel=[CCLabelBMFont labelWithString:@"我城残存ポイント : " fntFile:@"results.fnt"];
            playerFortressLabel.scale=0.3;
            playerFortressLabel.position=ccp(pFortress.position.x+(pFortress.contentSize.width*pFortress.scale)/2+(playerFortressLabel.contentSize.width*playerFortressLabel.scale)/2,pFortress.position.y);
            [self addChild:playerFortressLabel];

            playerFortressScore=[CCLabelBMFont labelWithString:
                                 [NSString stringWithFormat:@"%05d",playerFortressAbility] fntFile:@"results.fnt"];
            playerFortressScore.scale=0.5;
            playerFortressScore.position=ccp(playerFortressLabel.position.x+(playerFortressLabel.contentSize.width*playerFortressLabel.scale)/2+(playerFortressScore.contentSize.width*playerFortressScore.scale)/2,playerFortressLabel.position.y);
            [self addChild:playerFortressScore];

            //victorySpr.visible=true;
            //victorySpr.position=ccp(winSize.width/2,winSize.height-victorySpr.contentSize.height/2);
            //[self addChild:victorySpr];
            
            //titleButton.position=ccp(0.5f,0.3f);
            
        }else{//敗北
            //サウンド
            [SoundManager lose_Effect];
            defeatSpr.visible=true;
            defeatSpr.position=ccp(winSize.width/2,winSize.height/2);
            [self addChild:defeatSpr];
        }
    }
    else if([GameManager getMatchMode]==1)//２人対戦
    {
        victorySpr.visible=true;
        defeatSpr.visible=true;
        
        if(flg){
            //サウンド
            [SoundManager win_Effect];

            victorySpr.position=ccp(winSize.width/2,winSize.height/2-100);
            [self addChild:victorySpr];
            
            defeatSpr.position=ccp(winSize.width/2,winSize.height/2+100);
            defeatSpr.rotation=180;
            [self addChild:defeatSpr];
        }else{
            //サウンド
            [SoundManager lose_Effect];

            defeatSpr.position=ccp(winSize.width/2,winSize.height/2-100);
            [self addChild:defeatSpr];
            
            victorySpr.position=ccp(winSize.width/2,winSize.height/2+100);
            victorySpr.rotation=180;
            [self addChild:victorySpr];
        }
        
        titleButton.position=ccp(0.5f,0.5f);
        
    }
    else//ネット対戦
    {
        if(flg){
            if([GameManager getHost]){
                //サウンド
                [SoundManager win_Effect];
                victorySpr.visible=true;
                victorySpr.position=ccp(winSize.width/2,winSize.height/2);
                [self addChild:victorySpr];
            }else{
                //サウンド
                [SoundManager lose_Effect];
                defeatSpr.visible=true;
                defeatSpr.position=ccp(winSize.width/2,winSize.height/2);
                [self addChild:defeatSpr];
            }
        }else{
            if([GameManager getHost]){
                //サウンド
                [SoundManager lose_Effect];
                defeatSpr.visible=true;
                defeatSpr.position=ccp(winSize.width/2,winSize.height/2);
                [self addChild:defeatSpr];
            }else{
                //サウンド
                [SoundManager win_Effect];
                victorySpr.visible=true;
                victorySpr.position=ccp(winSize.width/2,winSize.height/2);
                [self addChild:victorySpr];
            }
        }
    }
    return self;
}

-(void)star_Schedule:(CCTime)dt
{
    cnt++;

    if(cnt==1)
    {
        starG=[CCSprite spriteWithSpriteFrame:
               [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"star_G.png"]];
        starG.position=ccp(winSize.width/2-100,winSize.height/2+100);
        starG.scale=3.0;
        [self addChild:starG z:1];
    }
    else if(cnt==300)
    {
        //サウンドエフェクト
        [SoundManager star_Effect];
        //パーティクル
        [self set_Star_Particle];
        starG.scale=0.7;
        starG.position=ccp(winSize.width/2-100,winSize.height/2+100);
        if(rep>300){
            starG=[CCSprite spriteWithSpriteFrame:
                   [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"star_G.png"]];
            starG.position=ccp(winSize.width/2,winSize.height/2+130);
            starG.scale=3.0;
            [self addChild:starG z:1];
        }else{
            [self schedule:@selector(score_Schedule:) interval:0.01 repeat:enemyDieCount delay:0];
        }
    }
    else if(cnt==600)
    {
        //サウンドエフェクト
        [SoundManager star_Effect];
        //パーティクル
        [self set_Star_Particle];
        starG.scale=0.7;
        starG.position=ccp(winSize.width/2,winSize.height/2+130);
        if(rep>600){
            starG=[CCSprite spriteWithSpriteFrame:
                   [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"star_G.png"]];
            starG.position=ccp(winSize.width/2+100,winSize.height/2+100);
            starG.scale=3.0;
            [self addChild:starG z:1];
        }else{
            [self schedule:@selector(score_Schedule:) interval:0.01 repeat:enemyDieCount delay:0];
        }
    }
    else if(cnt==900)
    {
        //サウンドエフェクト
        [SoundManager star_Effect];
        //パーティクル
        [self set_Star_Particle];
        starG.scale=0.7;
        starG.position=ccp(winSize.width/2+100,winSize.height/2+100);
        [self schedule:@selector(score_Schedule:) interval:0.01 repeat:enemyDieCount delay:0];
    }
    else
    {
        starG.scale-=0.01;
    }
}

-(void)score_Schedule:(CCTime)dt
{
    
    if(scoreNum==0)
    {
        if(enemyDieCount>0){
            enemyDieCount--;
            enemyDieScore.string=[NSString stringWithFormat:@"%05d",enemyDieCount];
            //サウンドエフェクト
            if(enemyDieCount%10==0){
                [SoundManager score_Effect];
            }
        }else{
            scoreNum++;
            [self schedule:@selector(score_Schedule:) interval:0.01 repeat:playerDieCount delay:0];
        }
    }
    else if(scoreNum==1)
    {
        if(playerDieCount>0){
            playerDieCount--;
            playerDieScore.string=[NSString stringWithFormat:@"%05d",playerDieCount];
            //サウンドエフェクト
            if(playerDieCount%10==0){
                [SoundManager score_Effect];
            }
        }else{
            scoreNum++;
            [self schedule:@selector(score_Schedule:) interval:0.001 repeat:enemyFortressAbility delay:0];
        }
    }
    else if(scoreNum==2)
    {
        if(enemyFortressAbility>0){
            enemyFortressAbility--;
            enemyFortressScore.string=[NSString stringWithFormat:@"%05d",enemyFortressAbility];
            //サウンドエフェクト
            if(enemyFortressAbility%100==0){
                [SoundManager score_Effect];
            }
        }else{
            scoreNum++;
            [self schedule:@selector(score_Schedule:) interval:0.001 repeat:playerFortressAbility delay:0];
        }
    }
    else if(scoreNum==3)
    {
        if(playerFortressAbility>0){
            playerFortressAbility--;
            playerFortressScore.string=[NSString stringWithFormat:@"%05d",playerFortressAbility];
            //サウンドエフェクト
            if(playerFortressAbility%100==0){
                [SoundManager score_Effect];
            }
        }else{
            if(highScoreFlg){//ハイスコアなら
                highScore=[CCSprite spriteWithSpriteFrame:
                       [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"highscore.png"]];
                highScore.position=ccp(winSize.width/2,winSize.height/2);
                highScore.scale=3.0;
                [self addChild:highScore z:2];
                cnt=0;
                [self schedule:@selector(high_Score_Schedule:) interval:0.01 repeat:200 delay:0];
            }else{
                //サウンド
                [SoundManager win_Effect];
            }
        }
    }
}

-(void)high_Score_Schedule:(CCTime)dt
{
    //サウンド
    if(cnt==0){
        [SoundManager highscore_Effect];
    }
    cnt++;
    highScore.scale-=0.01;
    highScore.rotation+=10;
    if(cnt==200){
        //サウンド
        [SoundManager win_Effect];
        highScore.scale=0.8;
        highScore.position=ccp(winSize.width/2,winSize.height/2);
        highScore.rotation=-25;
        
        //レビュー誘導メッセージ
        if([GameManager getStageLevel]%5==0)
        {
            //カスタムアラートメッセージ
            msgBox=[[MessageLayer alloc]initWithTitle:NSLocalizedString(@"Rate",NULL)
                                                    msg:NSLocalizedString(@"Rate_Message",NULL)
                                                    pos:ccp(winSize.width/2,winSize.height/2)
                                                    size:CGSizeMake(230, 100)
                                                    modal:true
                                                    rotation:false
                                                    type:1//YES/NO
                                                    procNum:1];
            msgBox.delegate=self;//デリゲートセット
            [self addChild:msgBox z:3];
        }
        
    }
}

-(void)set_Star_Particle
{
    CCParticleSystem* starParticle=[[CCParticleSystem alloc]initWithFile:@"star.plist"];
    starParticle.position=ccp(starG.position.x,starG.position.y);
    starParticle.scale=0.7;
    [self addChild:starParticle z:0];
}

- (void)onTitleClicked:(id)sender
{
    // back to intro scene with transition
    [SoundManager all_Stop];
    [SoundManager click_Effect];
    [[CCDirector sharedDirector] replaceScene:[TitleScene scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];
}

-(void)onSelectClicked:(id)sender
{
    [SoundManager all_Stop];
    [SoundManager click_Effect];
    [[CCDirector sharedDirector] replaceScene:[SelectScene scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];
}

-(void)onTwitterClicked:(id)sender
{
    SLComposeViewController *vc = [SLComposeViewController
                                   composeViewControllerForServiceType:SLServiceTypeTwitter];
    [vc setInitialText:[NSString stringWithFormat:
                                @"%@ %ld %@\n",NSLocalizedString(@"PostMessage",NULL),
                                [GameManager load_High_Score],
                                NSLocalizedString(@"PostEnd",NULL)]];
    [vc addURL:[NSURL URLWithString:NSLocalizedString(@"URL",NULL)]];
    [vc setCompletionHandler:^(SLComposeViewControllerResult result)
     {
         switch (result) {
             case SLComposeViewControllerResultDone:
                 //チケットを付与
                 [GameManager save_Coin:[GameManager load_Coin]+10];
                 break;
             case SLComposeViewControllerResultCancelled:
                 break;
         }
     }];
    [[CCDirector sharedDirector]presentViewController:vc animated:YES completion:nil];
}

-(void)onFacebookClicked:(id)sender
{
    SLComposeViewController *vc = [SLComposeViewController
                                   composeViewControllerForServiceType:SLServiceTypeFacebook];
    [vc setInitialText:[NSString stringWithFormat:
                                @"%@ %ld %@\n",NSLocalizedString(@"PostMessage",NULL),
                                [GameManager load_High_Score],
                                NSLocalizedString(@"PostEnd",NULL)]];
    [vc addURL:[NSURL URLWithString:NSLocalizedString(@"URL",NULL)]];
    [vc setCompletionHandler:^(SLComposeViewControllerResult result)
     {
         switch (result) {
             case SLComposeViewControllerResultDone:
                 //チケットを付与
                 [GameManager save_Coin:[GameManager load_Coin]+10];
                 break;
             case SLComposeViewControllerResultCancelled:
                 break;
         }
     }];
    [[CCDirector sharedDirector]presentViewController:vc animated:YES completion:nil];
}

//=====================
// デリゲートメソッド
//=====================
-(void)onMessageLayerBtnClocked:(int)btnNum procNum:(int)procNum
{
    if(btnNum==2){//「はい」だったら
        NSURL* url = [NSURL URLWithString:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=945977622&mt=8&type=Purple+Software"];
        [[UIApplication sharedApplication]openURL:url];
    }
    msgBox.delegate=nil;//デリゲート解除
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
