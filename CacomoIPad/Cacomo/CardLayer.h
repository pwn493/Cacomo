//
//  CardLayer.h
//  Cacomo
//
//  Created by Danny Hyatt on 11/15/12.
//
//

#import "CCLayer.h"
#import "BoardLayer.h"
#import "PlayBuilder.h"

@interface CardLayer : CCLayer
extern NSString *const nextRoundReadyEventName;
@property bool isEnabled;
-(id)initWithPlayBuilder:(PlayBuilder *) playBuilder Player:(Player *) player cardLookup:(NSDictionary *)lookup;
-(void)onNextPlayReady:(NSNotification *)notification;
@end
