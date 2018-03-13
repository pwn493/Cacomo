//
//  BasicPlayBuilder.m
//  Cacomo
//
//  Created by Danny Hyatt on 11/19/12.
//
//

#import "BasicPlayBuilder.h"
#import "BasicCard.h"
#import "Play.h"
#import "Player.h"

@implementation BasicPlayBuilder
-(id)init {
    if (self = [super init]) {
        
    }
    return self;
}
-(void)addCardToPlay:(Card *) card player:(Player *)player {
    if (card == nil) {
        [PlayBuilder addNewPlay:[[Play alloc] initWithPlayer:player stone:nil]];
    } else {
        BasicCard *bCard = (BasicCard *)card;
        if (bCard == nil || ![bCard isKindOfClass:[BasicCard class]]) {
            assert(false);
        }
        
        Stone *stone = [[Stone alloc] initWithColor:player.team.color row:bCard.x col:bCard.y];
        Play *play = [[Play alloc] initWithPlayer:player stone:stone];
        [PlayBuilder addNewPlay:play];
    }
    [self playIsReady];
}
-(void)addPotentialCardToPlay:(Card *)card player:(Player *)player {
    BasicCard *bCard = (BasicCard *)card;
    if (bCard == nil || ![bCard isKindOfClass:[BasicCard class]]) {
        assert(false);
    }
    
    Stone *stone = [[Stone alloc] initWithColor:player.team.color row:bCard.x col:bCard.y];
    Play *play = [[Play alloc] initWithPlayer:player stone:stone];
    [PlayBuilder addPotentialPlay:play];
    [self potentialPlayIsReady];
}
-(void)playIsReady {
    [[NSNotificationCenter defaultCenter] postNotificationName:playReadyEventName object:self];
    Stone *stone = [PlayBuilder getCurrentPlay].stone;
    NSString *eventName = [NSString stringWithFormat:@"%d-%dplayed",stone.row,stone.col];
    [[NSNotificationCenter defaultCenter] postNotificationName:eventName object:self];
}
-(void)potentialPlayIsReady {
    [[NSNotificationCenter defaultCenter] postNotificationName:potPlayReadyEventName object:self];
}
-(void)readyForNextTurn {
    [[NSNotificationCenter defaultCenter] postNotificationName:nextTurnEventName object:self];
}
@end
