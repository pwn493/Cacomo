//
//  ComputerPlayer.m
//  Cacomo
//
//  Created by Danny Hyatt on 11/19/12.
//
//

#import "ComputerPlayer.h"
#import "BasicPlayBuilder.h"

@implementation ComputerPlayer
-(void)createPlay {
    [self drawToFullHand];
    Card *card = [self selectCardToPlay];
    [self.hand remove:card];
    [[GameState getDiscardDeck] add:card];
    [self.playBuilder addCardToPlay:card player:self];
}
-(Card *)selectCardToPlay {
    NSUInteger count = [self.hand count];
    NSInteger n = (arc4random() % count);
    Card *card = [self.hand getCard:n];
    return card;
}
@end
