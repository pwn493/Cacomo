//
//  Card.h
//  CacomoCards
//
//  Created by Danny Hyatt on 11/8/12.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
@interface Card : NSObject
extern int const CARD_HEIGHT;
extern int const CARD_WIDTH;
@property bool isVisible;
@property bool isNew;
@property bool isPassed;
@property bool isTouchable;
// TODO remove these and add them to basic card
@property int x;
@property int y;
-(CCSprite *) buildSprite;
@end
