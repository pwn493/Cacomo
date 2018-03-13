//
//  BoardLayer.h
//  Cacomo
//
//  Created by Danny Hyatt on 11/16/12.
//
//

#import "CCLayer.h"
#import "Board.h"

@interface BoardLayer : CCLayerColor
-(id) init;
-(void) onNewPlayReady:(NSNotification *)notification;
-(void) onPotentialPlayReady:(NSNotification *)notification;
@end
