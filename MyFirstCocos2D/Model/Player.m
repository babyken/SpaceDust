//
//  Player.m
//  Created by Ken Hui on 2/3/13
//

#import "Player.h"

@implementation Player
@synthesize lifes;
@synthesize scores;

/*======= Player Class =======*/
+ (id)player {
    
    Player *player = nil;
    
    if ((player = [[[super alloc] initWithFile:@"DustCleaner.png"] autorelease])) {
        
        // position the player
        CGSize winSize = [CCDirector sharedDirector].winSize;
        player.position = ccp(player.contentSize.width/2, winSize.height/2);
    
        // init the player attributes
        player.lifes = 3;
        player.scores = 0;
    }
    return player;
    
}


@end
