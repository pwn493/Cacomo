//
//  Dialog.h
//  Cacomo
//
//  Created by Danny Hyatt on 12/11/12.
//
//

#import <Foundation/Foundation.h>
#import "CCSprite.h"
#import "GameState.h"
#import "CCLabelTTF.h"

@interface Dialog : NSObject
@property (assign) NSString *text;
@property (assign) Deck *drawDeck;
@property (assign) Board *board;
@property (assign) NSMutableArray *sprites;
@property bool isLow;
@property bool isInvisible;
@property float delayInSeconds;
@property bool hasRendered;
-(id)initWithString:(NSString *)text;
-(void)updateState;
-(CCSprite *)backSprite:(int)x :(int)y;
-(CCLabelTTF *)textSprite:(int)x :(int)y;
-(CCMenu *)okSprite:(int)x :(int)y block:(void (^)(id))block;
-(CCMenu *)okCancelSprite:(int)x :(int)y okBlock:(void (^)(id))okBlock cancelBlock:(void (^)(id))cancelBlock;
-(bool)isReadyForNext;
-(bool)hasMechanicChange;
-(void)updateState;
-(void)updateMechanicChange:(SEL)func object:(id)object;
-(void)callMechanicChange;
@end
