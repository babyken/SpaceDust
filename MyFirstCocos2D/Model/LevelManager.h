//
//  LevelManager.h
//  Control the level parameter
//  Created by Ken Hui on 2/3/13
//

#import <Foundation/Foundation.h>

@interface LevelManager : NSObject
{
    int _level;
    int _currentLevel;
    int _monsterKilled;
    BOOL _promptToNextLevel;
}

@property (readwrite) int level;
@property (readwrite) int monsterKilled;
@property (readonly) BOOL promptToNextLevel;

// Indicate the monster level
- (int)monsterLevel;

// Indicate total number of monster in game
- (int)totalMonsterShouldSpawn;

// Increament of the monster killed;
- (void)addMonsterKilled:(int)noOfMonsterKilled;

@end
