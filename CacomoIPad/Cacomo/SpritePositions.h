//
//  SpritePositions.h
//  Cacomo
//
//  Created by Danny Hyatt on 12/19/12.
//
//

#import <Foundation/Foundation.h>

@interface SpritePositions : NSObject
+(CGPoint)drawDeckLocation;
+(CGPoint)discardDeckLocation;
+(CGPoint)scoreLocation:(int) scoreIndex;
+(CGPoint)BoardLocation;
+(CGPoint)handCenterLocation;
+(CGPoint)acrossHand;
+(CGPoint)leftHand;
+(CGPoint)rightHand;
+(CGPoint)exitButton;
+(CGPoint)popupHighPosition;
+(CGPoint)popupLowPosition;
+(int)rowPosition:(int) index size:(int) size;
+(int)colPosition:(int) index size:(int) size;
@end
