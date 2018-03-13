//
//  PlayBuilder.m
//  Cacomo
//
//  Created by Danny Hyatt on 11/19/12.
//
//

#import "PlayBuilder.h"


@implementation PlayBuilder
static Play *lastPlay;
static Play *currentPlay;
static Play *potentialPlay;
NSString *const playReadyEventName = @"playReadyEvent";
NSString *const potPlayReadyEventName = @"potPlayReadyEvent";
NSString *const nextTurnEventName = @"nextTurnEvent";

+(id) init {
    if ([self init]) {
        
    }
    return self;
}
+(Play *)getLastPlay {
    return lastPlay;
}

+(Play *)getCurrentPlay {
    return currentPlay;
}

+(Play *)getPotentialPlay {
    return potentialPlay;
}

+(void)addNewPlay:(Play *)play {
    lastPlay = currentPlay;
    currentPlay = play;
}

+(void)addPotentialPlay:(Play *)play {
    potentialPlay = play;
}
@end
