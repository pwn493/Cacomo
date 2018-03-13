//
//  BasicGame.m
//  Cacomo
//
//  Created by Danny Hyatt on 11/19/12.
//
//

#import "BasicGame.h"
#import "ComputerPlayer.h"
#import "Player.h"

@implementation BasicGame

-(void)onNewPlayReady:(NSNotification *) notification {
    // make sure the play hasn't been played yet
    // update current player turn
    
    [Game updateCurrentPlayer];
    if ([self isNewRound] && [GameState isHandPassingEnabled]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:preNextRoundEventName object:self];
    } else {
        [self changeTurn];
    }
}
-(void)onRoundReady:(NSNotification *)notification {
    [self changeTurn];
}
-(void)changeTurn {
    if ([self isNewRound]) {
        if ([GameState isHandPassingEnabled]) {
            [self rotateHands];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:nextRoundEventName object:self];
    }
    
    if ([[Game getCurrentPlayer].hand count] == 0 && ![GameState isTutorial]) {
        [self gameIsFinished];
        return;
    }
    // if it's a computer player run create play
    Player *comPlayer = [Game getCurrentPlayer];
    if ([Game isComputer:comPlayer]) {
        [comPlayer createPlay];
    }
}
-(bool)isNewRound {
    NSArray *players = [Game getActivePlayers];
    Player *currentPlayer = [Game getCurrentPlayer];
    return [players indexOfObject:currentPlayer] == 0;
}
-(void)rotateHands {
    NSArray *players = [Game getActivePlayers];
    int size = [players count];
    Deck *hand = ((Player *)[players objectAtIndex:(size - 1)]).hand;
    Deck *nextHand;
    
    for (int i=0; i<size; i++) {
        Player *player = [players objectAtIndex:i];
        nextHand = player.hand;
        player.hand = hand;
        [player.hand makePassed];
        [player.hand makeNew:false];
        hand = nextHand;
    }
}
@end
