//
//  BasicDeck.h
//  CacomoCards
//
//  Created by Danny Hyatt on 11/8/12.
//
//

#import "Deck.h"

@interface BasicDeck : Deck
-(id)initWithDeck:(bool) isVisible stacked:(bool)isStacked size:(int)size;
@end
