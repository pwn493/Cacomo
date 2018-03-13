//
//  Game.h
//  Cacomo
//
//  Created by Danny Hyatt on 11/19/12.
//
//

#import <Foundation/Foundation.h>
#import "PlayBuilder.h"

@interface Game : NSObject
extern NSString *const gameOverEventName;
extern NSString *const nextRoundEventName;
extern NSString *const preNextRoundEventName;
+(bool)isLocalPlayerTurn;
+(bool)isComputer:(Player *)player;
+(Player *)getCurrentPlayer;
+(Player *)getNextPlayer;
+(NSArray *)getActivePlayers;
+(void)playerTurnCompleted;
-(id)initWithPlayers:(NSArray *) players playBuilder: (PlayBuilder *) playBuilder;
-(void)gameIsFinished;
-(void)onNewPlayReady:(NSNotification *) sender;
-(void)onRoundReady:(NSNotification *)notification;
+(void)updateCurrentPlayer;
@end
