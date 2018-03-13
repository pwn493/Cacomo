//
//  SpritePositions.m
//  Cacomo
//
//  Created by Danny Hyatt on 12/19/12.
//
//

#import "SpritePositions.h"
#import "Card.h"

@implementation SpritePositions
static int HAND_HEIGHT = 160;
static int DRAW_HEIGHT = 270;
static int DRAW_BORDER = 30;

+(CGPoint)drawDeckLocation {
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    return ccp(winSize.width - (CARD_WIDTH/2 + DRAW_BORDER), DRAW_HEIGHT);
}
+(CGPoint)discardDeckLocation {
    return ccp((CARD_WIDTH/2 + DRAW_BORDER), DRAW_HEIGHT);
}
+(CGPoint)BoardLocation {
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    return ccp(winSize.width/2, winSize.height * 0.65);
}
+(CGPoint)handCenterLocation {
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    return ccp(winSize.width/2, HAND_HEIGHT);
}
+(CGPoint)scoreLocation:(int)scoreIndex {
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    int scoresPerRow = 4;
    int x = scoreIndex%scoresPerRow * (winSize.width/scoresPerRow) + 90;
    int y = winSize.height - ((scoreIndex/scoresPerRow + 1)* (20));
    return ccp(x, y);
}
+(CGPoint)acrossHand {
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    return ccp(winSize.width/2, winSize.height + CARD_HEIGHT);
}
+(CGPoint)leftHand {
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    return ccp(-1 * CARD_WIDTH, winSize.height * 2/3);
}
+(CGPoint)rightHand {
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    return ccp(winSize.width + CARD_WIDTH, winSize.height * 2/3);
}
+(CGPoint)exitButton {
    return ccp(45,45);
}
+(CGPoint)popupHighPosition {
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    return ccp(winSize.width/2,winSize.height * 2/3);
}
+(CGPoint)popupLowPosition {
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    return ccp(winSize.width/2,winSize.height/3);
}
+(int)rowPosition:(int)index size:(int)size {
    int row = size - index - 1;
    int y = [SpritePositions BoardLocation].y;
    double offset = (size == 8) ? 3.5 : 2.5;
    return (row - offset)*76 + y;
}
+(int)colPosition:(int)index size:(int)size {
    int col = index;
    int x = [SpritePositions BoardLocation].x;
    double offset = (size == 8) ? 3.5 : 2.5;
    return (col - offset)*76 + x;
}
@end
