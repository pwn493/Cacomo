 //
//  Player.m
//  Cacomo
//
//  Created by Danny Hyatt on 11/17/12.
//
//

#import "Player.h"
#import "PlayBuilder.h"
@implementation Player
@synthesize hand = _hand;
@synthesize team = _team;
@synthesize playBuilder = _playBuilder;
@synthesize handSize = _handSize;

-(id)initWithHandSize:(int)size team:(Team *)team playBuilder:(PlayBuilder *) playBuilder{
    if ([self init]) {
        _team = team;
        _playBuilder = playBuilder;
        _handSize = size;
        _hand =  [[Deck alloc] initWithUI:true stacked:false];
        [self drawToFullHand];
    }
    return self;
}
-(void)drawToFullHand {
    while ([self.hand count] < self.handSize && [[GameState getDrawDeck] count] > 0) {
        Card *new = [[GameState getDrawDeck] removeTop];
        new.isNew = true;
        [self.hand add:new];
    }
}
-(void)resetHand {
    [self.hand removeAll];
    [self drawToFullHand];
}
-(void)addCardToPlay:(Card *)card {
    assert(false);
}
@end
