//
//  Team.h
//  Cacomo
//
//  Created by Danny Hyatt on 11/17/12.
//
//

#import <Foundation/Foundation.h>
#import "Stone.h"

@interface Team : NSObject
@property Color color;
@property int points;
-(id)initWithColor:(Color) color;
@end
