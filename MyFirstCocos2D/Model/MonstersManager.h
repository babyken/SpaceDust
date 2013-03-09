//
//  MonstersManager.h
//  Manage the monster
//  Created by Ken Hui on 2/3/13
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@protocol MonstersManagerDelegate <NSObject>

// Notify the program that a monster moved through player
- (void)monsterFinishMove;

@end

@interface MonstersManager : NSObject
{
    NSMutableArray *_monsters;
    int _totalMonstersNumber;
    int _monsterLevel;
    id<MonstersManagerDelegate> _delegate;
}

@property (retain, nonatomic) NSMutableArray *monsters;
@property (readwrite) int totalMonstersNumber;
@property (readwrite) int monsterLevel;
@property (assign, nonatomic) id<MonstersManagerDelegate> delegate;

// Spawn Monster
- (CCSprite*)spawnMonster;

// Remove the monster in array
- (void)removeMonster:(CCSprite*)monsterToRemove;

@end
