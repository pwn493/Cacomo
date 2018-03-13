//
//  SceneManager.h
//  Cacomo
//
//  Created by Danny Hyatt on 11/15/12.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MenuLayer.h"

@interface SceneManager : NSObject
+(void)goMenu;
+(void) buildGame:(int)numPlayers boardSize:(int)boardSize handPassing:(bool)enableHandPassing difficulty:(int)difficultyScore;
+(void) goGameScene;
+(void) goAboutScene;
+(void) goTutorial;
+(void) goTutorialPlay;
@end
