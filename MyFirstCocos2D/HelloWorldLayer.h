//
//  HelloWorldLayer.h
//  MyFirstCocos2D
//
//  Created by Hui Ken on 28/1/13.
//  Copyright Hui Ken 2013. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"


// HelloWorldLayer
@interface HelloWorldLayer : CCLayerColor <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
{
    NSMutableArray * _monsters;
    NSMutableArray * _projectiles;
    int _monsterDestroyed;
    CCSprite *_player;
    CCSprite *_nextProjectile;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
