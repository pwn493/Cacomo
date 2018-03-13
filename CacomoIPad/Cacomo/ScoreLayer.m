//
//  ScoreLayer.m
//  Cacomo
//
//  Created by Danny Hyatt on 11/20/12.
//
//

#import "ScoreLayer.h"
#import "Game.h"
#import "Player.h"
#import "Stone.h"
#import "SpritePositions.h"
#import "Dialog.h"
#import "SceneManager.h"

@class SceneManager;
@interface ScoreLayer ()
@property bool isDone;
@property (atomic) NSMutableArray *oldScores;
@property float slipTime;
@end

@implementation ScoreLayer
@synthesize isDone = _isDone;
@synthesize teams = _teams;
@synthesize oldScores = _oldScores;


@synthesize slipTime = _slipTime;
static float THINK_TIME=1.0f;

-(id)initWithTeams:(NSArray *)teams {
    if (self = [super init]) {
        _teams = teams;
        _oldScores = [[NSMutableArray alloc] init];
        for (Team *t in _teams) {
            [_oldScores addObject:@(t.points)];
        }
        
        [self renderTeamPoints];
        _isDone = false;
    }
    return self;
}
-(void)renderTeamPoints {
    int position = 0;
    for (Team *team in self.teams) {
        [self renderPoints:team position:position];
        position++;
    }
    [self renderBackButton];
}
-(void)renderPoints:(Team *) team position:(int) pos {
    NSString *name = [NSString stringWithFormat:@"%@ :%i", [Stone colorToString:team.color], team.points];
    CCLabelTTF *score = [CCLabelTTF labelWithString:name fontName:@"Arial-BoldMT" fontSize:28];
    if ([self pointsChanged:team position:pos]) {
        id big = [CCScaleTo actionWithDuration:0.5 scale:1.5];
        id small = [CCScaleTo actionWithDuration:0.5 scale:1.0];
        id act = [CCSequence actions:big, small, nil];
        [score runAction:act];
    }

    score.position = [SpritePositions scoreLocation:pos];
    [self addChild: score];
}
-(bool)pointsChanged:(Team *) team position:(int) pos {
    NSNumber *newPoints = @(team.points);
    NSNumber *oldPoints = [self.oldScores objectAtIndex:pos];
    bool change = newPoints != oldPoints;
    if (change) {
        [self.oldScores replaceObjectAtIndex:pos withObject:@(team.points)];
    }
    return change;
}
-(void)renderBackButton {
    CCMenuItemSprite *button = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"ExitButton.png"] selectedSprite:[CCSprite spriteWithFile:@"ExitAltButton.png"] block:^(id sender) {
        [self renderExitPopup];
    }];
    CCMenu *menu = [CCMenu menuWithItems:button, nil];
    menu.position = [SpritePositions exitButton];
    [self addChild:menu];
}
-(void)renderExitPopup {
    Dialog *d = [[Dialog alloc] initWithString:@"Go back to the main menu?"];
    CGPoint loc = [SpritePositions BoardLocation];
    [self addChild:[d backSprite:loc.x :loc.y]];
    [self addChild:[d textSprite:loc.x :loc.y]];
    [self addChild:[d okCancelSprite:loc.x :loc.y okBlock:^(id sender) {
        [SceneManager goMenu];
    } cancelBlock:^(id sender) {
        [self removeAllChildrenWithCleanup:false];
        [self renderTeamPoints];
    }]];
}
-(void)onNewPlayReady:(NSNotification *)notification {
    if (!self.isDone) {
        [self removeAllChildrenWithCleanup:true];
        [self renderTeamPoints];
    }
}
-(void)onGameFinished:(NSNotification *)notification {
    [self schedule:@selector(pauseForThink:)];
}
-(void)renderFinalScore {
    [self removeAllChildrenWithCleanup:true];
    [self renderTeamPoints];
    
    NSArray *players = [Game getActivePlayers];
    Player *initPlayer = (Player*)[players objectAtIndex:0];
    Team *bestTeam = initPlayer.team;
    
    for (Player *player in players) {
        if (player.team.points > bestTeam.points) {
            bestTeam = player.team;
        }
    }
    
    NSString *victory = [NSString stringWithFormat:@"%@ won!", [Stone colorToString:bestTeam.color]];
    CCLabelTTF *titleCenterTop = [CCLabelTTF labelWithString:victory fontName:@"Arial-BoldMT" fontSize:90];
    
    CCMenuItemSprite *startNew = [self buildMenuSprite:@"BackToMenuButton.png" alt:@"BackToMenuAltButton.png" selector:@selector(onBackToMenu:)];
    CCMenu *menu = [CCMenu menuWithItems:startNew, nil];
    
    CCSprite *backdrop = [[CCSprite alloc] initWithFile:@"popupback.png"];
    backdrop.position = [SpritePositions BoardLocation];
    [self addChild:backdrop];
    self.isDone = true;
    
    titleCenterTop.position = ccp(backdrop.position.x, backdrop.position.y + 70);
    [self addChild: titleCenterTop];
    
    menu.position = ccp(backdrop.position.x, backdrop.position.y - 100);
    [menu alignItemsVerticallyWithPadding: 40.0f];
    [self addChild:menu];
}
-(void) pauseForThink:(ccTime) dt {
    self.slipTime+=dt;
    if(self.slipTime>THINK_TIME) {
        [self unschedule:@selector(pauseForThink:)];

        [self renderFinalScore];
    }
}
-(CCMenuItemSprite *)buildMenuSprite:(NSString *)fileName alt:(NSString *) altFileName selector:(SEL)selector {
    CCSprite *mainSprite = [CCSprite spriteWithFile:fileName];
    CCSprite *selectedSprite = [CCSprite spriteWithFile:altFileName];
    
    return [CCMenuItemSprite itemWithNormalSprite:mainSprite selectedSprite:selectedSprite target:self selector:selector];
}
-(void)onBackToMenu:(id) sender {
    [SceneManager goMenu];
}
@end
