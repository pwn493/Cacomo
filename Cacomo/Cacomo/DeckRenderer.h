//
//  DeckRenderer.h
//  Cacomo
//
//  Created by Danny Hyatt on 12/5/12.
//
//

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface DeckRenderer : NSObject
+(NSArray *)renderHandPass:(Deck *) deck cgpoint:(CGPoint) coor;
+(NSArray *)buildDeckSprites:(Deck *) deck cgpoint:(CGPoint) coor;
@end
