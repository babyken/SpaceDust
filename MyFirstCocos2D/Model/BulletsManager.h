//
//  BulletsManager.h
//  Manager for bullets from the player
//  Created by Ken Hui on 2/3/13
//

#import <Foundation/Foundation.h>
#import "Player.h"
#import "cocos2d.h"

@interface BulletsManager : NSObject
{
    Player *_player;
    NSMutableArray *_bullets;
}

// Attributes for storing the bullets' sprite
@property (retain, nonatomic) NSMutableArray *bullets;


// Init with player class
- (id)initWithPlayer:(Player*)p;

// Create Bullet and return a CCsprite
- (CCSprite*)spawnBullet;

// Remove Bullets
- (void)removeBullets:(CCSprite*)bulletToRemove;

@end
