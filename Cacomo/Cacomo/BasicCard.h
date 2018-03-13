//
//  BasicCard.h
//  Cacomo
//
//  Created by Danny Hyatt on 11/15/12.
//
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface BasicCard : Card
+(BasicCard *) initBasicCard:(int)x
                  :(int)y
         isVisible:(BOOL)visible;
@end
