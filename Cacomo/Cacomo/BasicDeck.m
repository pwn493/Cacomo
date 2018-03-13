//
//  BasicDeck.m
//  CacomoCards
//
//  Created by Danny Hyatt on 11/8/12.
//
//

#import "BasicDeck.h"
#import "BasicCard.h"

@implementation BasicDeck
-(id) initWithDeck:(bool)isVisible stacked:(bool)isStacked size:(int)size {
    if ([super initWithUI:isVisible stacked:isStacked]) {
        for (int x = 0; x < size; x++) {
            for (int y = 0; y < size; y++) {
                [super add:[BasicCard initBasicCard:x :y isVisible:isVisible]];
            }
        }
    }
    return self;
}
@end
