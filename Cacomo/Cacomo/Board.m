//
//  Board.m
//  CacomoBoard
//
//  Created by Danny Hyatt on 11/12/12.
//
//

#import "Board.h"
#import "Matrix.h"

@interface Board()
@property (assign) Matrix *data;
@end

@implementation Board
@synthesize size = _size;
@synthesize data = _data;

+(Board *)initWithSize :(int)size{
    Board *board = [[Board alloc] init];
    board.data = [[Matrix alloc] initWithRows:size cols:size];
    board.size = size;
    return board;
}

-(int)addMove:(Stone *)move {
    if ([self hasMove:move]) {
        return -1;
    }
    [self.data addObject:move row:move.row col:move.col];
    return [self updateCaptures:move];
}

-(int)tryMove:(Stone *)move {
    if ([self hasMove:move]) {
        return -1;
    }
    [self.data addObject:move row:move.row col:move.col];
    return [self updateCapturesImpl:move removeStones:false];
}

-(void) removeMove:(Stone *)move {
    if ([self hasMove:move]) {
        [self.data removeObjectAtRow:move.row col:move.col];
    }
}

-(void)clear {
    [self.data clear];
}

-(bool)hasMove:(Stone *)move {
    return [self.data objectAtRow:move.row col:move.col] != [NSNull null];
}

-(void)reset {
    NSArray *allStones = [self.data getAllData];
    for (Stone *stone in allStones) {
        if (stone != [NSNull null]) {
            stone.visited = false;
        }
    }
}

-(NSArray *)renderSpritesAtLocation:(int)x :(int)y {
    return [[self buildSprites:x :y] copy];
}

-(CCSprite *)renderStoneAtBoardLocation:(Stone *)stone :(int)x :(int)y {
    CCSprite *stoneSprite = [stone render];
    int uicol = stone.col;
    int uirow = self.size - stone.row - 1;
    stoneSprite.position = ccp(x+[self indexForX:uicol],y+[self indexForY:uirow]);
    
    return stoneSprite;
}

-(NSArray *)tempAddPotenteialMove:(Stone *)potStone :(int)x :(int)y {
    NSMutableArray *sprites = [self buildSprites:x :y];
    potStone.potentialMove = true;
    CCSprite *potSprite = [potStone render];
    int uirow = self.size - potStone.row - 1;
    int uicol = potStone.col;
    potSprite.position = ccp(x+[self indexForX:uicol],y+[self indexForY:uirow]);
    
    [sprites addObject:potSprite];
    return [sprites copy];
}

-(int)updateCaptures:(Stone *)lastMove {
    return [self updateCapturesImpl:lastMove removeStones:true];
}
-(int)updateCapturesImpl:(Stone *)lastMove removeStones:(bool)removeStones {
    // Add moves to look at
    // NonSameColor moves touching the last Move + last Move
    NSMutableArray *movesToLookAt = [self oppositeColorTouchingMoves:lastMove];
    [movesToLookAt addObject:lastMove];
    
    int totalCaptures = 0;
    Color capturedStoneColor;
    
    // Go over all the moves to look at
    for (Stone *stone in movesToLookAt) {
        // Add Move to look at to Current Moves and reset data
        NSMutableArray *currentMoves = [[NSMutableArray alloc] init];
        [currentMoves addObject:stone];
        bool isCaptured = false;
        [self reset];
        
        // CurrentMove = top of Current Moves set state to visited
        while ([currentMoves count] > 0) {
            Stone *currentMove = [currentMoves objectAtIndex:0];
            [currentMoves removeObject:currentMove];
            currentMove.visited = true;
            
            // is currentMove touching open space? If so go to next move to look at
            if ([self isMoveTouchingEmptySpot:currentMove]) {
                break;
            }
            
            // Add all the unvisited moves touching the currentMove to the top of currentMoves
            [currentMoves addObjectsFromArray:[self sameColorTouchingMoves:currentMove]];
            
            // if currentMove is empty group of stones is captured return countCapturesForGroup
            if ([currentMoves count] == 0) {
                isCaptured = true;
                capturedStoneColor = currentMove.color;
            }
        }
        
        if (isCaptured) {
            totalCaptures += [self countCapturesForGroup:stone removeStones:removeStones];
        }
    }
    
    [self reset];
    
    // self captures should be negative in the event of self capture
    if (capturedStoneColor == lastMove.color) {
        totalCaptures = totalCaptures * -1;
    }
    return totalCaptures;
}
-(int)countLiberties:(Stone *)lastMove {
    // look for adjacent stones of the same color
    NSArray *adjacentSameColorMoves = [self colorTouchingMoves:lastMove isSame:true];
    
    // count the liberties of each adjacent stone
    int originalLibertyTotal = 0;
    for (Stone *stone in adjacentSameColorMoves) {
        originalLibertyTotal += [self countTotalLiberties:stone];
    }
    
    int avgLiberties = 0;
    
    if ([adjacentSameColorMoves count] > 0) {
        avgLiberties = originalLibertyTotal / [adjacentSameColorMoves count];
    }
    
    int newLiberties = [self countTotalLiberties:lastMove];
    
    return newLiberties - avgLiberties;
}
-(bool) fillsInAnEye:(Stone *) lastMove {
    // keep grabbing empty spaces adjacent to last move
    // mark empty space coordinates so we don't double back
    // if empty spaces are touching any opponents stones return false;
    // once we're all done return true;
    
    NSMutableSet *liberties = [[NSMutableSet alloc] init];
    
    // Add Move to look at to Current Moves and reset data
    NSMutableArray *currentMoves = [[NSMutableArray alloc] init];
    [currentMoves addObject:lastMove];
    
    // CurrentMove = top of Current Moves set state to visited
    while ([currentMoves count] > 0) {
        Stone *move = [currentMoves objectAtIndex:0];
        [currentMoves removeObject:move];
        move.color = lastMove.color;
        
        if ([[self oppositeColorTouchingMoves:move] count] > 0) {
            return false;
        }
        
        NSMutableArray *objectsToAdd = [self adjacentLiberties:move.row :move.col];
        NSMutableArray *copy = [objectsToAdd copy];
        
        for (Stone *emptyStone in copy) {
            if ([liberties containsObject:[self stringForCoordinate:emptyStone.row :emptyStone.col]]) {
                [objectsToAdd removeObject:emptyStone];
            } else {
                [liberties addObject:[self stringForCoordinate:emptyStone.row :emptyStone.col]];
            }
        }
        
        // Add all the unvisited moves touching the currentMove to the top of currentMoves
        [currentMoves addObjectsFromArray:objectsToAdd];
    }
    
    return true;
}
-(int)countTotalLiberties:(Stone *)lastMove {
    NSMutableSet *liberties = [[NSMutableSet alloc] init];
    
    // Add Move to look at to Current Moves and reset data
    NSMutableArray *currentMoves = [[NSMutableArray alloc] init];
    [currentMoves addObject:lastMove];
    [self reset];
    
    // CurrentMove = top of Current Moves set state to visited
    while ([currentMoves count] > 0) {
        Stone *move = [currentMoves objectAtIndex:0];
        [currentMoves removeObject:move];
        move.visited = true;

        // count liberties
        if (move.row != 0) {
            Stone *top = [self.data objectAtRow:move.row - 1 col:move.col];
            if (top == [NSNull null]) [liberties addObject:[self stringForCoordinate:move.row -1 :move.col]];
        }
        
        if (move.row != self.size - 1) {
            Stone *bottom = [self.data objectAtRow:move.row + 1 col:move.col];
            if (bottom == [NSNull null]) [liberties addObject:[self stringForCoordinate:move.row +1 :move.col]];
        }
        
        if (move.col != 0) {
            Stone *left = [self.data objectAtRow:move.row col:move.col - 1];
            if (left == [NSNull null]) [liberties addObject:[self stringForCoordinate:move.row :move.col - 1]];
        }
        
        if (move.col != self.size - 1) {
            Stone *right = [self.data objectAtRow:move.row col:move.col + 1];
            if (right == [NSNull null]) [liberties addObject:[self stringForCoordinate:move.row :move.col + 1]];
        }
        
        // Add all the unvisited moves touching the currentMove to the top of currentMoves
        [currentMoves addObjectsFromArray:[self sameColorTouchingMoves:move]];
    }
    
    [self reset];
    
    return [liberties count];
}
-(NSString *) stringForCoordinate:(int)x :(int)y {
    return [NSString stringWithFormat:@"%d-%d", x, y];
}
-(bool) isMoveTouchingEmptySpot:(Stone *) move {
    if (move.row != 0) {
        Stone *top = [self.data objectAtRow:move.row - 1 col:move.col];
        if (top == [NSNull null]) return true;
    }
    
    if (move.row != self.size - 1) {
        Stone *bottom = [self.data objectAtRow:move.row + 1 col:move.col];
        if (bottom == [NSNull null]) return true;
    }
    
    if (move.col != 0) {
        Stone *left = [self.data objectAtRow:move.row col:move.col - 1];
        if (left == [NSNull null]) return true;
    }
    
    if (move.col != self.size - 1) {
        Stone *right = [self.data objectAtRow:move.row col:move.col + 1];
        if (right == [NSNull null]) return true;
    }
    
    return false;
}
-(NSMutableArray *) colorTouchingMoves:(Stone *) move isSame:(bool)isSame {
    NSMutableArray *movesToReturn = [[NSMutableArray alloc] init];
    if (move.row != 0) {
        Stone *top = [self.data objectAtRow:move.row - 1 col:move.col];
        [self addIfColor:top color:move.color array:movesToReturn isSame:isSame];
    }
    
    if (move.row != self.size - 1) {
        Stone *bottom = [self.data objectAtRow:move.row + 1 col:move.col];
        [self addIfColor:bottom color:move.color array:movesToReturn isSame:isSame];
    }
    
    if (move.col != 0) {
        Stone *left = [self.data objectAtRow:move.row col:move.col - 1];
        [self addIfColor:left color:move.color array:movesToReturn isSame:isSame];
    }
    
    if (move.col != self.size - 1) {
        Stone *right = [self.data objectAtRow:move.row col:move.col + 1];
        [self addIfColor:right color:move.color array:movesToReturn isSame:isSame];
    }
    
    return movesToReturn;
}

-(NSMutableArray *) sameColorTouchingMoves: (Stone *) move {
    return [self colorTouchingMoves:move isSame:true];
}

-(NSMutableArray *) oppositeColorTouchingMoves: (Stone *) move {
    return [self colorTouchingMoves:move isSame:false];
}

-(NSMutableArray *) adjacentLiberties:(int)row :(int)col {
    NSMutableArray *movesToReturn = [[NSMutableArray alloc] init];
    if (row != 0) {
        [self addIfEmptySpace:row - 1 :col array:movesToReturn];
    }
    
    if (row != self.size - 1) {
        [self addIfEmptySpace:row + 1 :col array:movesToReturn];
    }
    
    if (col != 0) {
        [self addIfEmptySpace:row :col - 1 array:movesToReturn];
    }
    
    if (col != self.size - 1) {
        [self addIfEmptySpace:row :col + 1 array:movesToReturn];
    }
    
    return movesToReturn;
}

-(void) addIfColor:(Stone *) stone color:(Color)color array:(NSMutableArray *) array isSame:(bool)isSame {
    if (stone == [NSNull null]) {
        return;
    }
    
    bool meetsColorCondition = ((stone.color == color) && isSame) || (stone.color != color && !isSame);
    if (meetsColorCondition && !stone.visited) {
        [array addObject:stone];
    }
}
-(void) addIfEmptySpace:(int)row :(int)col array:(NSMutableArray *) array {
    Stone *stone = [self.data objectAtRow:row col:col];
    if (stone == [NSNull null]) {
        Stone *eStone = [[Stone alloc] initWithColor:None row:row col:col];
        [array addObject:eStone];
    }
}

-(int) countCapturesForGroup:(Stone *) stone removeStones:(bool)removeStones {
    NSMutableArray *capturedStones = [[NSMutableArray alloc] init];
    NSMutableArray *currentStones = [[NSMutableArray alloc] init];
    [self reset];
    [currentStones addObject:stone];
    
    while ([currentStones count] > 0) {
        Stone *currentStone = [currentStones objectAtIndex:0];
        currentStone.visited = true;
        [capturedStones addObject:currentStone];
        [currentStones removeObject:currentStone];
        
        [currentStones addObjectsFromArray:[self sameColorTouchingMoves:currentStone]];
    }
    if (removeStones) {
        for (Stone *stone in capturedStones) {
            [self removeMove:stone];
        }
    }
    return [capturedStones count];
}

-(NSMutableArray *)buildSprites:(int)x :(int)y {
    NSString *cardFileName = @"board.png";
    int boardSize = 300;
    if (self.size == 6) {
        cardFileName = @"6x6board.png";
        boardSize = 230;
    }
    NSMutableArray *sprites = [[NSMutableArray alloc] init];
    
    CCSprite *sprite = [CCSprite spriteWithFile:cardFileName
                                           rect:CGRectMake(0, 0, boardSize, boardSize)];
    sprite.position = ccp(x,y);
    [sprites addObject:sprite];
    for (int i = 0; i<self.size; i++) {
        for (int j = 0; j<self.size; j++) {
            int uirow = self.size - j - 1;
            int uicol = i;
            Stone *temp = [self.data objectAtRow:j col:i];
            if (temp != [NSNull null]) {
                CCSprite *stoneSprite = [temp render];
                stoneSprite.position = ccp(x+[self indexForX:uicol],y+[self indexForY:uirow]);
                [sprites addObject:stoneSprite];
            }
        }
    }
    
    return sprites;
}
-(Board *)copy {
    Board *newBoard = [Board initWithSize:self.size];
    
    NSArray *stones = [self.data getAllData];
    for (Stone *stone in stones) {
        if (stone != [NSNull null]) {
            [newBoard addMove:stone];
        }
    }
    
    return newBoard;
}
-(int)indexForX:(int)x {
    double offset = (self.size == 8) ? 3.5 : 2.5;
    return (x*35 - 35*offset);
}
-(int) indexForY:(int)y {
    double offset = (self.size == 8) ? 3.5 : 2.5;
    return (y*35 - 35*offset);
}
@end
