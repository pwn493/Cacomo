//
//  Player.h
//  Cacomo
//
//  Created by Danny Hyatt on 11/17/12.
//
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "Team.h"
#import "GameState.h"
@class PlayBuilder;

@interface Player : NSObject
@property int handSize;
@property (strong) Deck *hand;
@property (nonatomic, strong) Team *team;
@property (nonatomic, strong) PlayBuilder *playBuilder;
-(void) addCardToPlay:(Card *) card;
-(id) initWithHandSize:(int)size team:(Team *)team playBuilder:(PlayBuilder *) playBuilder;
-(void)drawToFullHand;
-(void)resetHand;
@end
