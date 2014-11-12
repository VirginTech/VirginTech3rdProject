//
//  HelloWorldScene.m
//  VirginTech3rdProject
//
//  Created by VirginTech LLC. on 2014/10/19.
//  Copyright VirginTech LLC. 2014年. All rights reserved.
//
// -----------------------------------------------------------------------

#import "StageScene.h"
#import "CCDrawNode.h"
#import "TitleScene.h"
#import "GameManager.h"
#import "Fortress.h"
#import "Player.h"
#import "Enemy.h"

@implementation StageScene

CGSize winSize;
CCSprite* bgSpLayer;
CCScrollView* scrollView;
CGPoint worldLocation;

Fortress* playerFortress;
Fortress* enemyFortress;

Player* player;
NSMutableArray* playerArray;
bool createPlayerFlg;

Enemy* enemy;
NSMutableArray* enemyArray;
bool createEnemyFlg;

+ (StageScene *)scene
{
    return [[self alloc] init];
}

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    winSize=[[CCDirector sharedDirector]viewSize];
    
    // Enable touch handling on scene node
    self.userInteractionEnabled = YES;
    
    //初期化
    playerArray=[[NSMutableArray alloc]init];
    enemyArray=[[NSMutableArray alloc]init];
    createPlayerFlg=false;
    
    // Create a colored background (Dark Grey)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];
    [self addChild:background];
    
    //レベルに応じた画面の大きさ
    [GameManager setWorldSize:CGSizeMake(winSize.width, winSize.height)];
    
    UIImage *image = [UIImage imageNamed:@"bgLayer.png"];
    UIGraphicsBeginImageContext(CGSizeMake(winSize.width,[GameManager getWorldSize].height));
    [image drawInRect:CGRectMake(0, 0, winSize.width,[GameManager getWorldSize].height)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //スクロールビュー配置 z:0
    bgSpLayer=[CCSprite spriteWithCGImage:image.CGImage key:nil];
    scrollView=[[CCScrollView alloc]initWithContentNode:bgSpLayer];
    scrollView.horizontalScrollEnabled=NO;
    bgSpLayer.position=CGPointMake(0, 0);
    [self addChild:scrollView z:0];
    
    // Create a back button
    CCButton *backButton = [CCButton buttonWithTitle:@"[タイトル]" fontName:@"Verdana-Bold" fontSize:15.0f];
    backButton.positionType = CCPositionTypeNormalized;
    backButton.position = ccp(0.9f, 0.95f); // Top Right of screen
    [backButton setTarget:self selector:@selector(onBackClicked:)];
    [self addChild:backButton];

    // done
	return self;
}

- (void)dealloc
{
    // clean up code goes here
}

- (void)onEnter
{
    // always call super onEnter first
    [super onEnter];
    
    //我陣地ライン
    CCDrawNode* drawNode1=[CCDrawNode node];
    [drawNode1 drawSegmentFrom:ccp(0,[GameManager getWorldSize].height/5)
                                to:ccp([GameManager getWorldSize].width,[GameManager getWorldSize].height/5)
                                radius:0.5
                                color:[CCColor whiteColor]];
    [bgSpLayer addChild:drawNode1];
    
    //敵陣地ライン
    CCDrawNode* drawNode2=[CCDrawNode node];
    [drawNode2 drawSegmentFrom:ccp(0,[GameManager getWorldSize].height-[GameManager getWorldSize].height/5)
                                to:ccp([GameManager getWorldSize].width,[GameManager getWorldSize].height-[GameManager getWorldSize].height/5)
                                radius:0.5
                                color:[CCColor whiteColor]];
    [bgSpLayer addChild:drawNode2];

    //我城生成
    playerFortress=[Fortress createFortress:ccp([GameManager getWorldSize].width/2, 15) type:0];
    [bgSpLayer addChild:playerFortress];
    
    //敵城生成
    enemyFortress=[Fortress createFortress:ccp([GameManager getWorldSize].width/2,[GameManager getWorldSize].height-15) type:1];
    [bgSpLayer addChild:enemyFortress];
    
    //審判スケジュール開始
    [self schedule:@selector(judgement_Schedule:)interval:0.1];
    
}

- (void)onExit
{
    // always call super onExit last
    [super onExit];
}

-(void)judgement_Schedule:(CCTime)dt
{
    for(Player* _player in playerArray){
        if(_player.position.y>[GameManager getWorldSize].height-[GameManager getWorldSize].height/5){
            _player.targetPos=enemyFortress.position;
        }
    }

    for(Enemy* _enemy in enemyArray){
        if(_enemy.position.y<[GameManager getWorldSize].height/5){
            _enemy.targetPos=playerFortress.position;
        }
    }
}

UITouch* touches;
UIEvent* events;

-(void)create_Player_Schedule:(CCTime)dt
{
    if(touches.tapCount>0 && worldLocation.y<[GameManager getWorldSize].height/5){
        player=[Player createPlayer:worldLocation];
        [bgSpLayer addChild:player];
        [playerArray addObject:player];
        [self touchBegan:touches withEvent:events];

    }else{
        //通常停止
        createPlayerFlg=false;
        [self unschedule:@selector(create_Player_Schedule:)];
    }
}

-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    touches=touch;
    events=event;
    scrollView.verticalScrollEnabled=YES;
    
    CGPoint touchLocation = [touch locationInNode:self];
    
    float offsetY = bgSpLayer.contentSize.height - winSize.height - scrollView.scrollPosition.y;
    worldLocation.x = touchLocation.x + scrollView.scrollPosition.x;
    worldLocation.y = touchLocation.y + offsetY;
    
    //プレイヤー作成
    if(worldLocation.y<[GameManager getWorldSize].height/5){
        scrollView.verticalScrollEnabled=NO;
        if(!createPlayerFlg){
            //プレイヤー生成スケジュール開始
            [self schedule:@selector(create_Player_Schedule:)interval:0.05 repeat:CCTimerRepeatForever delay:0.15f];
            createPlayerFlg=true;
        }
    }else{
        //境界線超え停止
        if(createPlayerFlg){
            [self unschedule:@selector(create_Player_Schedule:)];
            createPlayerFlg=false;
        }
    }

    /*/敵作成
    if(worldLocation.y>[GameManager getWorldSize].height-[GameManager getWorldSize].height/5){
        enemy=[Enemy createEnemy:worldLocation];
        [bgSpLayer addChild:enemy];
        [enemyArray addObject:enemy];
    }*/
}

/*-(void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
}*/

-(void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    //チョンタッチ停止
    if(createPlayerFlg){
        createPlayerFlg=false;
        [self unschedule:@selector(create_Player_Schedule:)];
    }
}

- (void)onBackClicked:(id)sender
{
    // back to intro scene with transition
    [[CCDirector sharedDirector] replaceScene:[TitleScene scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];

}

@end
