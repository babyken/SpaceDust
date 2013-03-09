//
//  Monster.h
//  Monster class which spawn different types of monster
//  Created by Ken Hui on 2/3/13
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

/*======= Monster Base Class =======*/
@interface Monster : CCSprite {
    int _curHp;
    int _minMoveDuration;
    int _maxMoveDuration;
}

@property (nonatomic, assign) int hp;
@property (nonatomic, assign) int minMoveDuration;
@property (nonatomic, assign) int maxMoveDuration;

@end

/*======= Weak and Fast Moving Monster =======*/
@interface WeakAndFastMonster : Monster
+(id)monster;
@end


/*======= Strong and Slow Moving Monster =======*/
@interface StrongAndSlowMonster : Monster
+(id)monster;

@end
