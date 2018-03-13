//
//  Team.m
//  Cacomo
//
//  Created by Danny Hyatt on 11/17/12.
//
//

#import "Team.h"

@implementation Team
@synthesize color = _color;
@synthesize points = _points;

-(id)initWithColor:(Color)color {
    if ([self init]) {
        _color = color;
        _points = 0;
    }
    return self;
}
@end
