//
//  BulletsManager.m
//  Created by Ken Hui on 2/3/13
//

#import "BulletsManager.h"

@implementation BulletsManager
@synthesize bullets = _bullets;

// Init with a player reference
- (id)initWithPlayer:(Player *)p
{
    self = [super init];
    
    if (self) {
        _player = p;
        _bullets = [[NSMutableArray alloc] init];
    }
    
    return self;
}

// Dealloc and clean up
- (void)dealloc
{
    _player = nil;
    
    [_bullets release];
    _bullets = nil;
    
    [super dealloc];
}

// Create Bullet
// Return a CCSprite

- (CCSprite*)spawnBullet
{
    // Obtain the Screen size
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    
    // A Bullet Sprite
    
    CCSprite *bullet = [CCSprite spriteWithFile:@"bullet.png"];
    
    
    // put the bullet in front of the player
    
    bullet.position = ccp(_player.position.x + _player.contentSize.width /2, _player.position.y);
    
    
    // Determine the bullet destinaton
    
    int realX = winSize.width + (bullet.contentSize.width/2);
    int realY = bullet.position.y;
    CGPoint realDest = ccp(realX, realY);
    

    // Determine the length of how far you're shooting
    
    int offRealX = realX - bullet.position.x;
    float length = offRealX;
    float velocity = 480/1; // 480 pixels / 1 sec

    
    // displacement / velocity = time in sec

    float realMoveDuration = length / velocity;
    
    
    // Movie bullet to actual endpoint
    
    [bullet runAction:
     [CCSequence actions:
      [CCMoveTo actionWithDuration:realMoveDuration position:realDest],
      [CCCallBlockN actionWithBlock:^(CCNode *node) {
         [node removeFromParentAndCleanup:YES];
         [_bullets removeObject:node];
         }],
      nil]];
    
    
    // Add current bullet to the mutable array
    
    [_bullets addObject:bullet];
    
    return bullet;
}

// Remove Bullets
- (void)removeBullets:(CCSprite*)bulletToRemove
{
    [_bullets removeObject:bulletToRemove];
}

@end
