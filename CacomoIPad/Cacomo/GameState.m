//
//  GameState.m
//  Cacomo
//
//  Created by Danny Hyatt on 12/12/12.
//
//

#import "GameState.h"

static Board *board;
static Deck *drawDeck;
static Deck *discardDeck;
static GameState *instance;
static bool isTutorial;
static bool handPassing;

@implementation GameState
NSString *const cardStateUpdateEventName = @"cardStateUpdateEvent";
NSString *const boardStateUpdateEventName = @"boardStateUpdateEvent";

-(id)initWithBoard:(Board *)inBoard DrawDeck:(Deck *)inDrawDeck DiscardDeck:(Deck *)inDiscardDeck isTutorial:(bool)inTutorial{
    if ([self init]) {
        board = inBoard;
        drawDeck = inDrawDeck;
        discardDeck = inDiscardDeck;
        handPassing = true;
        isTutorial = inTutorial;
        instance = self;
    }
    
    return self;
}
+(Board *)getBoard {
    return board;
}
+(Deck *)getDiscardDeck {
    return discardDeck;
}
+(Deck *)getDrawDeck {
    return drawDeck;
}
+(GameState *)getInstance {
    return instance;
}
+(bool)isHandPassingEnabled {
    return handPassing;
}
+(bool)isTutorial {
    return isTutorial;
}
+(void)updateBoard:(Board *)inBoard {
    board = inBoard;
    [[NSNotificationCenter defaultCenter] postNotificationName:boardStateUpdateEventName object:instance];
}
+(void)updateDiscardDeck:(Deck *)deck {
    discardDeck = deck;
}
+(void)updateDrawDeck:(Deck *)deck {
    drawDeck = deck;
    [[NSNotificationCenter defaultCenter] postNotificationName:cardStateUpdateEventName object:instance];
}
+(void)updateHandPassing:(bool)handPassingOn {
    handPassing = handPassingOn;
}
@end
