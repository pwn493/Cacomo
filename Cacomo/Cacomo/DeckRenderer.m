//
//  DeckRenderer.m
//  Cacomo
//
//  Created by Danny Hyatt on 12/5/12.
//
//

#import "DeckRenderer.h"
#import "SpritePositions.h"
#import "Game.h"

@implementation DeckRenderer
+(NSArray *)buildDeckSprites:(Deck *)deck cgpoint:(CGPoint) coor {
    if ([deck count] > 0) {
        if (deck.isStacked) {
            return [[DeckRenderer renderDeck:deck cgpoint:coor] copy];
        } else {
            return [[DeckRenderer renderHand:deck cgpoint:coor] copy];
        }
    }
    
    return nil;
}
+(NSMutableArray *)renderHand:(Deck *) deck cgpoint:(CGPoint) coor {
    NSMutableArray *deckSprites = [[NSMutableArray alloc] init];
    int startx = (int)((-(float)([deck count] - 1) / 2) * CARD_WIDTH);
    NSArray *cards = [deck getCards];
    
    int index = startx;
    int newCardIndex = 0;
    for (int i=0; i < [deck count]; i++) {
        Card *card = [cards objectAtIndex:i];
        CCSprite *sprite = [card buildSprite];
        sprite.zOrder = 5;
        
        [deckSprites addObject:sprite];
        
        if (card.isPassed) {
            // pull from the correct location to center;
            int playerCount = [[Game getActivePlayers] count];
            if (playerCount == 2) {
                // pass straight
                sprite.position = [SpritePositions acrossHand];
            } else {
                sprite.position = [SpritePositions rightHand];
            }
            
            id moveDown = [CCMoveTo actionWithDuration:0.3 position:[SpritePositions handCenterLocation]];
            
            // accordian appropriately
            id spread = [CCMoveTo actionWithDuration:0.4 position:ccp(coor.x + index, coor.y)];
            id sequence = [CCSequence actions:moveDown, spread, nil];
            [sprite runAction:sequence];
            card.isPassed = false;
        }
        else if (card.isNew) {
            sprite.position = [SpritePositions drawDeckLocation];
            sprite.scale = 0.5;
            id delay = [CCDelayTime actionWithDuration:(0.1 * newCardIndex)];
            id move = [CCMoveTo actionWithDuration:0.2 position:ccp(coor.x + index, coor.y)];
            id scale = [CCScaleTo actionWithDuration:0.2 scale:1];
            id draw = [CCSpawn actions:move, scale, nil];
            id sequence = [CCSequence actions:delay, draw, nil];
            [sprite runAction:sequence];
            newCardIndex++;
            card.isNew = false;
        } else {
            sprite.position = ccp(coor.x + index, coor.y);
        }
        index += CARD_WIDTH;
    }
    
    return deckSprites;
}
+(NSMutableArray *)renderDeck:(Deck *) deck cgpoint:(CGPoint) coor{
    Card *next;
    NSMutableArray *deckSprites = [[NSMutableArray alloc] init];
    
    if (deck.isVisible) {
        next = [deck getCard:[deck count] - 1];
    } else {
        next = [deck getCard:0];
    }
    next.isVisible = deck.isVisible;
    
    CCSprite *sprite = [next buildSprite];
    sprite.zOrder = 4;
    
    int numToStack = ([deck count] > 3) ? 3 : [deck count];
    int separation = 3;
    int offset = numToStack * separation;
    sprite.position = ccp(coor.x - offset, coor.y + offset);
    
    for (int i=1; i < numToStack; i++) {
        CCSprite *backSprite = [next buildSprite];
        backSprite.position = ccp(coor.x - offset + i*separation, coor.y + offset - i*separation);
        backSprite.zOrder = numToStack - i;
        [deckSprites addObject:backSprite];
    }
    
    [deckSprites addObject:sprite];
    
    return deckSprites;
}
+(NSArray *)renderHandPass:(Deck *) deck cgpoint:(CGPoint) coor {
    NSMutableArray *deckSprites = [[NSMutableArray alloc] init];
    int startx = (int)((-(float)([deck count] - 1) / 2) * CARD_WIDTH);
    NSArray *cards = [deck getCards];
    
    int index = startx;
    int newCardIndex = 0;
    for (int i=0; i < [deck count]; i++) {
        Card *card = [cards objectAtIndex:i];
        CCSprite *sprite = [card buildSprite];
        sprite.zOrder = 5;
        
        [deckSprites addObject:sprite];
    
        sprite.position = ccp(coor.x + index, coor.y);
        // pass from the hand center to the correct location;
        int playerCount = [[Game getActivePlayers] count];
        CGPoint moveTo;
        if (playerCount == 2) {
            // pass straight
            moveTo = [SpritePositions acrossHand];
        } else {
            moveTo = [SpritePositions leftHand];
        }
        
        id delay = [CCDelayTime actionWithDuration:1.0];
        id moveUp = [CCMoveTo actionWithDuration:0.3 position:moveTo];
        
        // accordian appropriately
        id bunch = [CCMoveTo actionWithDuration:0.2 position:coor];
        id sequence = [CCSequence actions:delay, bunch, moveUp, nil];
        [sprite runAction:sequence];
        
        index += CARD_WIDTH;
    }
    
    return deckSprites;
}
@end
