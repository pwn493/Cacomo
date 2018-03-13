//
//  Deck.m
//  CacomoCards
//
//  Created by Danny Hyatt on 11/8/12.
//
//

#import "Deck.h"

@interface Deck()
@property (nonatomic, strong) NSMutableArray *cards;
@end

@implementation Deck
@synthesize cards = _cards;
@synthesize isVisible = _isVisible;
@synthesize isStacked = _isStacked;

-(id)initWithUI:(bool)isVisible stacked:(bool)isStacked {
    if ([self init]) {
        _isVisible = isVisible;
        _isStacked = isStacked;
        
        _cards = [[NSMutableArray alloc] init];
    }
    
    return self;
}

-(int)count {
    return [self.cards count];
}
-(NSArray *)getCardRange:(int)start to:(int)end {
    int size = [self.cards count];
    assert(start >=0);
    assert(start < size);
    assert(end >=0);
    assert(end < size);
    assert(start <= end);
    
    NSMutableArray *cardsToReturn = [[NSMutableArray alloc] init];
    for (int i = start; i <= end; i++) {
        [cardsToReturn addObject:[self.cards objectAtIndex:i]];
    }
    return [cardsToReturn copy];
}
-(Card *)getCard:(int)index {
    return [self.cards objectAtIndex:index];
}
-(void)add:(Card *)card {
    if (card == nil) {
        return;
    }
    card.isVisible = self.isVisible;
    
    if (self.isVisible && !self.isStacked) {
        card.isTouchable = true;
    } else {
        card.isTouchable = false;
    }
    [self.cards addObject:card];
}
-(Card *)removeTop {
    Card *card = (Card*)[self.cards objectAtIndex:(0)];
    [self remove:card];
    return card;
}
-(void)remove:(Card *)card {
    [card retain];
    [self.cards removeObject:card];
}
-(void)removeAll {
    [self.cards removeAllObjects];
}
-(void)shuffle {
    NSUInteger count = [self.cards count];
    for (NSUInteger i = 0; i < count; ++i) {
        // Select a random element between i and end of array to swap with.
        NSInteger nElements = count - i;
        NSInteger n = (arc4random() % nElements) + i;
        [self.cards exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}
-(bool)contains:(Card *)card {
    return [self.cards containsObject:card];
}
-(NSArray *)getCards {
    return [self.cards copy];
}
-(void)makeNew:(bool)isNew {
    for (Card *card in self.cards) {
        card.isNew = isNew;
    }
}
-(void)makePassed {
    for (Card *card in self.cards) {
        card.isPassed = true;
    }
}
-(NSDictionary *)buildLookupTable {
    NSMutableDictionary *lookup = [[NSMutableDictionary alloc] init];
    
    for (Card *card in self.cards) {
        CCSprite *sprite = [card buildSprite];
        NSString *lookupCode = sprite.userData;
        [card retain];
        [lookup setObject:card forKey:lookupCode];
    }

    return lookup;
}
@end
