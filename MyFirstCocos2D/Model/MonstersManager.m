//
//  MonstersManager.m
//  Created by Ken Hui on 2/3/13
//

#import "MonstersManager.h"

#import "Monster.h"

@implementation MonstersManager
@synthesize monsters = _monsters;
@synthesize totalMonstersNumber = _totalMonstersNumber;
@synthesize monsterLevel = _monsterLevel;
@synthesize delegate = _delegate;

/*======= Init =======*/
- (id) init
{
    self = [super init];
    if (self) {
        self.monsters = [[NSMutableArray alloc] init];
        _totalMonstersNumber = 10;
        _monsterLevel = 1;
    }
    
    return self;
}

/*======= dealloc =======*/
- (void)dealloc
{
    [_monsters release];
    _monsters = nil;
    [super dealloc];
}

/*======= Spawn Monster =======*/
- (CCSprite*) spawnMonster
{
    // Control the total number of monster on the screen
    
    if (_monsters.count >= _totalMonstersNumber) {
        return nil;
    }
    
    
    // Init a type of monster
    
    Monster *monster = nil;
    
    if (arc4random() % 2 == 0) {
        monster = [WeakAndFastMonster monster];
    }
    else {
        monster = [StrongAndSlowMonster monster];
    }
    
    
    // Determine where to spawn the monster alone the Y axis
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    int minY = monster.contentSize.height / 2;
    int maxY = winSize.height - monster.contentSize.height / 2;
    int rangeY = maxY - minY;
    int actualY = (arc4random() % rangeY) + minY;
    
    
    // Create the monster slightly off-screen along the right edge,
    // and along a random position along the Y axis as calculated above
    
    monster.position = ccp(winSize.width + monster.contentSize.width / 2, actualY);
    monster.tag = 1;
    [_monsters addObject:monster];
    
    
    // Determine speed of the monster
    
    int minDuration = monster.minMoveDuration;
    int maxDuration = monster.maxMoveDuration;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;

    
    // Create the moving action
    CCMoveTo *actionMove = [CCMoveTo actionWithDuration:actualDuration * (1.0/_monsterLevel) position:ccp(-monster.contentSize.width/2, actualY)];
    
    
    CCCallBlockN *actionMoveDone = [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [node removeFromParentAndCleanup:YES];
        [self removeMonster:(CCSprite*)node];
        [_delegate monsterFinishMove];
    }];
    
    [monster runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
    
    return monster;
}

/*======= Remove Monster =======*/
- (void)removeMonster:(CCSprite*)monsterToRemove
{
    [_monsters removeObject:monsterToRemove];
}

@end
