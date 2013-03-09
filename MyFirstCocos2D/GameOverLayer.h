//
//  GameOverLayer.h
//  MyFirstCocos2D
//
//  Created by Hui Ken on 30/1/13.
//  Copyright 2013 Hui Ken. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameOverLayer : CCLayerColor {
    
}

+ (CCScene *) sceneWithWon:(BOOL)won;
- (id)initWithWon:(BOOL)won;

@end
