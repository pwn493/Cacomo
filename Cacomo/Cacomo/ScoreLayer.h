//
//  ScoreLayer.h
//  Cacomo
//
//  Created by Danny Hyatt on 11/20/12.
//
//

#import "CCLayer.h"
#import "Team.h"

@interface ScoreLayer : CCLayer
@property (nonatomic, strong) NSArray *teams;
-(id)initWithTeams:(NSArray *)teams;
-(void)onNewPlayReady:(NSNotification *)notification;
-(void)onGameFinished:(NSNotification *)notification;
@end
