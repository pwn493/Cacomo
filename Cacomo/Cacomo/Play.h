//
//  Play.h
//  Cacomo
//
//  Created by Danny Hyatt on 11/17/12.
//
//

#import <Foundation/Foundation.h>
//#import "Card.h"

@class Player;
@class Stone;

@interface Play : NSObject

@property (nonatomic, strong) Player *player;
@property (nonatomic, strong) Stone *stone;
-(id) initWithPlayer:(Player *) player stone:(Stone *)stone;
@end
