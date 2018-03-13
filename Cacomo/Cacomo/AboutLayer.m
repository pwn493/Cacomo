//
//  AboutLayer.m
//  Cacomo
//
//  Created by Danny Hyatt on 1/10/13.
//
//

#import "AboutLayer.h"
#import "cocos2d.h"
#import "SceneManager.h"


@implementation AboutLayer

-(id)init {
    if (self = [super initWithColor:ccc4(50, 50, 255, 255)]) {
        [self renderAboutText];
        [self renderReturnButton];
    }
    
    return self;
}
-(void)renderAboutText {
    NSString *text = @"Cacomo is based on the board game Go. If you like Cacomo, you should give Go a try!\n\nCacomo started life as a board game created by Shinkai Hiroko(5p).\n\nThe Cacomo app was created by Danny Hyatt. Thank you for buying my game!";
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CGSize size = CGSizeMake(winSize.width - 5, winSize.height - 5);
    CCLabelTTF *label = [CCLabelTTF labelWithString:text dimensions:size hAlignment:UITextAlignmentLeft fontName:@"Arial-BoldMT" fontSize:20];;

    label.position = ccp(winSize.width/2, winSize.height/2);
    [self addChild: label];
}
-(void) renderReturnButton {
    CCMenuItemSprite *returnToMenu = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"BackToMenuButton.png"] selectedSprite:[CCSprite spriteWithFile:@"BackToMenuAltButton.png"] block:^(id sender) {
        [SceneManager goMenu];
    }];
    
    CCMenu *menu = [CCMenu menuWithItems:returnToMenu, nil];
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    menu.position = ccp(winSize.width / 2, 70);
    [self addChild:menu];
}
@end
