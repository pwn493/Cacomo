//
//  WaitingDialog.m
//  Cacomo
//
//  Created by Danny Hyatt on 12/12/12.
//
//

#import "WaitingDialog.h"
@class GameState;
@interface WaitingDialog ()
@property bool isReady;
@end
@implementation WaitingDialog
NSString *const taskCompletedEventName = @"taskCompletedEvent";
@synthesize isReady = _isReady;

-(id)initWithString:(NSString *)text EventName:(NSString *)name ActionObject:(id)actionObject {
    if (self = [super init]) {
        self.text = text;
        _isReady = false;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAction:) name:name object:actionObject];
    }
    return self;
}
-(bool)isReadyForNext {
    return self.isReady;
}
-(CCMenu *)okSprite:(int)x :(int)y block:(void (^)(id))block {
    return nil;
}
-(void)onAction:(NSNotification *)sender {
    if (!self.isReady && self.hasRendered) {
        self.isReady = true;
        [[NSNotificationCenter defaultCenter] postNotificationName:taskCompletedEventName object:[GameState getInstance]];
    }
}
@end
