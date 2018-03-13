//
//  SceneManager.m
//  Cacomo
//
//  Created by Danny Hyatt on 11/15/12.
//
//

#import "SceneManager.h"
#import "CardLayer.h"
#import "BoardLayer.h"
#import "ScoreLayer.h"
#import "BasicGame.h"
#import "BasicPlayBuilder.h"
#import "LocalPlayer.h"
#import "ComputerPlayer.h"
#import "DummyComputerPlayer.h"
#import "BasicDeck.h"
#import "TutorialLayer.h"
#import "DialogBuilder.h"
#import "WaitingDialog.h"
#import "HardComputerPlayer.h"
#import "MediumComputerPlayer.h"
#import "GameSelectLayer.h"
#import "AboutLayer.h"

@implementation SceneManager
+(void)goMenu {
    CCLayer *layer = [MenuLayer node];
    NSArray *layers = [[NSArray alloc] initWithObjects:layer, nil];
    [SceneManager go:layers];
}
+(NSArray *) buildPlayers:(int)howMany difficultyScore:(int)difficulty playBuilder:(PlayBuilder *)playBuilder {
    NSMutableArray *players = [[NSMutableArray alloc] init];
    Color secondColor = White;
    if (howMany > 2) {
        secondColor = Red;
    }
    for (int i = 0; i < howMany; i++) {
        Color c;
        switch (i) {
            case 0:
                c = Black;
                break;
                
            case 1:
                c = secondColor;
                break;
                
            case 2:
                c = Green;
                break;
            
            case 3:
                c = Yellow;
                break;
            default:
                break;
        }
        Team *team = [[Team alloc] initWithColor:c];
        Player *p;
        if (i == 0) {
            p = [[LocalPlayer alloc] initWithHandSize:5 team:team playBuilder:playBuilder];
        } else {
            p = [self buildPlayer:team difficultyScore:difficulty playBuilder:playBuilder];
        }
        
        [players addObject:p];
    }

    return [players copy];
}
+(Player *) buildPlayer:(Team *)team difficultyScore:(int)difficulty playBuilder:(PlayBuilder *)playBuilder {
    switch (difficulty) {
        case 0:
            return [[ComputerPlayer alloc] initWithHandSize:5 team:team playBuilder:playBuilder];
            break;
        
        case 1:
            return [[MediumComputerPlayer alloc] initWithHandSize:5 team:team playBuilder:playBuilder];
            break;
            
        case 2:
            return [[HardComputerPlayer alloc] initWithHandSize:5 team:team playBuilder:playBuilder];
            break;
            
        default:
            return nil;
            break;
    }
}
+(NSArray *)buildTeamsFromPlayers:(NSArray *) players {
    NSMutableArray *teams = [[NSMutableArray alloc] init];
    
    for (Player *p in players) {
        [teams addObject:p.team];
    }
    
    return [teams copy];
}
+(void) buildGame:(int)numPlayers boardSize:(int)boardSize handPassing:(bool)enableHandPassing difficulty:(int)difficultyScore {
    PlayBuilder *playBuilder = [[BasicPlayBuilder alloc] init];
    
    [self buildDefaultGameStateWithBoardSize:boardSize isTutorial:false];
    [GameState updateHandPassing:enableHandPassing];
    NSMutableDictionary *lookup = [[GameState getDrawDeck] buildLookupTable];

    NSArray *players = [self buildPlayers:numPlayers difficultyScore:difficultyScore playBuilder:playBuilder];
    NSArray *teams = [self buildTeamsFromPlayers:players];
    
    Game *game = [[BasicGame alloc] initWithPlayers:players playBuilder:playBuilder];
    BoardLayer *boardLayer = [[BoardLayer alloc] init];
    ScoreLayer *scoreLayer = [[ScoreLayer alloc] initWithTeams:teams];
    
    CCLayer *cardLayer = [[CardLayer alloc] initWithPlayBuilder:playBuilder Player:[players objectAtIndex:0] cardLookup:lookup];
    NSArray *layers = [[NSArray alloc] initWithObjects:boardLayer, cardLayer, scoreLayer, nil];
    
    [SceneManager setupNotifications:playBuilder boardLayer:boardLayer scoreLayer:scoreLayer cardLayer:cardLayer game:game];
    
    [SceneManager go:layers];
}
+(void) goGameScene {
    GameSelectLayer *layer = [[GameSelectLayer alloc] init];
    NSArray *layers = [[NSArray alloc] initWithObjects:layer, nil];
    [SceneManager go:layers];
}
+(void)goAboutScene {
    AboutLayer *layer = [[AboutLayer alloc] init];
    NSArray *layers = [[NSArray alloc] initWithObjects:layer, nil];
    [SceneManager go:layers];
}
+(void)goTutorial {
    PlayBuilder *playBuilder = [[BasicPlayBuilder alloc] init];

    GameState *instance = [self buildDefaultGameStateWithBoardSize:8 isTutorial:true];
    NSMutableDictionary *lookup = [[GameState getDrawDeck] buildLookupTable];
    [[GameState getDrawDeck] removeAll];
    [GameState updateHandPassing:false];
    
    Team *black = [[Team alloc] initWithColor:Black];
    Team *white = [[Team alloc] initWithColor:White];
    
    Player *me = [[LocalPlayer alloc] initWithHandSize:5 team:black playBuilder:playBuilder];
    Player *dummy = [[DummyComputerPlayer alloc] initWithHandSize:0 team:white playBuilder:playBuilder];
    
    NSArray *players = [[NSArray alloc] initWithObjects:me, dummy, nil];
    NSArray *teams = [[NSArray alloc] initWithObjects:black, white, nil];
    
    Game *game = [[BasicGame alloc] initWithPlayers:players playBuilder:playBuilder];
    BoardLayer *boardLayer = [[BoardLayer alloc] init];
    ScoreLayer *scoreLayer = [[ScoreLayer alloc] initWithTeams:teams];
    CardLayer *cardLayer = [[CardLayer alloc] initWithPlayBuilder:playBuilder Player:me cardLookup:lookup];
    NSMutableArray *dialogFlows = [[NSMutableArray alloc]init];
    [dialogFlows addObject:[DialogBuilder cardsAndStones:cardLayer playBuilder:playBuilder cardLookup:lookup]];
    [dialogFlows addObject:[DialogBuilder capturingStones:playBuilder cardLookup:lookup]];
    [dialogFlows addObject:[DialogBuilder theDeck:playBuilder cardLookup:lookup]];
    [dialogFlows addObject:[DialogBuilder selfCapture:playBuilder cardLookup:lookup]];
    [dialogFlows addObject:[DialogBuilder finalTest]];
    TutorialLayer *tutorialLayer = [[TutorialLayer alloc] initWithDialogFlows:dialogFlows cardLayer:cardLayer];
    tutorialLayer.zOrder = 2;
    scoreLayer.zOrder = 3;

    NSArray *layers = [[NSArray alloc] initWithObjects:boardLayer, tutorialLayer, cardLayer, scoreLayer, nil];
    
    [SceneManager setupNotifications:playBuilder boardLayer:boardLayer scoreLayer:scoreLayer cardLayer:cardLayer game:game endGame:false];
    [[NSNotificationCenter defaultCenter] addObserver:cardLayer selector:@selector(onStateUpdated:) name:cardStateUpdateEventName object:instance];
    [[NSNotificationCenter defaultCenter] addObserver:boardLayer selector:@selector(onStateUpdated:) name:boardStateUpdateEventName object:instance];
    [[NSNotificationCenter defaultCenter] addObserver:tutorialLayer selector:@selector(onTaskCompleted:) name:taskCompletedEventName object:instance];
    [SceneManager go:layers];
}
+(void)goTutorialPlay {
    PlayBuilder *playBuilder = [[BasicPlayBuilder alloc] init];
    
    [self buildDefaultGameStateWithBoardSize:6 isTutorial:false];
    NSMutableDictionary *lookup = [[GameState getDrawDeck] buildLookupTable];
    Team *black = [[Team alloc] initWithColor:Black];
    Team *white = [[Team alloc] initWithColor:White];
    
    Player *me = [[LocalPlayer alloc] initWithHandSize:5 team:black playBuilder:playBuilder];
    Player *otherGuy = [[ComputerPlayer alloc] initWithHandSize:5 team:white playBuilder:playBuilder];
    
    NSArray *players = [[NSArray alloc] initWithObjects:me, otherGuy, nil];
    NSArray *teams = [[NSArray alloc] initWithObjects:black, white, nil];
    
    Game *game = [[BasicGame alloc] initWithPlayers:players playBuilder:playBuilder];
    BoardLayer *boardLayer = [[BoardLayer alloc] init];
    ScoreLayer *scoreLayer = [[ScoreLayer alloc] initWithTeams:teams];
    
    CCLayer *cardLayer = [[CardLayer alloc] initWithPlayBuilder:playBuilder Player:me cardLookup:lookup];
    NSArray *layers = [[NSArray alloc] initWithObjects:boardLayer, cardLayer, scoreLayer, nil];
    
    [SceneManager setupNotifications:playBuilder boardLayer:boardLayer scoreLayer:scoreLayer cardLayer:cardLayer game:game];
    
    [SceneManager go:layers];
}
+(void) go: (NSArray *) layers {
    CCDirector *director = [CCDirector sharedDirector];
    CCScene *newScene = [SceneManager wrap:layers];
    
    if ([director runningScene]) {
        [director replaceScene:newScene];
    } else {
        [director runWithScene:newScene];
    }
}

+(CCScene *) wrap: (NSArray *) layers {
    CCScene *newScene = [CCScene node];
    for (CCLayer *layer in layers) {
        [newScene addChild:layer];
    }
    return newScene;
}
+(void)setupNotifications:(PlayBuilder *)playBuilder boardLayer:(CCLayer *)boardLayer scoreLayer:(CCLayer *)scoreLayer cardLayer:(CCLayer *)cardLayer game:(Game *)game {
    [self setupNotifications:playBuilder boardLayer:boardLayer scoreLayer:scoreLayer cardLayer:cardLayer game:game endGame:true];
}
+(void)setupNotifications:(PlayBuilder *)playBuilder boardLayer:(CCLayer *)boardLayer scoreLayer:(CCLayer *)scoreLayer cardLayer:(CCLayer *)cardLayer game:(Game *)game endGame:(bool) endGame {
    [[NSNotificationCenter defaultCenter] addObserver:boardLayer selector:@selector(onNewPlayReady:) name:playReadyEventName object:playBuilder];
    [[NSNotificationCenter defaultCenter] addObserver:scoreLayer selector:@selector(onNewPlayReady:) name:playReadyEventName object:playBuilder];
    [[NSNotificationCenter defaultCenter] addObserver:cardLayer selector:@selector(onPlayReady:) name:playReadyEventName object:playBuilder];
    
    [[NSNotificationCenter defaultCenter] addObserver:game selector:@selector(onNewPlayReady:) name:nextTurnEventName object:playBuilder];
    
    [[NSNotificationCenter defaultCenter] addObserver:cardLayer selector:@selector(preNextRoundReady:) name:preNextRoundEventName object:game];
    
    [[NSNotificationCenter defaultCenter] addObserver:game selector:@selector(onRoundReady:) name:nextRoundReadyEventName object:cardLayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:cardLayer selector:@selector(onNextRoundReady:) name:nextRoundEventName object:game];
    
    if (endGame) {
    [[NSNotificationCenter defaultCenter] addObserver:scoreLayer selector:@selector(onGameFinished:) name:gameOverEventName object:game];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:boardLayer selector:@selector(onPotentialPlayReady:) name:potPlayReadyEventName object:playBuilder];
}
+(GameState *)buildDefaultGameStateWithBoardSize:(int)size isTutorial:(bool)isTutorial {
    Deck *drawDeck = [[BasicDeck alloc] initWithDeck:false stacked:true size:size];
    Deck *discardDeck = [[BasicDeck alloc] initWithUI:true stacked:true];
    [drawDeck shuffle];
    Board *board = [Board initWithSize:size];
    
    return [[GameState alloc] initWithBoard:board DrawDeck:drawDeck DiscardDeck:discardDeck isTutorial:isTutorial];
}
@end
