//
//  LevelManager.m
//  MyFirstCocos2D
//
//  Created by Hui Ken on 5/3/13.
//  Copyright (c) 2013 Hui Ken. All rights reserved.
//

#import "LevelManager.h"

@implementation LevelManager
@synthesize level = _level;
@synthesize monsterKilled = _monsterKilled;


/*======= Add Monster killed and control the current game level =======*/
// Return BOOL to indicate does the player prompt to next level
- (void)addMonsterKilled:(int)noOfMonsterKilled
{
    _monsterKilled += noOfMonsterKilled;
    
    if (_monsterKilled <= 10) {
        _level = 0;
    }
    else if (_monsterKilled <= 20) {
        _level = 1;
    }
    else if (_monsterKilled <= 30) {
        _level = 2;
    }
    else {
        _level = 3;
    }
    
    if (_currentLevel != _level) {
        _promptToNextLevel = YES;
        _currentLevel = _level;
    }
}

- (BOOL)promptToNextLevel
{
    BOOL goToNextLevel = _promptToNextLevel;
    if (goToNextLevel) {
        _promptToNextLevel = NO;
        return YES;
    }
    
    return goToNextLevel;
}

/*======== Control the Monster level =======*/
- (int)monsterLevel
{
    switch (_level) {
        case 0:
            // Level 1
            return 1;
            break;
        case 1:
            // Level 2
            return 2;
            break;
        case 2:
            // Level 3
            return 3;
            break;
        default:
            return 99;
            break;
    }
}

/*======= Control the total monster in game =======*/
- (int)totalMonsterShouldSpawn
{
    switch (_level) {
        case 0:
            // Level 1
            return 10;
            break;
        case 1:
            // Leve 2
            return 14;
            break;
        case 2:
            // Leve 3
            return 18;
            break;
        default:
            return 99;
            break;
    }
}

@end
