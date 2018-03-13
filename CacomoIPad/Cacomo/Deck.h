//
//  Deck.h
//  CacomoCards
//
//  Created by Danny Hyatt on 11/8/12.
//
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject
@property bool isVisible;
@property bool isStacked;

-(id)initWithUI:(bool) isVisible stacked:(bool)isStacked;
-(Card *) removeTop;
-(void) remove:(Card *) card;
-(void) removeAll;
-(int) count;
-(NSArray *) getCardRange:(int) start to:(int) end;
-(Card *) getCard:(int) index;
-(void) shuffle;
-(void) add:(Card *) card;
-(bool) contains:(Card *) card;
-(void) makeNew:(bool)isNew;
-(void) makePassed;
-(NSMutableDictionary *) buildLookupTable;

//TODO remove this
-(NSArray *) getCards;
@end
