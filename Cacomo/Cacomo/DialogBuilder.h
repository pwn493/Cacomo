//
//  DialogBuilder.h
//  Cacomo
//
//  Created by Danny Hyatt on 12/12/12.
//
//

#import <Foundation/Foundation.h>
#import "DialogFlow.h"

@class CardLayer;
@class PlayBuilder;

@interface DialogBuilder : NSObject
+(DialogFlow *)cardsAndStones:(CardLayer *)cardLayer playBuilder:(PlayBuilder *)playBuilder cardLookup:(NSDictionary *) lookup;
+(DialogFlow *)capturingStones:(PlayBuilder *)playBuilder cardLookup:(NSDictionary *) lookup;
+(void)updateStateForDeck:(id)sender;
+(void)forceHandPass:(id)sender;
+(DialogFlow *)theDeck:(PlayBuilder *)playBuilder cardLookup:(NSDictionary *)lookup;
+(DialogFlow *)selfCapture:(PlayBuilder *)playBuilder cardLookup:(NSDictionary *)lookup;
+(DialogFlow *)threePlayer;
+(DialogFlow *)finalTest;
@end
