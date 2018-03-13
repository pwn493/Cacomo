//
//  DeckLayer.m
//  CacomoCards
//
//  Created by Danny Hyatt on 11/8/12.
//
//

#import "CardLayer.h"
#import "AppDelegate.h"
#import "Card.h"
#import "BasicDeck.h"
#import "Stone.h"
#import "Game.h"
#import "Player.h"
#import "DeckRenderer.h"
#import "SpritePositions.h"
#import "SimpleAudioEngine.h"

@interface CardLayer()
@property (nonatomic, strong) NSMutableDictionary *cardLookup;

@property (nonatomic, strong) PlayBuilder *playBuilder;
@property (nonatomic, strong) Player *player;

@property (nonatomic, strong) CCSprite *selectedSprite;
@property bool hasPlayedThisTurn;
@property bool hasRenderedThisTurn;
@property float slipTime;
@property bool needsGuidance;

@end
@implementation CardLayer
@synthesize cardLookup = _cardLookup;

@synthesize playBuilder = _playBuilder;
@synthesize player = _player;

@synthesize selectedSprite = _selectedSprite;
@synthesize hasPlayedThisTurn = _hasPlayedThisTurn;

@synthesize isEnabled = _isEnabled;
@synthesize hasRenderedThisTurn = _hasRenderedThisTurn;
@synthesize slipTime = _slipTime;

@synthesize needsGuidance = _needsGuidance;

static float PASS_TIME=1.7f;
NSString *const nextRoundReadyEventName = @"nextRoundReadyEvent";

// on "init" you need to initialize your instance
-(id) initWithPlayBuilder:(PlayBuilder *) playBuilder Player:(Player *)player cardLookup:(NSMutableDictionary *)lookup;
{
	// always call "super" init
	if( (self=[super init]) ) {
        _hasPlayedThisTurn = false;
        
        _cardLookup = lookup;
        
        _playBuilder = playBuilder;
        _player = player;
        _slipTime = 0;
        
        [self renderDecks];
        self.isEnabled = true;
        self.isTouchEnabled = true;
        _needsGuidance = true;
        [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"swish.wav"];
	}
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)

    [self.cardLookup release];
    
	// don't forget to call "super dealloc"
	[super dealloc];
}

-(void) renderDecks {
    // cleanup all preexisting sprites
    [self removeAllChildrenWithCleanup:true];
 
    // rerender new sprites
    NSMutableArray *newSprites = [[NSMutableArray alloc] init];

    [newSprites addObjectsFromArray:[DeckRenderer buildDeckSprites:[GameState getDrawDeck] cgpoint:[SpritePositions drawDeckLocation]]];
    [newSprites addObjectsFromArray:[DeckRenderer buildDeckSprites:[GameState getDiscardDeck] cgpoint:[SpritePositions discardDeckLocation]]];
    [newSprites addObjectsFromArray:[DeckRenderer buildDeckSprites:self.player.hand cgpoint:[SpritePositions handCenterLocation]]];
    for (CCSprite *sprite in newSprites) {
        [self addChild:sprite];
    }
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![Game isLocalPlayerTurn] || self.hasPlayedThisTurn || !self.isEnabled) {
        return;
    }

    // Choose one of the touches to work with
    Card *myCard = nil;
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    for (CCSprite *card in self.children) {
        CGRect targetRect = CGRectMake(
                                       card.position.x - (card.contentSize.width/2),
                                       card.position.y - (card.contentSize.height/2),
                                       card.contentSize.width,
                                       card.contentSize.height);
        
        if (CGRectContainsPoint(targetRect, location)) {
            myCard = [self getCardForSprite:card];
            if (myCard != nil) {
                if ([self.player.hand contains:myCard] && self.selectedSprite != card) {
                    self.selectedSprite = card;
                    self.selectedSprite.position = ccp(self.selectedSprite.position.x, self.selectedSprite.position.y + 10);
                    self.selectedSprite.opacity = 255;
                    [self cardSelected:self.selectedSprite];
                    
                    if (self.needsGuidance) {
                        [self.selectedSprite runAction:[self waitAndWiggle:self.selectedSprite]];
                    }
                    for (CCSprite *handCard in self.children) {
                        // if sprite is for a card in the hand and not the selected sprite
                        Card *myHandCard = [self getCardForSprite:handCard];
                        if (handCard != self.selectedSprite && [self.player.hand contains:myHandCard]) {
                            [[SimpleAudioEngine sharedEngine] playEffect:@"swish.wav"];
                            CGPoint handCoor = [SpritePositions handCenterLocation];
                            handCard.position = ccp(handCard.position.x, handCoor.y);
                            //handCard.opacity = 150;
                            [handCard stopAllActions];
                        }
                    }
                    // add potential move
                    [self sendPotentialMoveToBoard:[self getCardForSprite:card]];
                } else {
                    if ([self.player.hand contains:myCard]) {
                        [[GameState getDiscardDeck] add:myCard];
                        [self.player.hand remove:myCard];
                        [self sendMoveToBoard:myCard];
                        [self renderDecks];
                        self.hasPlayedThisTurn = true;
                        break;
                    }
                }
            }
        }
    }
}
-(Card *) getCardForSprite:(CCSprite *) sprite {
    NSString *key = (NSString *)sprite.userData;
    return [self.cardLookup objectForKey:key];
}

-(void) sendMoveToBoard:(Card *)card {
    self.needsGuidance = false;
    [self.playBuilder addCardToPlay:card player:self.player];
}

-(void) sendPotentialMoveToBoard:(Card *) card {
    [self.playBuilder addPotentialCardToPlay:card player:self.player];
}
-(void)preNextRoundReady:(NSNotification *) notification {
    NSArray *handSprites = [DeckRenderer renderHandPass:self.player.hand cgpoint:[SpritePositions handCenterLocation]];
    [self removeAllChildrenWithCleanup:true];
    // rerender new sprites
    NSMutableArray *newSprites = [[NSMutableArray alloc] init];
    
    [newSprites addObjectsFromArray:[DeckRenderer buildDeckSprites:[GameState getDrawDeck] cgpoint:[SpritePositions drawDeckLocation]]];
    [newSprites addObjectsFromArray:[DeckRenderer buildDeckSprites:[GameState getDiscardDeck] cgpoint:[SpritePositions discardDeckLocation]]];
    [newSprites addObjectsFromArray:handSprites];
    
    for (CCSprite *sprite in newSprites) {
        [self addChild:sprite];
    }
    self.slipTime = 0;
    [self schedule:@selector(pauseForPass:)];
    self.hasRenderedThisTurn = true;
}
-(void)onNextRoundReady:(NSNotification *)notification {
    self.hasPlayedThisTurn = false;
    [self.player drawToFullHand];
    [self renderDecks];
    self.hasRenderedThisTurn = true;
}
-(void)onPlayReady:(NSNotification *)notification {
    if (!self.hasRenderedThisTurn) {
        [self renderDecks];
    }
    self.hasRenderedThisTurn = false;
}
-(CCSequence *)waitAndWiggle:(CCSprite *)sprite {
    int wiggleRoom = 4;
    int numWiggles = 10;
    id delay = [CCDelayTime actionWithDuration:2];
    
    NSMutableArray *actions = [[NSMutableArray alloc] init];
    [actions addObject:delay];
    
    for (int i=0; i<numWiggles; i++) {
        [actions addObject:[CCMoveTo actionWithDuration:0.1 position:ccp(sprite.position.x, sprite.position.y
                                                                         +wiggleRoom)]];
        [actions addObject:[CCMoveTo actionWithDuration:0.1 position:ccp(sprite.position.x, sprite.position.y)]];
    }

    return [CCSequence actionWithArray:actions];
}
-(void)cardSelected:(CCSprite *)card {
    NSString *eventName = [NSString stringWithFormat:@"%@selected", card.userData];
    [[NSNotificationCenter defaultCenter] postNotificationName:eventName object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cardSelected" object:self];
}
-(void)onStateUpdated:(NSNotification *)notification {
    [self onNextRoundReady:nil];
}
-(void) pauseForPass:(ccTime) dt {
    self.slipTime+=dt;
    if(self.slipTime>PASS_TIME) {
        [self unschedule:@selector(pauseForPass:)];
        [[NSNotificationCenter defaultCenter] postNotificationName:nextRoundReadyEventName object:self];
    }
}
@end
