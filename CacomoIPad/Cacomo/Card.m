//
//  Card.m
//  CacomoCards
//
//  Created by Danny Hyatt on 11/8/12.
//
//

#import "Card.h"
@implementation Card
int const CARD_HEIGHT =153;
int const CARD_WIDTH = 128;
@synthesize isVisible = _isVisible;
@synthesize isNew = _isNew;
@synthesize isPassed = _isPassed;
@synthesize isTouchable = _isTouchable;
@synthesize x = _x;
@synthesize y = _y;

- (CCSprite *)buildSprite {
    return nil;
}

@end
