//
//  Matrix.h
//  CacomoBoard
//
//  Created by Danny Hyatt on 11/12/12.
//
//

#import <Foundation/Foundation.h>

@interface Matrix : NSObject

// values is a linear array in row major order
-(id) initWithRows: (int)rows cols: (int) cols;
-(id) objectAtRow: (int) row col: (int) col;
-(void) addObject:(id)object row:(int) row col: (int) col;
-(void) removeObjectAtRow:(int) row col:(int) col;
-(void) clear;
-(NSArray *) getAllData;
@end
