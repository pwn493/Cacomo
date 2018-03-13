//
//  PlayBuilder.h
//  Cacomo
//
//  Created by Danny Hyatt on 11/19/12.
//
//

#import <Foundation/Foundation.h>

@class Player;
@class Play;
@class Card;

@interface PlayBuilder : NSObject

extern NSString *const playReadyEventName;
extern NSString *const potPlayReadyEventName;
extern NSString *const nextTurnEventName;
+(Play *)getLastPlay;
+(Play *)getCurrentPlay;
+(Play *)getPotentialPlay;
-(void)addCardToPlay:(Card *) card player:(Player *)player;
-(void)addPotentialCardToPlay:(Card *) card player:(Player *)player;
-(void)playIsReady;
-(void)readyForNextTurn;
+(void)addNewPlay: (Play *) play;
+(void)addPotentialPlay:(Play *) play;
@end
