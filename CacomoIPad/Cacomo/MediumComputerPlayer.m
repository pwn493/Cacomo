//
//  MediumComputerPlayer.m
//  Cacomo
//
//  Created by Danny Hyatt on 1/3/13.
//
//

#import "MediumComputerPlayer.h"

@implementation MediumComputerPlayer
-(Card *)selectCardToPlay {
    int maxValue = -1000;
    Card *bestCard = nil;
    
    for (Card *card in [self.hand getCards]) {
        int currentValue = [self calculatePlayValue:card];
        if (maxValue < currentValue) {
            maxValue = currentValue;
            bestCard = card;
        }
    }
    
    return bestCard;
}
-(int)calculatePlayValue:(Card *)card {
    // does play capture anything? 100+#stones captured
    Board *testBoard = [[GameState getBoard] copy];
    Stone *move = [[Stone alloc] initWithColor:self.team.color row:card.x col:card.y];
    int numCaptured = [testBoard tryMove:move];
    if (numCaptured > 0) {
        return 100+numCaptured;
    } else if (numCaptured < 0) {
        return numCaptured - 100;
    }
    
    NSUInteger count = [self.hand count];
    NSInteger n = (arc4random() % count);
    return n;
}
@end
