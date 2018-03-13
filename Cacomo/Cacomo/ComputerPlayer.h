//
//  ComputerPlayer.h
//  Cacomo
//
//  Created by Danny Hyatt on 11/19/12.
//
//

#import <Foundation/Foundation.h>
#import "Player.h"

@interface ComputerPlayer : Player
-(void)createPlay;
-(Card *)selectCardToPlay;
@end
