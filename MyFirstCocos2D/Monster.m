//
// Monster.m
//  Created by Ken Hui on 2/3/13
//

#import "Monster.h"

/*======= Monster Base Class =======*/
@implementation Monster

@synthesize hp = _curHp;
@synthesize minMoveDuration = _minMoveDuration;
@synthesize maxMoveDuration = _maxMoveDuration;

@end

/*======= Weak and Fast Monster ========*/
@implementation WeakAndFastMonster

+ (id)monster {
    
    WeakAndFastMonster *monster = nil;
    if ((monster = [[[super alloc] initWithFile:@"weakMonster.png"] autorelease])) {
        
        // init the HP
        monster.hp = 1;
        
        // Shorter duration mean moving faster
        monster.minMoveDuration = 3;
        monster.maxMoveDuration = 5;
    }
    return monster;
    
}

@end

/*======= Strong and Slow Monster ========*/
@implementation StrongAndSlowMonster

+ (id)monster {
    
    StrongAndSlowMonster *monster = nil;
    if ((monster = [[[super alloc] initWithFile:@"strongMonster.png"] autorelease])) {
        
        // init the HP
        monster.hp = 3;
        
        // Longer duration means slower
        monster.minMoveDuration = 6;
        monster.maxMoveDuration = 12;
    }
    return monster;
    
}

@end
