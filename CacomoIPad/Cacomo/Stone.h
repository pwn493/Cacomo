//
//  Stone.h
//  CacomoBoard
//
//  Created by Danny Hyatt on 11/12/12.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Stone : NSObject

typedef NS_ENUM(NSInteger, Color) {
    Black,
    White,
    Red,
    Green,
    Yellow,
    None
};
@property int row;
@property int col;

@property bool visited;
@property Color color;
@property bool potentialMove;

-(CCSprite *) render;
-(void) reset;
-(id) initWithColor:(Color) color row:(int)row col:(int)col;
+(NSString *) colorToString:(Color) color;
@end
