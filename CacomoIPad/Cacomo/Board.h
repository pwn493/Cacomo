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
-(NSArray *)renderSpritesAtLocation:(CGPoint)point;
-(CCSprite *)renderStoneAtBoardLocation:(Stone *)stone :(CGPoint)point;
-(void)clear;
-(bool)hasMove:(Stone *) move;
-(NSArray *)tempAddPotenteialMove:(Stone *)move :(CGPoint)point;
-(void)reset;
+(Board *)initWithSize :(int) size;
-(Board *)copy;
-(int)countLiberties:(Stone *)lastMove;
-(bool) fillsInAnEye:(Stone *) lastMove;
@end
