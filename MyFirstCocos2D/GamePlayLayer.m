//
//  GamePlayLayer.m
//  MyFirstCocos2D
//
//  Created by BabyKen on 2/3/13.
//  Copyright 2013 Hui Ken. All rights reserved.
//

#import "GamePlayLayer.h"
#import "Monster.h"

#import "SimpleAudioEngine.h"
#import "GameOverLayer.h"

@implementation GamePlayLayer

/*======= scene =======*/
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GamePlayLayer *layer = [GamePlayLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

/*======= init *=======*/
- (id)init
{
    if ((self = [super initWithColor:ccc4(255, 255, 255, 255)])) {
        
        // Add background image
        CGSize winSize = [CCDirector sharedDirector].winSize;
        CCSprite *bg = [[CCSprite alloc] initWithFile:@"gamePlayBg.png"];
        bg.position = ccp(winSize.width / 2, winSize.height / 2);
        [self addChild:bg];
        
        
        // Create the player
        _player = [Player player];
        [self addChild:_player];
        
        
        // Create the managers
        _bulletsMgr = [[BulletsManager alloc] initWithPlayer:_player];
        _monstersMgr = [[MonstersManager alloc] init];
        _monstersMgr.delegate = self;
        _levelMgr = [[LevelManager alloc] init];
        

        // Pop up level title
        [self updateLevelTitle];
        
        // Setup player heart
        [self setupPlayerHeart];
        
        // enable layer detect touch
        self.touchEnabled = YES;
        
        // Game Update Methods
        [self schedule:@selector(spawnBullet:) interval:0.2];
        [self schedule:@selector(spawnMonster:) interval:0.5];
        [self schedule:@selector(update:)];

        [[SimpleAudioEngine sharedEngine] playEffect:@"levelStart.m4a"];
        
        // Player background sound
//        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"StartBackgroundMusic.m4a"];
    }
    
    return self;
}//end init

/*======= dealloc =======*/
- (void)dealloc
{
    [_bulletsMgr release];
    _bulletsMgr = nil;
    
    [_monstersMgr release];
    _monstersMgr = nil;
    
    [_levelMgr release];
    _levelMgr = nil;
    
    [_levelTitle release];
    _levelTitle = nil;
    
//    [_player release];
    _player = nil;
    
    [super dealloc];
}

/*======== Add Title =======*/
- (void)updateLevelTitle
{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    // Add / Update Level Title
    _levelTitle = [[CCSprite alloc] initWithFile:[NSString stringWithFormat:@"level%i.png", _levelMgr.level]];
    _levelTitle.position = ccp(winSize.width / 2, winSize.height / 2);
    [self addChild:_levelTitle];

    // Create the moving action
    CCFadeOut *actionFadeOut = [CCFadeOut actionWithDuration:1.5];
    
    CCCallBlockN *actionFadeOutDone = [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [node removeFromParentAndCleanup:YES];
        _levelTitle = nil;
    }];
    
    [_levelTitle runAction:[CCSequence actions:actionFadeOut, actionFadeOutDone, nil]];

}

/*======= Player Heart Sprite setup =======*/
- (void)setupPlayerHeart
{
    _playerHeartSprite = [[NSMutableArray alloc] init];
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    for (int i=0; i<_player.lifes; i++) {
        
        // Position the Heart at top left corner
        CCSprite *heart = [[CCSprite alloc] initWithFile:@"heart.png"];
        heart.position = ccp(heart.contentSize.width /2 + heart.contentSize.width * i, winSize.height - heart.contentSize.height /2);
        
        [_playerHeartSprite addObject:heart];
        [self addChild:heart];
        
        [heart release];
        heart = nil;
    }
}

#pragma mark -
#pragma mark Game Update methods

/*======= Spawn Monster Scheduler ========*/
- (void)spawnMonster:(ccTime)dt
{
    CCSprite *monster = [_monstersMgr spawnMonster];
    
    // if there is space for a new monster
    if (monster) {
        [self addChild:monster];
    }
    
    monster = nil;
}

/*======= Spawn Bullet Scheduler =======*/ 
- (void)spawnBullet:(ccTime)dt
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"shoot.m4a"];
    [self addChild:[_bulletsMgr spawnBullet]];
}

/*======= Scheduler for bullet/Monster collision detection =======*/
- (void)update:(ccTime)dt {
    
    NSMutableArray *bulletsToDelete = [[NSMutableArray alloc] init];
    for(CCSprite *bullet in _bulletsMgr.bullets) {
        
        // Assume bullet hit nothing at starting
        
        BOOL monsterHit = false;
        NSMutableArray *monsterToDelete = [[NSMutableArray alloc] init];
        
        
        for (CCSprite *monster in _monstersMgr.monsters ) {
            
            // AABB collision detection
            
            if (CGRectIntersectsRect(bullet.boundingBox, monster.boundingBox)) {
                
                // Hit a Monster
            
                monsterHit = true;
                Monster *hitMonster = (Monster*)monster;
                hitMonster.hp--;
                
                // Reduce monster life
                
                if (hitMonster.hp <= 0) {
                    [monsterToDelete addObject:monster];
                }
            }// end if
        }// end for
        
        
        // If a monster is dead, remove it
        
        for (CCSprite *monster in monsterToDelete) {
            
            CCSprite *monsterDead = [[[CCSprite alloc] initWithFile:@"monsterDead.png"] autorelease];
            monsterDead.position = monster.position;
            [self addChild:monsterDead];
            
            
            // Create the moving action
            CCFadeOut *actionFadeOut = [CCFadeOut actionWithDuration:1.0];
            
            CCCallBlockN *actionFadeOutDone = [CCCallBlockN actionWithBlock:^(CCNode *node) {
                [node removeFromParentAndCleanup:YES];
                node = nil;
            }];
            
            [monsterDead runAction:[CCSequence actions:actionFadeOut, actionFadeOutDone, nil]];
            
            
            
            [_monstersMgr removeMonster:monster];
            [self removeChild:monster cleanup:YES];
        }// end for
        
        // Add the number of monster killed
        
        [_levelMgr addMonsterKilled:monsterToDelete.count];
        
        
        // Remove the collided bullet
        if (monsterHit) {
            [bulletsToDelete addObject:bullet];
            [[SimpleAudioEngine sharedEngine] playEffect:@"monsterDie.m4a"];
        }
        
        [monsterToDelete release];
    }//end for
    
    // Remove the collided bullet
    for (CCSprite *bullet in bulletsToDelete) {
        [_bulletsMgr.bullets removeObject:bullet];
        [self removeChild:bullet cleanup:YES];
    }
    [bulletsToDelete release];
    
    // Determine prompt to next level or win the game
    
    if (_levelMgr.level >=3 ) {
        [self unscheduleAllSelectors];
        
        // Win the Game
        NSLog(@"You win");
        CCScene *gameOverScene = [GameOverLayer sceneWithWon:YES];
        [[CCDirector sharedDirector] replaceScene:gameOverScene];
    
    }
    else if(_levelMgr.promptToNextLevel){
        // Go to Next Level
        
        [[SimpleAudioEngine sharedEngine] playEffect:@"levelStart.m4a"];
        
        // Stop spawning monsters and bullets
        
        [self unscheduleAllSelectors];
        
        
        // Clean Up screen
        
        for (CCSprite *bullet in _bulletsMgr.bullets) {
            [self removeChild:bullet cleanup:YES];
            CCLOG(@"remove bullet");
        }
        
        [_bulletsMgr.bullets removeAllObjects];
        
        for (CCSprite *monster in _monstersMgr.monsters) {
            [self removeChild:monster cleanup:YES];
            CCLOG(@"Next Level : remove monster");
        }
        
        [_monstersMgr.monsters removeAllObjects];
        
        CCLOG(@"Next Level  : %i", _levelMgr.level);
        _monstersMgr.totalMonstersNumber = _levelMgr.totalMonsterShouldSpawn;
        _monstersMgr.monsterLevel = _levelMgr.monsterLevel;
        
        
        
        // Restart Game Update Methods
        
        [self schedule:@selector(spawnBullet:) interval:0.2];
        [self schedule:@selector(spawnMonster:) interval:0.5];
        [self schedule:@selector(update:)];
        
        // Pop up level title
        [self updateLevelTitle];
    }

}

#pragma mark -
#pragma mark Touch Methods

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Choose one of the touches to work with
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    // Store the Y position for moved displacement calculation
    lastYPosition = location.y;
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Choose one of the touches to work with
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    CGSize winSize = [CCDirector sharedDirector].winSize;
    

    
    // Calculate the moved distance
    CGFloat movedYDistance = location.y - lastYPosition;
    CGFloat finalYPosition = _player.position.y + movedYDistance;
    
//    CCLOG(@"moveddistance : %0.2f", movedYDistance);
//    CCLOG(@"player.position.y + movedYDistance : %0.2f", _player.position.y + movedYDistance);
    
    // Bound the player so it would not move out of the screen
    if (_player.position.y + movedYDistance >= winSize.height - _player.contentSize.height /2) {
        finalYPosition = winSize.height - _player.contentSize.height /2;
    }
    else if (_player.position.y + movedYDistance <= _player.contentSize.height /2){
        finalYPosition = _player.contentSize.height / 2;
    }
    
    // Update the player position
    _player.position = ccp(_player.position.x, finalYPosition);
    
    // Update the last Y value
    lastYPosition = location.y;
}

#pragma mark -
#pragma mark Monsters Manager Delegate

- (void)monsterFinishMove
{
    
    [self removeChild:_playerHeartSprite[_player.lifes - 1]];
    [_playerHeartSprite removeLastObject];
    
    _player.lifes--;
    
    if (_player.lifes <= 0) {
        // Lose the Game
        
        [self unscheduleAllSelectors];
        
        NSLog(@"you lose");
        CCScene *gameOverScene = [GameOverLayer sceneWithWon:NO];
        [[CCDirector sharedDirector] replaceScene:gameOverScene];
    }
}

@end
