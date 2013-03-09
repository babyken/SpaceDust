//
//  GameStartLayer.m
//  MyFirstCocos2D
//
//  Created by BabyKen on 2/3/13.
//  Copyright 2013 Hui Ken. All rights reserved.
//

#import "GameStartLayer.h"
#import "HelloWorldLayer.h"

#import "GamePlayLayer.h"
#import "SimpleAudioEngine.h"


@implementation GameStartLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameStartLayer *layer = [GameStartLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

/*======= Init Method =======*/
- (id)init
{
    if ((self = [super initWithColor:ccc4(255, 255, 255, 255)])) {
        // ask director for the window size
        CGSize winSize = [CCDirector sharedDirector].winSize;
      
        // Add the background image
        CCSprite *backgroundImage = [[CCSprite alloc] initWithFile:@"startBackground.png"];
        backgroundImage.position = ccp(winSize.width / 2, winSize.height / 2);
//        backgroundImage.zOrder = 1;
        [self addChild:backgroundImage];
//        backgroundImage = nil;
        
        
        
        // create and initialize a Label
        labelStart = [CCLabelTTF labelWithString:@"Press To Start" fontName:@"Marker Felt" fontSize:30];
        labelStart.color = ccc3(0, 00, 00);
        
        // position the label on the 1/3 of height and center align of the screen
        labelStart.position =  ccp( winSize.width /2 , winSize.height * 0.15 );
//        labelStart.zOrder = 0;
        
        
//        CCNode  *nodeLabel = [[CCNode alloc] init];
//        [nodeLabel addChild:backgroundImage];
//        [nodeLabel addChild:labelStart];

        
        // add the label as a child to this Layer
        [self addChild: labelStart];
        
        
        
        [labelStart runAction:
         [CCSequence actions:
          [CCFadeIn actionWithDuration:0.2],
          [CCFadeOut actionWithDuration:0.5],
          nil]];
        
        // Enable Touch
        self.touchEnabled = YES;
    
        // Flash the text on the screen
        [self schedule:@selector(flashStartText:) interval:0.5];
        
        // Playing background sound
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"StartBackgroundMusic.m4a"];
        
        
    }
    
    return self;
}//end init

- (void)flashStartText:(ccTime)dt
{
    if (labelStart.opacity == 255) {
        [labelStart runAction:[CCFadeOut actionWithDuration:0.35]];
    }
    else if(labelStart.opacity == 0) {
        [labelStart runAction:[CCFadeIn actionWithDuration:0.35]];
    }
    CCLOG(@"%i", labelStart.opacity);
}

#pragma mark -
#pragma mark Touch Methods

/*======= Touch Began =======*/
- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Choose one of the touches to work with
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    CCLOG(@"location x:%0.4f y:%0.4f", location.x, location.y);
    
    
    CCScene *gameOverScene = [GamePlayLayer scene];
    [[CCDirector sharedDirector] replaceScene:gameOverScene];
}



@end
