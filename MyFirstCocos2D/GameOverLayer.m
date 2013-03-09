//
//  GameOverLayer.m
//  MyFirstCocos2D
//
//  Created by Hui Ken on 30/1/13.
//  Copyright 2013 Hui Ken. All rights reserved.
//

#import "GameOverLayer.h"
#import "HelloWorldLayer.h"
#import "GamePlayLayer.h"
#import "GameStartLayer.h"
#import "SimpleAudioEngine.h"

@implementation GameOverLayer

+ (CCScene*)sceneWithWon:(BOOL)won {
    CCScene *scene = [CCScene node];
    GameOverLayer *layer = [[[GameOverLayer alloc] initWithWon:won] autorelease];
    [scene addChild:layer];
    return scene;
}

- (id)initWithWon:(BOOL)won {
    if ((self = [super initWithColor:ccc4(255, 255, 255, 255)])) {
        
//        NSString *message;
//        NSLog(@"GameOverLayer : init");
        NSString *fileName = nil;
        
        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
        
        if(won) {
            fileName = @"win.png";
            [[SimpleAudioEngine sharedEngine] playEffect:@"winSound.m4a"];
        } else {
            fileName = @"lose.png";
            [[SimpleAudioEngine sharedEngine] playEffect:@"loseSound2.m4a"];
        }
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CCSprite *bg = [[CCSprite alloc] initWithFile:fileName];
        bg.position = ccp(winSize.width / 2, winSize.height / 2);
        [self addChild:bg];
//        NSLog(@"GameOverLayer : almost finish init");
//        CCLabelTTF *label = [CCLabelTTF labelWithString:message fontName:@"Arial" fontSize:32];
//        label.color = ccc3(0, 0, 0);
//        label.position = ccp(winSize.width/2, winSize.height/2);
//        
//        [self addChild:label];
        
        [self runAction:
         [CCSequence actions:
          [CCDelayTime actionWithDuration:3],
          [CCCallBlockN actionWithBlock:^(CCNode *node) {
             [[CCDirector sharedDirector] replaceScene:[GameStartLayer scene]];
         }],
         nil]
         ];
    }
    return self;
}

@end
