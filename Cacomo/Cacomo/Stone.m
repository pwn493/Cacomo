//
//  Stone.m
//  CacomoBoard
//
//  Created by Danny Hyatt on 11/12/12.
//
//

#import "Stone.h"

@implementation Stone
@synthesize row = _row;
@synthesize col = _col;
@synthesize visited = _visited;
@synthesize color = _color;
@synthesize potentialMove = _potentialMove;

-(CCSprite *)render {
    NSString *cardFileName = [NSString stringWithFormat:@"%@Stone.png", [Stone colorToString:self.color]];
    
    CCSprite *sprite = [CCSprite spriteWithFile:cardFileName
                                           rect:CGRectMake(0, 0, 35, 35)];
    
    if (self.potentialMove) {
        sprite.opacity = 150;
        [sprite runAction:[CCBlink actionWithDuration:15 blinks:20]];
    }
    
    return sprite;
}
-(id)initWithColor:(Color)color row:(int)row col:(int)col {
    if ([self init]) {
        _row = row;
        _col = col;
        _color = color;
        _visited = false;
        _potentialMove = false;
    }
    return self;
}

-(void)reset {
    self.visited = false;
}

+(NSString *)colorToString:(Color)color {
    if (color == Black) {
        return @"blue";
    } else if (color == White) {
        return @"white";
    } else if (color == Red) {
        return @"red";
    } else if (color == Green) {
        return @"green";
    } else if (color == Yellow) {
        return @"yellow";
    } else {
        return @"None";
    }
}
@end
