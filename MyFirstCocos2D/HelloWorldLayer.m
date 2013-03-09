//
//  HelloWorldLayer.m
//  MyFirstCocos2D
//
//  Created by Hui Ken on 28/1/13.
//  Copyright Hui Ken 2013. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#import "SimpleAudioEngine.h"
#import "GameOverLayer.h"

#import "Monster.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (void)addMonster {
//    CCSprite *monster = [CCSprite spriteWithFile:@"monster.png"];
    
    Monster *monster = nil;
    
    if (arc4random() % 2 == 0) {
        monster = [WeakAndFastMonster monster];
    }
    else {
        monster = [StrongAndSlowMonster monster];
    }
    
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    // Determine where to spawn the monster alone the Y axis
    int minY = monster.contentSize.height / 2;
    int maxY = winSize.height - monster.contentSize.height / 2;
    int rangeY = maxY - minY;
    int actualY = (arc4random() % rangeY) + minY;
    
    // Create the monster slightly off-screen along the right edge,
    // and along a random position along the Y axis as calculated above
    monster.position = ccp(winSize.width + monster.contentSize.width / 2, actualY);
    monster.tag = 1;
    [_monsters addObject:monster];
    [self addChild:monster];
    
    // Determine speed of the monster
    int minDuration = monster.minMoveDuration;
    int maxDuration = monster.maxMoveDuration;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    // Create the action
    CCMoveTo *actionMove = [CCMoveTo actionWithDuration:actualDuration position:ccp(-monster.contentSize.width/2, actualY)];
    
    CCCallBlockN *actionMoveDone = [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [node removeFromParentAndCleanup:YES];
        [_monsters removeObject:node];
        
//        CCScene *gameOverScene = [GameOverLayer sceneWithWon:NO];
//        [[CCDirector sharedDirector] replaceScene:gameOverScene];
    }];
                             
    [monster runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
}

- (id)init
{
    if ((self = [super initWithColor:ccc4(255, 255, 255, 255)])) {
        CGSize winSize = [CCDirector sharedDirector].winSize;
        _player = [CCSprite spriteWithFile:@"player2.png"];
        _player.position = ccp(_player.contentSize.width/2, winSize.height/2);
        [self addChild:_player];
        [self schedule:@selector(gameLogic:) interval:1.0];
        [self schedule:@selector(update:)];
        
        self.touchEnabled = YES;
        
        // Init the Object Arrays
        _monsters = [[NSMutableArray alloc] init];
        _projectiles = [[NSMutableArray alloc] init];
        
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"background-music-aac.caf"];
        

    }
    
    return self;
}//end init

- (void)gameLogic:(ccTime)dt {
    [self addMonster];
}

- (void)update:(ccTime)dt {
    NSMutableArray *projectilesToDelete = [[NSMutableArray alloc] init];
    for(CCSprite *projectile in _projectiles) {
        BOOL monsterHit = false;
        NSMutableArray *monsterToDelete = [[NSMutableArray alloc] init];
        
        for (CCSprite *monster in _monsters ) {
            if (CGRectIntersectsRect(projectile.boundingBox, monster.boundingBox)) {
                
                monsterHit = true;
                Monster *myMonster = (Monster*)monster;
                myMonster.hp--;
                
                if (myMonster.hp <= 0) {
                    [monsterToDelete addObject:monster];
                }
            }// end if
        }// end for
        
        for (CCSprite *monster in monsterToDelete) {
            [_monsters removeObject:monster];
            [self removeChild:monster cleanup:YES];
            
            _monsterDestroyed++;
            
            if (_monsterDestroyed > 30) {
                CCScene *gameOverScene = [GameOverLayer sceneWithWon:YES];
                [[CCDirector sharedDirector] replaceScene:gameOverScene];
            }
            
        }// end for
        
//        if (monsterToDelete.count > 0) {
        if (monsterHit) {
            [projectilesToDelete addObject:projectile];
            [[SimpleAudioEngine sharedEngine] playEffect:@"explosion.caf"];
        }
//      }
        [monsterToDelete release];
    }
    
    for (CCSprite *projectile in projectilesToDelete) {
        [_projectiles removeObject:projectile];
        [self removeChild:projectile cleanup:YES];
    }
    
    [projectilesToDelete release];
}

#pragma mark -
#pragma mark Touch Method

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if(_nextProjectile != nil) return;
    
    // Choose one of the touches to work with
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
//    CGPoint location = [self convertTouchToNodeSpace:touch];
    
    // Set up initial location of projectile
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    _nextProjectile = [[CCSprite spriteWithFile:@"projectile2.png"] retain];
    _nextProjectile.position = ccp(20, winSize.height / 2);
    
    // Determine offset of location to projectile
    int offX = location.x - _nextProjectile.position.x;
    int offY = location.y - _nextProjectile.position.y;
    
    // Bail out if we are shooting down or backwards
    if (offX <=0) return;
    
    // Play a sound!
    [[SimpleAudioEngine sharedEngine] playEffect:@"pew-pew-lei.caf"];
    
    // Determine where we wish to shoot the projectile to
    int realX = winSize.width + (_nextProjectile.contentSize.width/2);
    float ratio = (float) offY  / (float) offX;
    int realY = (realX * ratio) + _nextProjectile.position.y;
    CGPoint realDest = ccp(realX ,realY);
    
    // Determine the length of how far we're shooting
    int offRealX = realX - _nextProjectile.position.x;
    int offRealY = realY - _nextProjectile.position.y;
    float length = sqrt((offRealX *offRealX)+(offRealY*offRealY));
    float velocity = 480 /1; //480 pixels/1sec
    float realMoveDuration = length / velocity;
    
    // Determine angle to face
    // Determine angle to face
    float angleRadians = atanf((float)offRealY / (float)offRealX);
    float angleDegrees = CC_RADIANS_TO_DEGREES(angleRadians);
    float cocosAngle = -1 * angleDegrees;
    float rotateSpeed = 0.5 / M_PI; // Would take 0.5 seconds to rotate 0.5 radians, or half a circle
    float rotateDuration = fabs(angleRadians * rotateSpeed);
    
    [_player runAction:
     [CCSequence actions:
      [CCRotateTo actionWithDuration:rotateDuration angle:cocosAngle],
      [CCCallFunc actionWithTarget:self selector:@selector(finishShoot)],
      nil]];
    
    [_nextProjectile runAction:[CCSequence actions:
                                [CCMoveTo actionWithDuration:realMoveDuration position:realDest],
                                [CCCallFuncN actionWithTarget:self selector:@selector(spriteMoveFinished:)],
                                nil]];
    
    // Add to projectiles array
    
    _nextProjectile.tag = 2;
    
    return;
//    
//    CCSprite *projectile = [CCSprite spriteWithFile:@"projectile2.png"];
//    projectile.position = ccp(20, winSize.height / 2);
//    
//    // Determine offset of location to projectile
//    CGPoint offset = ccpSub(location, projectile.position);
//    
//    // Bail out if you are shooting down or backwards
//    if (offset.x <=0) return;
//    
//    projectile.tag = 2;
//    [_projectiles addObject:projectile];
//    
//    [self addChild:projectile];
//    
//    int realX = winSize.width + (projectile.contentSize.width/2);
//    float ratio = (float) offset.y / (float) offset.x;
//    int realY = (realX * ratio) + projectile.position.y;
//    CGPoint realDest = ccp(realX, realY);
//    
//    // Determine the length of how far you're shooting
//    int offRealX = realX - projectile.position.x;
//    int offRealY = realY - projectile.position.y;
//    float length = sqrtf((offRealX * offRealX) + (offRealY * offRealY));
//    float velocity = 480/1; // 480 pixels / 1 sec
//    float realMoveDuration = length / velocity;
//    
//    // Determine angle to face
//    float angleRadians = atanf((float)offRealY / (float)offRealX);
//    float angleDegrees = CC_RADIANS_TO_DEGREES(angleRadians);
//    float cocosAngle = -1 * angleDegrees;
//    _player.rotation = cocosAngle;
//    
//    // Movie projectile to actual endpoint
//    [projectile runAction:
//     [CCSequence actions:
//      [CCMoveTo actionWithDuration:realMoveDuration position:realDest],
//      [CCCallBlockN actionWithBlock:^(CCNode *node) {
//         [node removeFromParentAndCleanup:YES];
//         [_projectiles removeObject:node];
//         }],
//      nil]];
    

    
}

- (void)finishShoot {
    
    // Ok to add now - we've finished rotation !
    [self addChild:_nextProjectile];
    [_projectiles addObject:_nextProjectile];
    
    [_nextProjectile release];
    _nextProjectile = nil;
}

- (void)spriteMoveFinished:(CCSprite*)sprite {
    [sprite removeFromParentAndCleanup:YES];
    [_projectiles removeObject:sprite];
}


// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
    [_monsters release];
    _monsters = nil;
    [_projectiles release];
    _projectiles = nil;
    
    [_player release];
    _player = nil;
    
	// don't forget to call "super dealloc"
	[super dealloc];
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}
@end



// on "init" you need to initialize your instance
/*
 -(id) init
 {
 // always call "super" init
 // Apple recommends to re-assign "self" with the "super's" return value
 if( (self=[super init]) ) {
 
 // create and initialize a Label
 CCLabelTTF *label = [CCLabelTTF labelWithString:@"Hello World" fontName:@"Marker Felt" fontSize:64];
 
 // ask director for the window size
 CGSize size = [[CCDirector sharedDirector] winSize];
 
 // position the label on the center of the screen
 label.position =  ccp( size.width /2 , size.height/2 );
 
 // add the label as a child to this Layer
 [self addChild: label];
 
 
 
 //
 // Leaderboards and Achievements
 //
 
 // Default font size will be 28 points.
 [CCMenuItemFont setFontSize:28];
 
 // Achievement Menu Item using blocks
 CCMenuItem *itemAchievement = [CCMenuItemFont itemWithString:@"Achievements" block:^(id sender) {
 
 
 GKAchievementViewController *achievementViewController = [[GKAchievementViewController alloc] init];
 achievementViewController.achievementDelegate = self;
 
 AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
 
 [[app navController] presentModalViewController:achievementViewController animated:YES];
 
 [achievementViewController release];
 }
 ];
 
 // Leaderboard Menu Item using blocks
 CCMenuItem *itemLeaderboard = [CCMenuItemFont itemWithString:@"Leaderboard" block:^(id sender) {
 
 
 GKLeaderboardViewController *leaderboardViewController = [[GKLeaderboardViewController alloc] init];
 leaderboardViewController.leaderboardDelegate = self;
 
 AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
 
 [[app navController] presentModalViewController:leaderboardViewController animated:YES];
 
 [leaderboardViewController release];
 }
 ];
 
 CCMenu *menu = [CCMenu menuWithItems:itemAchievement, itemLeaderboard, nil];
 
 [menu alignItemsHorizontallyWithPadding:20];
 [menu setPosition:ccp( size.width/2, size.height/2 - 50)];
 
 // Add the menu to the layer
 [self addChild:menu];
 
 }
 return self;
 }*/

