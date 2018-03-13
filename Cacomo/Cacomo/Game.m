//
//  Game.m
//  Cacomo
//
//  Created by Danny Hyatt on 11/19/12.
//
//

#import "Game.h"
#import "LocalPlayer.h"
#import "ComputerPlayer.h"

static NSArray *players;
static PlayBuilder *playBuilder;
static Player *currentPlayer;

@implementation Game

NSString *const gameOverEventName = @"gameOverEvent";
NSString *const nextRoundEventName = @"nextRoundEvent";
NSString *const preNextRoundEventName = @"preNextRoundEvent";

+(bool)isLocalPlayerTurn {
    return [currentPlayer isKindOfClass:[LocalPlayer class]];
}
+(Player *)getCurrentPlayer {
    return currentPlayer;
}
+(Player *)getNextPlayer {
    int index = [players indexOfObject:currentPlayer];
    int size = [players count];
    int newIndex = (index + 1)%size;
    return [players objectAtIndex:newIndex];
}
+(NSArray *)getActivePlayers {
    return players;
}
-(id)initWithPlayers:(NSArray *)inPlayers playBuilder:(PlayBuilder *)inPlayBuilder {
    if (self = [super init]) {
        playBuilder = inPlayBuilder;
        players = inPlayers;
        currentPlayer = [players objectAtIndex:0];
    }
    return self;
}
-(void)onNewPlayReady:(NSNotification *) sender {
    
}
+(void)updateCurrentPlayer {
    currentPlayer = [Game getNextPlayer];
}
-(void)gameIsFinished {
    [[NSNotificationCenter defaultCenter] postNotificationName:gameOverEventName object:self];
}
+(bool) isComputer:(Player *)player {
    return [player isKindOfClass:[ComputerPlayer class]];
}
@end
