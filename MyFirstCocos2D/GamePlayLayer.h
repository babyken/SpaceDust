//
//  GamePlayLayer.h
//  MyFirstCocos2D
//
//  Created by BabyKen on 2/3/13.
//  Copyright 2013 Hui Ken. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Player.h"

#import "BulletsManager.h"
#import "MonstersManager.h"
#import "LevelManager.h"

@interface GamePlayLayer : CCLayerColor <MonstersManagerDelegate>{
    // for user control
    CGFloat         lastYPosition;
    
    // Attributes for Game Play
    Player *_player;
    BulletsManager  *_bulletsMgr;
    MonstersManager *_monstersMgr;
    LevelManager    *_levelMgr;
    
    CCSprite *_levelTitle;
    
    NSMutableArray *_playerHeartSprite;
}

+(CCScene *) scene;

@end
