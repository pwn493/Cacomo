//
//  Board.h
//  CacomoBoard
//
//  Created by Danny Hyatt on 11/12/12.
//
//

#import <Foundation/Foundation.h>
#import "Stone.h"

@class Matrix;

@interface Board : NSObject
@property int size;
-(int)addMove:(Stone *) move;
-(int)tryMove:(Stone *)move;
-(void)removeMove:(Stone *) move;
-(NSArray *)renderSpritesAtLocation:(int)x :(int)y;
-(CCSprite *)renderStoneAtBoardLocation:(Stone *)stone :(int)x :(int)y;
-(void)clear;
-(bool)hasMove:(Stone *) move;
-(NSArray *)tempAddPotenteialMove:(Stone *)move :(int)x :(int)y;
-(void)reset;
+(Board *)initWithSize :(int) size;
-(Board *)copy;
-(int)countLiberties:(Stone *)lastMove;
-(bool) fillsInAnEye:(Stone *) lastMove;
@end
