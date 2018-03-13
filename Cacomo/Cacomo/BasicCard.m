//
//  BasicCard.m
//  Cacomo
//
//  Created by Danny Hyatt on 11/15/12.
//
//

#import "BasicCard.h"

@implementation BasicCard
- (CCSprite *)buildSprite {
    NSString *cardFileName = @"cardBack.png";
    
    if (self.isVisible) {
        cardFileName = [BasicCard lookupCardFile:self.x :self.y isTouchable:self.isTouchable];
    }
    
    CCSprite *sprite = [CCSprite spriteWithFile:cardFileName
                                           rect:CGRectMake(0, 0, CARD_WIDTH, CARD_HEIGHT)];
    sprite.userData = [[NSString stringWithFormat:@"%i-%i",self.x, self.y] retain];
    return sprite;
}

+(BasicCard *)initBasicCard:(int)x :(int)y isVisible:(BOOL)visible {
    BasicCard *card = [[BasicCard alloc] init];
    card.isVisible = visible;
    card.isNew = true;
    card.x = x;
    card.y = y;
    return card;
}

+(NSString *)lookupCardFile:(int)xIn :(int)yIn isTouchable:(bool)isTouchable {
    char xCoor = (char) (xIn + 65);
    int yCoor = yIn + 1;
    NSString *highlight = @"";
    if (isTouchable) {
        highlight = @"hl";
    }
    return [NSString stringWithFormat:@"%@Card%c%i.png", highlight, xCoor, yCoor];
}
@end
