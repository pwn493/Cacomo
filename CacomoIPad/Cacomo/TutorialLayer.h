//
//  TutorialLayer.h
//  Cacomo
//
//  Created by Danny Hyatt on 12/11/12.
//
//

#import "CCLayer.h"
#import "DialogFlow.h"

#import "CardLayer.h"

@interface TutorialLayer : CCLayer
-(id)initWithDialogFlows:(NSArray *)flows cardLayer:(CardLayer *)cardLayer;
@end
