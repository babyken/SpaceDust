//
//  Player Class
//  Player Sprite file with life and score attributes
//  Created by Ken Hui on 2/3/13
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"


@interface Player : CCSprite

// Attributes
@property (readwrite) int lifes;
@property (readwrite) int scores;

+ (id)player;

@end
