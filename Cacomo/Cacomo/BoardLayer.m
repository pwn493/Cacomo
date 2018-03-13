//
//  BoardLayer.m
//  CacomoBoard
//
//  Created by Danny Hyatt on 11/12/12.
//
//

#import "BoardLayer.h"
#import "Board.h"
#import "PlayBuilder.h"
#import "Play.h"
#import "Player.h"
#import "SimpleAudioEngine.h"

@class Team;
@class Game;

@interface BoardLayer()
@property float slipTime;
@property float playTime;
@property (nonatomic, strong) PlayBuilder *playBuilder;
@end
@implementation BoardLayer
@synthesize slipTime = _slipTime;
@synthesize playTime = _playTime;
@synthesize playBuilder = _playBuilder;
static float THINK_TIME=1.0f;
static float PLAY_TIME=0.3f;

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	if( (self=[super initWithColor:ccc4(70,70,255,255)]) ) {
        [self renderBoard];
        [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"click.wav"];
	}
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
    
	// don't forget to call "super dealloc"
	[super dealloc];
}

-(void)onNewPlayReady:(NSNotification *)notification {
    [self addMove:[PlayBuilder getCurrentPlay]];
}
-(void)onPotentialPlayReady:(NSNotification *)notification {
    Stone *stone = [PlayBuilder getPotentialPlay].stone;
    Board *board = [GameState getBoard];
    
    //Get most recent play from board
    
    [self removeAllChildrenWithCleanup:true];
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    NSArray *sprites = [board tempAddPotenteialMove:stone :winSize.width/2 :winSize.height/2 + 65];
    for (id sprite in sprites) {
        [self addChild:(CCSprite*)sprite];
    }
}
-(void)renderBoard {
    Board *board = [GameState getBoard];
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    NSArray *sprites = [board renderSpritesAtLocation :winSize.width/2 :winSize.height/2 + 65];
    for (id sprite in sprites) {
        [self addChild:(CCSprite*)sprite];
    }
}

-(void)addMove:(Play *) play{
    Stone *stone = play.stone;
    if (stone != nil) {
        int score = [[GameState getBoard] addMove:stone];

        [self updateScores:score player:play.player];
        [self renderPlayAction:stone];
    }
    
    self.playBuilder = play.player.playBuilder;
    self.slipTime=0.f;
    self.playTime=0.f;
    [self schedule:@selector(pauseForPlay:)];
    
    if ([Game isComputer:[Game getNextPlayer]]) {
        [self schedule:@selector(pauseForThink:)];
    } else {
        [self.playBuilder readyForNextTurn];
    }
}
-(void)refreshBoard {
    [self removeAllChildrenWithCleanup:true];
    
    [self renderBoard];
}
-(void)updateScores:(int)score player:(Player *) player {
    int numPlayers = [[Game getActivePlayers] count]; // TODO change to num teams
    if (score < 0 && numPlayers == 2) {
            // self capture add points to other teams score
            int currentPlayerIndex = [[Game getActivePlayers] indexOfObject:player];
            int otherPlayerIndex = 1 - currentPlayerIndex;
            Player *otherPlayer = [[Game getActivePlayers] objectAtIndex:otherPlayerIndex];
            otherPlayer.team.points += score * -1;
    } else {
        player.team.points += score;
    }
}
-(void) renderPlayAction:(Stone *) stone {
    //Get most recent play from board
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CCSprite *newMove = [[GameState getBoard] renderStoneAtBoardLocation:stone :winSize.width/2 :winSize.height/2 + 65];
    newMove.scale = 1.6;
    [self addChild:newMove];
    
    //Do funky animation on it.
    [newMove runAction:[CCScaleTo actionWithDuration:PLAY_TIME scale:1]];    
}
-(void) playClickSound {
    //Do funky sound
    [[SimpleAudioEngine sharedEngine] playEffect:@"click.wav"];
}
-(void) pauseForPlay:(ccTime) dt {
    self.playTime+=dt;
    if(self.playTime>PLAY_TIME) {
        [self unschedule:@selector(pauseForPlay:)];
        [self refreshBoard];
        if ([PlayBuilder getCurrentPlay].stone != nil) {
            [self playClickSound];
        }
    }
}
-(void) pauseForThink:(ccTime) dt {
    self.slipTime+=dt;
    if(self.slipTime>THINK_TIME) {
        [self unschedule:@selector(pauseForThink:)];
        
        assert(self.playBuilder != nil);
        [self.playBuilder readyForNextTurn];
    }
}
-(void)onStateUpdated:(NSNotification *)notification {
    [self refreshBoard];
}
@end
