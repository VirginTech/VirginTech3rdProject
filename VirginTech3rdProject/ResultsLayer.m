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

@implementation ResultsLayer

CGSize winSize;

CCSprite* victorySpr;
CCSprite* defeatSpr;

CCSprite* starB;
CCSprite* starG;
int cnt;
int rep;

CCLabelTTF* enemyDieLabel;
CCLabelTTF* playerDieLabel;
CCLabelTTF* enemyFortressLabel;
CCLabelTTF* playerFortressLabel;


+ (ResultsLayer *)scene
{
    return [[self alloc] init];
}

- (id)initWithWinner:(bool)flg
                            stars:(int)stars
                            playerDie:(int)playerDieCount
                            enemyDie:(int)enemyDieCount
                            playerFortress:(int)playerFortressAbility
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    self.userInteractionEnabled = YES;
    winSize=[[CCDirector sharedDirector]viewSize];
    
    //初期化
    cnt=0;
    rep=stars*300;
    
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
            enemyDieLabel=[CCLabelTTF labelWithString:
                        [NSString stringWithFormat:@"倒した敵兵の数:%05d",enemyDieCount] fontName:@"Verdana-Bold" fontSize:15];
            enemyDieLabel.position=ccp(winSize.width/2,winSize.height/2+30);
            [self addChild:enemyDieLabel];
            
            playerDieLabel=[CCLabelTTF labelWithString:
                        [NSString stringWithFormat:@"生残った我兵の数:%05d",
                                                [InitObjManager NumPlayerMax:[GameManager getStageLevel]]-playerDieCount]
                                                fontName:@"Verdana-Bold" fontSize:15];
            playerDieLabel.position=ccp(winSize.width/2,winSize.height/2+5);
            [self addChild:playerDieLabel];
            
            enemyFortressLabel=[CCLabelTTF labelWithString:
                        [NSString stringWithFormat:@"敵城破壊ポイント:%05d",500] fontName:@"Verdana-Bold" fontSize:15];
            enemyFortressLabel.position=ccp(winSize.width/2,winSize.height/2-20);
            [self addChild:enemyFortressLabel];
            
            playerFortressLabel=[CCLabelTTF labelWithString:
                        [NSString stringWithFormat:@"我城残存ポイント:%05d",playerFortressAbility] fontName:@"Verdana-Bold" fontSize:15];
            playerFortressLabel.position=ccp(winSize.width/2,winSize.height/2-45);
            [self addChild:playerFortressLabel];
            
            victorySpr.visible=true;
            victorySpr.position=ccp(winSize.width/2,winSize.height-victorySpr.contentSize.height/2);
            [self addChild:victorySpr];
            
            titleButton.position=ccp(0.5f,0.2f);
            
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
            victorySpr.position=ccp(winSize.width/2,winSize.height/2-50);
            [self addChild:victorySpr];
            
            defeatSpr.position=ccp(winSize.width/2,winSize.height/2+50);
            defeatSpr.rotation=180;
            [self addChild:defeatSpr];
        }else{
            defeatSpr.position=ccp(winSize.width/2,winSize.height/2-50);
            [self addChild:defeatSpr];
            
            victorySpr.position=ccp(winSize.width/2,winSize.height/2+50);
            victorySpr.rotation=180;
            [self addChild:victorySpr];
        }
        
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

    if(cnt==1){
        starG=[CCSprite spriteWithSpriteFrame:
               [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"star_G.png"]];
        starG.position=ccp(winSize.width/2-100,winSize.height/2+100);
        starG.scale=3.0;
        [self addChild:starG];
    }
    else if(cnt==300){
        starG.scale=0.7;
        starG.position=ccp(winSize.width/2-100,winSize.height/2+100);
        if(rep>300){
            starG=[CCSprite spriteWithSpriteFrame:
                   [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"star_G.png"]];
            starG.position=ccp(winSize.width/2,winSize.height/2+130);
            starG.scale=3.0;
            [self addChild:starG];
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
        }
    }
    else if(cnt==900)
    {
        starG.scale=0.7;
        starG.position=ccp(winSize.width/2+100,winSize.height/2+100);
    }
    else
    {
        starG.scale-=0.01;
    }
}

- (void)onTitleClicked:(id)sender
{
    // back to intro scene with transition
    [[CCDirector sharedDirector] replaceScene:[TitleScene scene]
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
