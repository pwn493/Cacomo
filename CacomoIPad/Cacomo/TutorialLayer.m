//
//  TutorialLayer.m
//  Cacomo
//
//  Created by Danny Hyatt on 12/11/12.
//
//

#import "TutorialLayer.h"
#import "DialogFlow.h"
#import "AppDelegate.h"
#import "Game.h"
#import "SpritePositions.h"

@interface TutorialLayer()
@property (nonatomic,strong) NSMutableArray *dialogFlow;
@property int currentFlowIndex;
@property (assign) CardLayer *cardLayer;
//@property (nonatomic,strong) CCSprite *okayButton;
@property float slipTime;
@property float waitTime;

@end
@implementation TutorialLayer
@synthesize dialogFlow = _dialogFlow;
@synthesize currentFlowIndex = _currentFlowIndex;
//@synthesize okayButton = _okayButton;
@synthesize cardLayer = _cardLayer;
@synthesize slipTime = _slipTime;
@synthesize waitTime = _waitTime;

-(id)initWithDialogFlows:(NSArray *)flows cardLayer:(CardLayer *)cardLayer {
    if (self = [super init]) {
        _dialogFlow = [[NSMutableArray alloc] init];
        [_dialogFlow addObjectsFromArray:flows];
//        _okayButton = nil;
        _currentFlowIndex = 0;
        _cardLayer = cardLayer;
        
        _cardLayer.isEnabled = false;
        
         self.isTouchEnabled = true;
        [self renderCurrentFlow];
    }
    
    return self;
}
-(void)renderCurrentFlow {
    if (_currentFlowIndex >= [self.dialogFlow count]) {
        [SceneManager goTutorialPlay];
        return;
    }
    [self removeAllChildrenWithCleanup:true];
    Dialog *currentDialog = [self getCurrentDialog];
    
    [self pauseThenRender:currentDialog];
}
-(void)addDialog:(Dialog *)dialog {
    if (dialog.isInvisible) {
        self.cardLayer.isEnabled = true;
        dialog.hasRendered = true;
        [self setLocalPlayer];
        return;
    }
    
    CGPoint dialogLoc = (dialog.isLow) ? [SpritePositions popupLowPosition] : [SpritePositions popupHighPosition];
    int height = dialogLoc.y;
    int width = dialogLoc.x;
    
    CCMenu *okay = [dialog okSprite:width :height block:^(id sender) {
        [self goToNextDialog];
    }];
    [self addChild:[dialog backSprite:dialogLoc.x :dialogLoc.y]];
    if (okay != nil) {
        [self addChild:okay];
        self.cardLayer.isEnabled = false;
    } else {
        self.cardLayer.isEnabled = true;
    }
    [self addChild:[dialog textSprite:dialogLoc.x :dialogLoc.y]];
    
    for (CCSprite *sprite in dialog.sprites) {
        [self addChild:sprite];
    }
}
//- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    // Choose one of the touches to work with
//    UITouch *touch = [touches anyObject];
//    CGPoint location = [touch locationInView:[touch view]];
//    location = [[CCDirector sharedDirector] convertToGL:location];
//    
//    for (CCSprite *sprite in self.children) {
//        CGRect targetRect = CGRectMake(
//                                       sprite.position.x - (sprite.contentSize.width/2),
//                                       sprite.position.y - (sprite.contentSize.height/2),
//                                       sprite.contentSize.width,
//                                       sprite.contentSize.height);
//        
//        if (CGRectContainsPoint(targetRect, location)) {
//            if (sprite == self.okayButton || [self getCurrentDialog].isReadyForNext) {
//                [self goToNextDialog];
//                break;
//            }
//        }
//    }
//}

-(void)goToNextDialog {
    [[self getCurrentFlow] next];
    Dialog *next = [self getCurrentDialog];
    if (next == nil) {
        self.currentFlowIndex++;
    }
    
    [self renderCurrentFlow];
}
-(Dialog *)getCurrentDialog {
    return [[self getCurrentFlow] getCurrent];
}
-(DialogFlow *)getCurrentFlow {
    return [self.dialogFlow objectAtIndex:self.currentFlowIndex];
}
-(void)setLocalPlayer {
    while (![Game isLocalPlayerTurn]) {
        [Game updateCurrentPlayer];
    }
}
-(void)pauseThenRender:(Dialog *)dialog {
    self.slipTime=0.f;
    self.waitTime=dialog.delayInSeconds;
    [self schedule:@selector(pauseForThink:)];
}
-(void) pauseForThink:(ccTime) dt {
    self.slipTime+=dt;
    if(self.slipTime>self.waitTime) {
        [self unschedule:@selector(pauseForThink:)];
        
        [self addDialog:(Dialog *)[self getCurrentDialog]];
        if ([[self getCurrentDialog] hasMechanicChange]) {
            [[self getCurrentDialog] callMechanicChange];
        }
        [[self getCurrentDialog] updateState];
    }
}
-(void)onTaskCompleted:(NSNotification *)sender {
    [self goToNextDialog];
}
@end
