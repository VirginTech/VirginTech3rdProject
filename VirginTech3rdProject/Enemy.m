//
//  Enemy.m
//  VirginTech3rdProject
//
//  Created by VirginTech LLC. on 2014/11/11.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "Enemy.h"
#import "GameManager.h"
#import "BasicMath.h"
#import "Player.h"
#import "Fortress.h"
#import "SoundManager.h"

@implementation Enemy

@synthesize targetObject;
@synthesize ability;
@synthesize nearEnemyCnt;
@synthesize stopFlg;
@synthesize mode;
@synthesize targetAngle;

/*Player* targetPlayer;
Fortress* targetFortress;

-(void)setTargetPlayer:(id)_player
{
    if(mode==3){
        targetPlayer=_player;
    }else if(mode==4){
        targetFortress=_player;
    }
}*/

-(void)move_Schedule:(CCTime)dt
{
    if([GameManager getPause]){
        return;
    }
    
    nextPos=CGPointMake(self.position.x+velocity*cosf(targetAngle),self.position.y+velocity*sinf(targetAngle));
    self.rotation=[BasicMath getAngle_To_Degree:self.position ePos:nextPos];
    
    if(!stopFlg){
        self.position=nextPos;
    }
    
    if(mode==1){//回避タイム測定
        time1++;
        if(time1>200)mode=0;//回避解除
    }else{
        time1=0;
    }
    
    if(mode==2){//追跡タイム測定
        time2++;
        if(time2>500)mode=0;//追跡解除
    }else{
        time2=0;
    }

}

-(void)animation_Schedule:(CCTime)dt
{
    animeCnt++;
    
    if(![GameManager getPause]){
        if(self.rotationalSkewX==self.rotationalSkewY){
            
            if(self.rotation<=22.5){
                if(animeCnt%2==0){
                    [self setSpriteFrame:[frameArray objectAtIndex:0]];
                }else{
                    if(mode==3 || mode==4){
                        [self setSpriteFrame:[frameArray objectAtIndex:2]];
                        [self attackDamage];
                    }else{
                        [self setSpriteFrame:[frameArray objectAtIndex:1]];
                    }
                }
            }else if(self.rotation<=67.5){
                if(animeCnt%2==0){
                    [self setSpriteFrame:[frameArray objectAtIndex:3]];
                }else{
                    if(mode==3 || mode==4){
                        [self setSpriteFrame:[frameArray objectAtIndex:5]];
                        [self attackDamage];
                    }else{
                        [self setSpriteFrame:[frameArray objectAtIndex:4]];
                    }
                }
            }else if(self.rotation<=112.5){
                if(animeCnt%2==0){
                    [self setSpriteFrame:[frameArray objectAtIndex:6]];
                }else{
                    if(mode==3 || mode==4){
                        [self setSpriteFrame:[frameArray objectAtIndex:8]];
                        [self attackDamage];
                    }else{
                        [self setSpriteFrame:[frameArray objectAtIndex:7]];
                    }
                }
            }else if(self.rotation<=157.5){
                if(animeCnt%2==0){
                    [self setSpriteFrame:[frameArray objectAtIndex:9]];
                }else{
                    if(mode==3 || mode==4){
                        [self setSpriteFrame:[frameArray objectAtIndex:11]];
                        [self attackDamage];
                    }else{
                        [self setSpriteFrame:[frameArray objectAtIndex:10]];
                    }
                }
            }else if(self.rotation<=202.5){
                if(animeCnt%2==0){
                    [self setSpriteFrame:[frameArray objectAtIndex:12]];
                }else{
                    if(mode==3 || mode==4){
                        [self setSpriteFrame:[frameArray objectAtIndex:14]];
                        [self attackDamage];
                    }else{
                        [self setSpriteFrame:[frameArray objectAtIndex:13]];
                    }
                }
            }else if(self.rotation<=247.5){
                if(animeCnt%2==0){
                    [self setSpriteFrame:[frameArray objectAtIndex:15]];
                }else{
                    if(mode==3 || mode==4){
                        [self setSpriteFrame:[frameArray objectAtIndex:17]];
                        [self attackDamage];
                    }else{
                        [self setSpriteFrame:[frameArray objectAtIndex:16]];
                    }
                }
            }else if(self.rotation<=292.5){
                if(animeCnt%2==0){
                    [self setSpriteFrame:[frameArray objectAtIndex:18]];
                }else{
                    if(mode==3 || mode==4){
                        [self setSpriteFrame:[frameArray objectAtIndex:20]];
                        [self attackDamage];
                    }else{
                        [self setSpriteFrame:[frameArray objectAtIndex:19]];
                    }
                }
            }else if(self.rotation<=337.5){
                if(animeCnt%2==0){
                    [self setSpriteFrame:[frameArray objectAtIndex:21]];
                }else{
                    if(mode==3 || mode==4){
                        [self setSpriteFrame:[frameArray objectAtIndex:23]];
                        [self attackDamage];
                    }else{
                        [self setSpriteFrame:[frameArray objectAtIndex:22]];
                    }
                }
            }else if(self.rotation<=360.0){
                if(animeCnt%2==0){
                    [self setSpriteFrame:[frameArray objectAtIndex:0]];
                }else{
                    if(mode==3 || mode==4){
                        [self setSpriteFrame:[frameArray objectAtIndex:2]];
                        [self attackDamage];
                    }else{
                        [self setSpriteFrame:[frameArray objectAtIndex:1]];
                    }
                }
            }
            
        }
    }
    if(animeCnt>=20)animeCnt=0;
}

-(void)status_Schedule:(CCTime)dt
{
    //ライフゲージ
    if(self.rotationalSkewX==self.rotationalSkewY){
        lifeGauge1.rotation=-self.rotation;//常に０度を維持
    }
    nowRatio=(100/maxLife)*ability;
    lifeGauge2.scaleX=nowRatio*0.01;
    lifeGauge2.position=CGPointMake((nowRatio*0.01)*(lifeGauge1.contentSize.width/2), lifeGauge1.contentSize.height/2);

    //ダメージ表示
    //self.opacity=nowRatio*0.01;
    
    //デバッグ用
    //modeLabel.string=[NSString stringWithFormat:@"M=%d",mode];
    //energyLabel.string=[NSString stringWithFormat:@"%d",ability];
}

-(void)attackDamage
{
    if(mode==3){//敵攻撃
        //エフェクトサウンド
        if(animeCnt%5==0){
            [SoundManager battle_Effect];
        }
        Player* targetPlayer=targetObject;
        targetPlayer.ability--;
        if(targetPlayer.ability<=0){
            mode=0;//敵を倒したらモード0
        }
    }else if(mode==4){//要塞攻撃
        //エフェクトサウンド
        if(animeCnt%5==0){
            [SoundManager attack_Effect];
        }
        Fortress* targetFortress=targetObject;
        targetFortress.ability--;
        [targetFortress start_Animation];
    }
}

-(id)initWithEnemy:(CGPoint)pos
{
    frameArray=[[NSMutableArray alloc]init];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache]removeSpriteFrames];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"enemy_default.plist"];
    
    for(int i=0;i<8;i++){
        for(int j=0;j<3;j++){
            [frameArray addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"%d%d.png",i,j]]];
        }
    }
    
    if(self=[super initWithSpriteFrame:[frameArray objectAtIndex:12]])
    {
        self.position=pos;
        self.scale=0.33;
        
        if([GameManager getMatchMode]==0){//シングル戦
            ability=(([GameManager getStageLevel]-1)/10+1)*5;
            NSLog(@"Ability=%d",ability);
        }else{
            ability=5;
        }
        mode=0;//通常モード
        stopFlg=false;
        velocity=0.2;
        animeCnt=0;
        
        nextPos=ccp(self.position.x,self.position.y-velocity);
        targetAngle=[BasicMath getAngle_To_Radian:self.position ePos:nextPos];
        
        //ライフ初期値
        maxLife=ability;
        
        //体力ゲージ描画
        lifeGauge1=[CCSprite spriteWithSpriteFrame:
                    [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"lifegauge1.png"]];
        lifeGauge1.position=CGPointMake(self.contentSize.width/2, self.contentSize.height/2 - 50);
        //lifeGauge1.scale=0.5;
        [self addChild:lifeGauge1];
        
        lifeGauge2=[CCSprite spriteWithSpriteFrame:
                    [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"lifegauge2.png"]];
        nowRatio=(100/maxLife)*ability;
        lifeGauge2.scaleX=nowRatio*0.01;
        lifeGauge2.position=CGPointMake((nowRatio*0.01)*(lifeGauge1.contentSize.width/2), lifeGauge1.contentSize.height/2);
        //lifeGauge2.scale=0.5;
        [lifeGauge1 addChild:lifeGauge2];
        
        [self schedule:@selector(move_Schedule:)interval:0.01];
        [self schedule:@selector(status_Schedule:)interval:0.1];
        
        if([GameManager getMatchMode]==0){//シングル戦
            float timeLag=arc4random()%10 * 0.1;
            [self schedule:@selector(animation_Schedule:)interval:0.2 repeat:CCTimerRepeatForever delay:timeLag];
        }else{//2人モード
            [self schedule:@selector(animation_Schedule:)interval:0.2];
        }
        
        /*/デバッグ用ラベル
        modeLabel=[CCLabelTTF labelWithString:
                   [NSString stringWithFormat:@"M=%d",mode]fontName:@"Verdana-Bold" fontSize:10];
        modeLabel.position=ccp(self.contentSize.width/2,self.contentSize.height/2-20);
        modeLabel.color=[CCColor whiteColor];
        [self addChild:modeLabel];
        
        energyLabel=[CCLabelTTF labelWithString:
                     [NSString stringWithFormat:@"%d",ability]fontName:@"Verdana-Bold" fontSize:15];
        energyLabel.position=ccp(self.contentSize.width/2,self.contentSize.height/2);
        energyLabel.color=[CCColor whiteColor];
        [self addChild:energyLabel];*/
        
    }
    return self;
}

+(id)createEnemy:(CGPoint)pos
{
    return [[self alloc] initWithEnemy:pos];
}

@end
