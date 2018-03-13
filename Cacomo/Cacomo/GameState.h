//
//  GameState.h
//  Cacomo
//
//  Created by Danny Hyatt on 12/12/12.
//
//

#import <Foundation/Foundation.h>
#import "Board.h"
#import "Deck.h"

@interface GameState : NSObject
extern NSString *const cardStateUpdateEventName;
extern NSString *const boardStateUpdateEventName;
-(id)initWithBoard:(Board *)board DrawDeck:(Deck *)drawDeck DiscardDeck:(Deck *)discardDeck isTutorial:(bool)isTutorial;
+(Board *)getBoard;
+(Deck *)getDrawDeck;
+(Deck *)getDiscardDeck;
+(GameState *)getInstance;
+(bool)isHandPassingEnabled;
+(bool)isTutorial;
+(void)updateBoard:(Board *)board;
+(void)updateDrawDeck:(Deck *)deck;
+(void)updateDiscardDeck:(Deck *)deck;
+(void)updateHandPassing:(bool)handPassingOn;
@end
