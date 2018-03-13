//
//  Matrix.m
//  CacomoBoard
//
//  Created by Danny Hyatt on 11/12/12.
//
//

#import "Matrix.h"
@interface Matrix()
@property int numColumns;
@property int numRows;
@property (nonatomic, strong) NSMutableArray *data;

@end

@implementation Matrix
@synthesize numColumns = _numColumns;
@synthesize numRows = _numRows;
@synthesize data = _data;

-(id) initWithRows: (int) rows cols: (int) cols
{
    self = [super init];
    if (self != nil)
    {
        _numRows = rows;
        _numColumns = cols;
        _data = [[NSMutableArray alloc] initWithCapacity:_numRows * _numColumns];
        
        for (int i = 0; i < _numRows * _numColumns; i++) {
            [_data addObject:[NSNull null]];
        }
    }
    return self;
}

-(void) dealloc
{
    [_data release];
    [super dealloc];
}

-(id) objectAtRow: (int) row col: (int) col
{
    int index = [self getIndex :row :col];
    return [self.data objectAtIndex:index];
}

-(void)addObject:(id)object row:(int)row col:(int)col {
    int index = [self getIndex :row :col];
    [self.data replaceObjectAtIndex:index withObject:object];
}

-(void)removeObjectAtRow:(int)row col:(int)col {
    [self.data replaceObjectAtIndex:[self getIndex:row :col] withObject:[NSNull null]];
}

-(void)clear {
    for (int i = 0; i < self.numRows * self.numColumns; i++) {
        [self.data replaceObjectAtIndex:i withObject:[NSNull null]];
    }
}

-(int) getIndex:(int)row :(int)col {
    int index =  row * self.numColumns + col;
    assert(index < [self.data count]);
    return index;
}

-(NSArray *) getAllData {
    return [self.data copy];
}
@end
