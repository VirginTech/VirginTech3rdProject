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

int playerDieCount;
int enemyDieCount;
int playerFortressAbility;
int enemyFortressAbility;

int scoreNum;
CCSprite* highScore;
bool highScoreFlg;

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
    
    CCButton* titleButton = [CCButton buttonWithTitle:@"[タイトル]" fontName:@"Verdana-Bold" fontSize:15.0f];
    titleButton.positionType = CCPositionTypeNormalized;
    titleButton.position = ccp(0.5f, 0.3f); // Top Right of screen
    [titleButton setTarget:self selector:@selector(onTitleClicked:)];
    [self addChild:titleButton];
    
    //=================
    //勝利判定ラベル
    //=================
    
    //画像読込み
    [[CCSpriteFrameCache sharedSpriteFrameCache]removeSpriteFrames];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"results_default.plist"];
    
    victorySpr=[CCSprite spriteWithSpriteFrame:
                        [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"victory_jp.png"]];
    
    defeatSpr=[CCSprite spriteWithSpriteFrame:
                        [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"defeat_jp.png"]];
    victorySpr.visible=false;
    defeatSpr.visible=false;
    
    if([GameManager getMatchMode]==0)//シングル
    {
        //セレクトシーン
        CCButton* selectButton = [CCButton buttonWithTitle:@"[セレクト]" fontName:@"Verdana-Bold" fontSize:15.0f];
        selectButton.positionType = CCPositionTypeNormalized;
        selectButton.position = ccp(0.5f, 0.25f); // Top Right of screen
        [selectButton setTarget:self selector:@selector(onSelectClicked:)];
        [self addChild:selectButton];
        
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
                enemy.position=ccp((enemy.contentSize.width*enemy.scale)/2+50,winSize.height/2+15);
            }else{
                enemy.position=ccp((enemy.contentSize.width*enemy.scale)/2+25,winSize.height/2+15);
            }
            [self addChild:enemy];
            
            enemyDieLabel=[CCLabelBMFont labelWithString:
                        [NSString stringWithFormat:@"たおした敵兵の数:%05d",enemyDieCount]fntFile:@"results.fnt"];
            enemyDieLabel.scale=0.5;
            enemyDieLabel.position=ccp(enemy.position.x+(enemy.contentSize.width*enemy.scale)/2+(enemyDieLabel.contentSize.width*enemyDieLabel.scale)/2,enemy.position.y);
            [self addChild:enemyDieLabel];
            
            //----------
            CCSprite* player=[CCSprite spriteWithSpriteFrame:
                              [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"player.png"]];
            player.scale=0.3;
            player.position=ccp(enemy.position.x,enemy.position.y-(enemy.contentSize.height*enemy.scale)/2-(player.contentSize.height*player.scale)/2);
            [self addChild:player];
            
            playerDieLabel=[CCLabelBMFont labelWithString:
                        [NSString stringWithFormat:@"生残った我兵の数:%05d",playerDieCount]fntFile:@"results.fnt"];
            playerDieLabel.scale=0.5;
            playerDieLabel.position=ccp(player.position.x+(player.contentSize.width*player.scale)/2+(playerDieLabel.contentSize.width*playerDieLabel.scale)/2,player.position.y);
            [self addChild:playerDieLabel];
            
            //----------
            CCSprite* eFortress=[CCSprite spriteWithSpriteFrame:
                              [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"eFortress.png"]];
            eFortress.scale=0.3;
            eFortress.position=ccp(player.position.x,player.position.y-(player.contentSize.height*player.scale)/2-(eFortress.contentSize.height*eFortress.scale)/2);
            [self addChild:eFortress];
            
            enemyFortressLabel=[CCLabelBMFont labelWithString:
                        [NSString stringWithFormat:@"敵城破壊ポイント:%05d",enemyFortressAbility] fntFile:@"results.fnt"];
            enemyFortressLabel.scale=0.5;
            enemyFortressLabel.position=ccp(eFortress.position.x+(eFortress.contentSize.width*eFortress.scale)/2+(enemyFortressLabel.contentSize.width*enemyFortressLabel.scale)/2,eFortress.position.y);
            [self addChild:enemyFortressLabel];
            
            //----------
            CCSprite* pFortress=[CCSprite spriteWithSpriteFrame:
                                 [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"pFortress.png"]];
            pFortress.scale=0.3;
            pFortress.position=ccp(eFortress.position.x,eFortress.position.y-(eFortress.contentSize.height*player.scale)/2-(pFortress.contentSize.height*pFortress.scale)/2);
            [self addChild:pFortress];
            
            playerFortressLabel=[CCLabelBMFont labelWithString:
                        [NSString stringWithFormat:@"我城残存ポイント:%05d",playerFortressAbility] fntFile:@"results.fnt"];
            playerFortressLabel.scale=0.5;
            playerFortressLabel.position=ccp(pFortress.position.x+(pFortress.contentSize.width*pFortress.scale)/2+(playerFortressLabel.contentSize.width*playerFortressLabel.scale)/2,pFortress.position.y);
            [self addChild:playerFortressLabel];
            
            //victorySpr.visible=true;
            //victorySpr.position=ccp(winSize.width/2,winSize.height-victorySpr.contentSize.height/2);
            //[self addChild:victorySpr];
            
            //titleButton.position=ccp(0.5f,0.3f);
            
        }else{//敗北
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
            victorySpr.position=ccp(winSize.width/2,winSize.height/2-100);
            [self addChild:victorySpr];
            
            defeatSpr.position=ccp(winSize.width/2,winSize.height/2+100);
            defeatSpr.rotation=180;
            [self addChild:defeatSpr];
        }else{
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
                victorySpr.visible=true;
                victorySpr.position=ccp(winSize.width/2,winSize.height/2);
                [self addChild:victorySpr];
            }else{
                defeatSpr.visible=true;
                defeatSpr.position=ccp(winSize.width/2,winSize.height/2);
                [self addChild:defeatSpr];
            }
        }else{
            if([GameManager getHost]){
                defeatSpr.visible=true;
                defeatSpr.position=ccp(winSize.width/2,winSize.height/2);
                [self addChild:defeatSpr];
            }else{
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
        [self addChild:starG];
    }
    else if(cnt==300)
    {
        starG.scale=0.7;
        starG.position=ccp(winSize.width/2-100,winSize.height/2+100);
        if(rep>300){
            starG=[CCSprite spriteWithSpriteFrame:
                   [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"star_G.png"]];
            starG.position=ccp(winSize.width/2,winSize.height/2+130);
            starG.scale=3.0;
            [self addChild:starG];
        }else{
            [self schedule:@selector(score_Schedule:) interval:0.01 repeat:enemyDieCount delay:0];
        }
    }
    else if(cnt==600)
    {
        starG.scale=0.7;
        starG.position=ccp(winSize.width/2,winSize.height/2+130);
        if(rep>600){
            starG=[CCSprite spriteWithSpriteFrame:
                   [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"star_G.png"]];
            starG.position=ccp(winSize.width/2+100,winSize.height/2+100);
            starG.scale=3.0;
            [self addChild:starG];
        }else{
            [self schedule:@selector(score_Schedule:) interval:0.01 repeat:enemyDieCount delay:0];
        }
    }
    else if(cnt==900)
    {
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
            enemyDieLabel.string=[NSString stringWithFormat:@"たおした敵兵の数:%05d",enemyDieCount];
        }else{
            scoreNum++;
            [self schedule:@selector(score_Schedule:) interval:0.01 repeat:playerDieCount delay:0];
        }
    }
    else if(scoreNum==1)
    {
        if(playerDieCount>0){
            playerDieCount--;
            playerDieLabel.string=[NSString stringWithFormat:@"生残った我兵の数:%05d",playerDieCount];
        }else{
            scoreNum++;
            [self schedule:@selector(score_Schedule:) interval:0.001 repeat:enemyFortressAbility delay:0];
        }
    }
    else if(scoreNum==2)
    {
        if(enemyFortressAbility>0){
            enemyFortressAbility--;
            enemyFortressLabel.string=[NSString stringWithFormat:@"敵城破壊ポイント:%05d",enemyFortressAbility];
        }else{
            scoreNum++;
            [self schedule:@selector(score_Schedule:) interval:0.001 repeat:playerFortressAbility delay:0];
        }
    }
    else if(scoreNum==3)
    {
        if(playerFortressAbility>0){
            playerFortressAbility--;
            playerFortressLabel.string=[NSString stringWithFormat:@"我城残存ポイント:%05d",playerFortressAbility];
        }else{
            if(highScoreFlg){//ハイスコアなら
                highScore=[CCSprite spriteWithSpriteFrame:
                       [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"highscore.png"]];
                highScore.position=ccp(winSize.width/2,winSize.height/2);
                highScore.scale=3.0;
                [self addChild:highScore];
                cnt=0;
                [self schedule:@selector(high_Score_Schedule:) interval:0.01 repeat:200 delay:0];
            }
        }
    }
}

-(void)high_Score_Schedule:(CCTime)dt
{
    cnt++;
    highScore.scale-=0.01;
    highScore.rotation+=10;
    if(cnt==200){
        highScore.scale=0.8;
        highScore.position=ccp(winSize.width/2,winSize.height/2);
        highScore.rotation=-25;
    }
}

- (void)onTitleClicked:(id)sender
{
    // back to intro scene with transition
    [[CCDirector sharedDirector] replaceScene:[TitleScene scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];
}

-(void)onSelectClicked:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[SelectScene scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];
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
