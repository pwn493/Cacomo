//
//  HardComputerPlayer.m
//  Cacomo
//
//  Created by Danny Hyatt on 12/24/12.
//
//

#import "HardComputerPlayer.h"

@implementation HardComputerPlayer
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
    
    [testBoard removeMove:move];
    
    // does the move fill an eye?
    if ([testBoard fillsInAnEye:move]) {
        return -100;
    }
    // how many liberties does the play give?
    int positionScore = 0;
    positionScore = [testBoard countLiberties:move];
    
    int center = [testBoard size]/2;
    int centerBonus = 7 - (abs(center - move.row) + abs(center - move.col));
    return positionScore * 2 + centerBonus;
}
@end
