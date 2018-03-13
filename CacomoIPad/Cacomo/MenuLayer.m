//
//  MenuLayer.m
//  Cacomo
//
//  Created by Danny Hyatt on 11/15/12.
//
//

#import "MenuLayer.h"

@implementation MenuLayer
static NSString *FONT = @"Arial-BoldMT";
static int BIG = 148;
-(id) init {
    if (self = [super initWithColor:ccc4(50, 50, 255, 255)]) {
        CCLabelTTF *titleCenterTop = [CCLabelTTF labelWithString:@"Cacomo" fontName:FONT fontSize:BIG];

        CCMenuItemSprite *newGame =  [self buildMenuSprite:@"NewGameButton.png" alt:@"NewGameAltButton.png" selector:@selector(onNewGame:)];
        CCMenuItemSprite *tutorial = [self buildMenuSprite:@"TutorialButton.png" alt:@"TutorialAltButton.png" selector:@selector(onTutorial:)];
        CCMenuItemSprite *credits = [self buildMenuSprite:@"CreditsButton.png" alt:@"CreditsAltButton.png" selector:@selector(onCredits:)];

        CCMenu *menu = [CCMenu menuWithItems:newGame, tutorial, credits, nil];

        CGSize winSize = [[CCDirector sharedDirector] winSize];
        titleCenterTop.position = ccp(winSize.width/2, winSize.height * 0.83);
        [self addChild: titleCenterTop];

        menu.position = ccp(winSize.width/2, winSize.height * 0.45);
        [menu alignItemsVerticallyWithPadding: 80.0f];
        [self addChild:menu z: 2];
    }

    return self;

}
-(CCMenuItemSprite *)buildMenuSprite:(NSString *)fileName alt:(NSString *)altFileName selector:(SEL)selector {
    CCSprite *mainSprite = [CCSprite spriteWithFile:fileName];
    CCSprite *selectedSprite = [CCSprite spriteWithFile:altFileName];
    
    return [CCMenuItemSprite itemWithNormalSprite:mainSprite selectedSprite:selectedSprite target:self selector:selector];
}
-(void)onNewGame:(id)sender {
    [SceneManager goGameScene];
}
-(void)onTutorial:(id)sender {
    [SceneManager goTutorial];
}
-(void)onCredits:(id)sender {
    [SceneManager goAboutScene];
}
@end
