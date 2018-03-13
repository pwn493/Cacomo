//
//  Play.m
//  Cacomo
//
//  Created by Danny Hyatt on 11/17/12.
//
//

#import "Play.h"

@implementation Play
@synthesize player = _player;
@synthesize stone = _stone;

-(id)initWithPlayer:(Player *)player stone:(Stone *)stone {
    if ([self init]) {
        _player = player;
        _stone = stone;
    }
    return self;
}
@end
