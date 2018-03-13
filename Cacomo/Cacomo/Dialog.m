//
//  Dialog.m
//  Cacomo
//
//  Created by Danny Hyatt on 12/11/12.
//
//

#import "Dialog.h"
#import "CCLayer.h"
#import "cocos2d.h"
#import "Game.h"
#import "Player.h"
@interface Dialog()
@property SEL updateFunc;
@property id updateObject;
@end
@implementation Dialog

@synthesize isLow = _isLow;
@synthesize drawDeck = _drawDeck;
@synthesize board = _board;
@synthesize sprites = _sprites;
@synthesize isInvisible = _isInvisible;
@synthesize delayInSeconds = _delayInSeconds;
@synthesize hasRendered = _hasRendered;
@synthesize updateFunc = _updateFunc;
@synthesize updateObject = _updateObject;

-(id)initWithString:(NSString *)text {
    if ([self init]) {
        _text = text;
        _isLow = false;
        _drawDeck = nil;
        _board = nil;
        _sprites = [[NSMutableArray alloc] init];
        _isInvisible = false;
        _hasRendered = false;
        _delayInSeconds = 0;
        _updateObject = nil;
    }
    return self;
}
-(CCLabelTTF *)textSprite:(int)x :(int)y {
    CGSize size = CGSizeMake(275, 150);
    CCLabelTTF *text = [CCLabelTTF labelWithString:self.text dimensions:size hAlignment:UITextAlignmentCenter fontName:@"Arial-BoldMT" fontSize:24];
    text.position = ccp(x, y);
    self.hasRendered = true;
    return text;
}
-(CCSprite *)backSprite:(int)x :(int)y {
    CCSprite *backdrop = [[CCSprite alloc] initWithFile:@"popupback.png" rect:CGRectMake(0, 0, 280, 200)];
    backdrop.position = ccp(x,y);
    
    return backdrop;
}
-(bool)isReadyForNext {
    return false;
}
-(bool)hasMechanicChange {
    return self.updateObject != nil;
}
-(CCMenu *)okSprite:(int)x :(int)y block:(void (^)(id))block {
    CCMenuItemSprite *item = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"okay.png"] selectedSprite:[CCSprite spriteWithFile:@"okayAlt.png"] block:block];
    CCMenu *menu = [CCMenu menuWithItems:item, nil];
    menu.position = ccp(x, y - 70);
    return menu;
}
-(CCMenu *)okCancelSprite:(int)x :(int)y okBlock:(void (^)(id))okBlock cancelBlock:(void (^)(id))cancelBlock {
    CCMenuItemSprite *item = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"okay.png"] selectedSprite:[CCSprite spriteWithFile:@"okayAlt.png"] block:okBlock];
    CCMenuItemSprite *item2 = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"Cancel.png"] selectedSprite:[CCSprite spriteWithFile:@"cancelAltButton.png"] block:cancelBlock];
    CCMenu *menu = [CCMenu menuWithItems:item, item2, nil];
    [menu alignItemsHorizontallyWithPadding:20];
    menu.position = ccp(x, y - 70);
    return menu;
}
-(void)updateState {
    if (self.board != nil) {
        [GameState updateBoard:self.board];
    }
    
    if (self.drawDeck != nil) {
        NSArray *players = [Game getActivePlayers];
        
        [GameState updateDiscardDeck:[[Deck alloc] initWithUI:true stacked:true]];
        for (Player *player in players) {
            [player resetHand];
        }
        [GameState updateDrawDeck:self.drawDeck];
    }
}
-(void)updateMechanicChange:(SEL)func object:(id)object{
    self.updateFunc = func;
    self.updateObject = object;
}
-(void)callMechanicChange {
    [self.updateObject performSelector:self.updateFunc];
}
@end
