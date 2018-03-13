//
//  GameSelectLayer.m
//  Cacomo
//
//  Created by Danny Hyatt on 1/3/13.
//
//

#import "GameSelectLayer.h"
#import "SceneManager.h"

@interface GameSelectLayer()
@property (assign) NSMutableDictionary *state;
@property (assign) NSDictionary *nameMap;
//@property (assign) NSNumber *numPlayers;
//@property (assign) NSNumber *difficulty;
//@property (assign) NSNumber *boardSize;
//@property (assign) NSNumber *handPassingEnabled;
@end
@implementation GameSelectLayer
static NSString *FONT = @"Arial-BoldMT";
static int FONT_SIZE = 28;
@synthesize state = _state;
@synthesize nameMap = _nameMap;
//@synthesize numPlayers = _numPlayers;
//@synthesize difficulty = _difficulty;
//@synthesize boardSize = _boardSize;
//@synthesize handPassingEnabled = _handPassingEnabled;
-(id)init {
    if (self = [super initWithColor:ccc4(50, 50, 255, 255)]) {
        _state = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                  @(2), @"players",
                  @(0), @"difficulty",
                  @(8), @"boardSize",
                  [NSNumber numberWithBool:true], @"handPassing", nil];
        _nameMap = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"players", @"2",
                    @"players", @"3",
                    @"players", @"4",
                    @"difficulty",@"easy",
                    @"difficulty",@"medium",
                    @"difficulty",@"hard",
                    @"boardSize",@"6",
                    @"boardSize",@"8",
                    @"handPassing",@"on",
                    @"handPassing",@"off",
                    nil];

        self.isTouchEnabled = true;
        
        [self renderTiles];
    }
    
    return self;
}
- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    // Choose one of the touches to work with
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    for (CCSprite *sprite in self.children) {
        CGRect targetRect = CGRectMake(
                                       sprite.position.x - (sprite.contentSize.width/2),
                                       sprite.position.y - (sprite.contentSize.height/2),
                                       sprite.contentSize.width,
                                       sprite.contentSize.height);
        
        if (CGRectContainsPoint(targetRect, location)) {
            // get the sprite that was touched
            // update state
            // render buttons
        }
    }
}
-(void) renderTiles {
    [self removeAllChildrenWithCleanup:true];
    [self renderPlayers];
    [self renderDifficulty];
    [self renderBoardSize];
    [self renderHandPassing];
    [self renderStartButton];
}
-(int) getMenuWidth:(int) padding items:(NSArray *)items {
    int width = 0;
    for (CCMenuItemSprite *item in items) {
        width += padding + item.contentSize.width;
    }
    width -= padding;
    
    return width;
}
-(void) renderStartButton {
    CCMenuItemSprite *start = [self buildMenuSprite:@"startButton.png" altSprite:@"StartAltButton.png" block:^(id sender) {
        int players = [[self.state objectForKey:@"players"] intValue];
        int boardSize = [[self.state objectForKey:@"boardSize"] intValue];
        bool handPassing = [[self.state objectForKey:@"handPassing"] boolValue];
        int difficulty = [[self.state objectForKey:@"difficulty"] intValue];
        [SceneManager buildGame:players boardSize:boardSize handPassing:handPassing difficulty:difficulty];
    }];
    
    CCMenu *menu = [CCMenu menuWithItems:start, nil];
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];

    menu.position = ccp(winSize.width/2, start.contentSize.height / 2 + 20);
    [self addChild:menu];
}
-(void) renderPlayers {
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"Number of Players" fontName:FONT fontSize:FONT_SIZE];
    
    CCMenuItemSprite *two =  [self buildMenuTileSprite:@"2"];
    CCMenuItemSprite *three = [self buildMenuTileSprite:@"3"];
    CCMenuItemSprite *four = [self buildMenuTileSprite:@"4"];

    CCMenu *menu = [CCMenu menuWithItems:two, three, four, nil];
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    label.position = ccp(10 + label.texture.contentSizeInPixels.width/2, winSize.height - 30);
    [self addChild: label];

    [menu alignItemsHorizontallyWithPadding: 20.0f];
    int size = [self getMenuWidth:20 items:[[NSArray alloc] initWithObjects:two,three,four, nil]];
    menu.position = ccp(15 + size / 2, winSize.height - 70);
    [self addChild:menu];
}
-(void) renderDifficulty {
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"Computer Difficulty" fontName:FONT fontSize:FONT_SIZE];
    
    CCMenuItemSprite *easy =  [self buildMenuTileSprite:@"easy"];
    CCMenuItemSprite *medium = [self buildMenuTileSprite:@"medium"];
    CCMenuItemSprite *hard = [self buildMenuTileSprite:@"hard"];
    
    CCMenu *menu = [CCMenu menuWithItems:easy, medium, hard, nil];
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    label.position = ccp(10 + label.texture.contentSizeInPixels.width/2, winSize.height - 110);
    [self addChild: label];
    
    int size = [self getMenuWidth:10 items:[[NSArray alloc] initWithObjects:easy,medium,hard, nil]];
    menu.position = ccp(15 + size / 2, winSize.height - 150);
    [menu alignItemsHorizontallyWithPadding: 10.0f];
    [self addChild:menu];
}
-(void) renderBoardSize {
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"Board Size" fontName:FONT fontSize:FONT_SIZE];
    
    CCMenuItemSprite *big =  [self buildMenuTileSprite:@"8"];
    CCMenuItemSprite *small = [self buildMenuTileSprite:@"6"];
    
    CCMenu *menu = [CCMenu menuWithItems:big, small, nil];
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    label.position = ccp(10 + label.texture.contentSizeInPixels.width/2, winSize.height - 190);
    [self addChild: label];
    
    int size = [self getMenuWidth:20 items:[[NSArray alloc] initWithObjects:big,small, nil]];
    menu.position = ccp(15 + size / 2, winSize.height - 230);
    [menu alignItemsHorizontallyWithPadding: 20.0f];
    [self addChild:menu];
}
-(void) renderHandPassing {
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"Hand Passing" fontName:FONT fontSize:FONT_SIZE];
    
    CCMenuItemSprite *on =  [self buildMenuTileSprite:@"on"];
    CCMenuItemSprite *off = [self buildMenuTileSprite:@"off"];
    
    CCMenu *menu = [CCMenu menuWithItems:on, off, nil];
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    label.position = ccp(10 + label.texture.contentSizeInPixels.width/2, winSize.height - 270);
    [self addChild: label];
    
    int size = [self getMenuWidth:20 items:[[NSArray alloc] initWithObjects:on,off, nil]];
    menu.position = ccp(15 + size / 2, winSize.height - 310);
    [menu alignItemsHorizontallyWithPadding: 20.0f];
    [self addChild:menu];
}
-(void) updateState:(NSString *)name {
    NSNumber *myNumber = [self convertToNumber:name];
    
    [self.state setObject:myNumber forKey:[self.nameMap objectForKey:name]];
}
-(bool) isSelected:(NSString *)name {
    NSNumber *state1 = [self.state objectForKey:[self.nameMap objectForKey:name]];
    NSNumber *myNumber = [self convertToNumber:name];
    
    return [state1 intValue] == [myNumber intValue];
}
-(NSNumber *)convertToNumber:(NSString *)name {
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *myNumber = [f numberFromString:name];
    [f release];
    
    if (myNumber != nil) {
        return myNumber;
    }
    
    if (name == @"easy") {
        return @(0);
    } else if (name == @"medium") {
        return @(1);
    } else if (name == @"hard") {
        return @(2);
    } else if (name == @"on") {
        return [NSNumber numberWithBool:true];
    } else if (name == @"off") {
        return [NSNumber numberWithBool:false];
    }
    
    return 0;
}
-(CCMenuItemSprite *)buildMenuSprite:(NSString *)spriteName altSprite:(NSString *)selectedSpriteName block:(void (^)(id))myBlock {

    return [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:spriteName] selectedSprite:[CCSprite spriteWithFile:selectedSpriteName] block:myBlock];
}
-(CCMenuItemSprite *)buildMenuTileSprite:(NSString *) name {
    bool isSelected = [self isSelected:name];
    NSString *mainSprite = isSelected ? [self getSpriteTile:name isAlt:!isSelected] : [self getSpriteTile:name isAlt:!isSelected];
    NSString *selectedSprite = !isSelected ? [self getSpriteTile:name isAlt:!isSelected] : [self getSpriteTile:name isAlt:!isSelected];
    
    return [self buildMenuSprite:mainSprite altSprite:selectedSprite block: ^(id sender) {
        [self updateState:name];
        [self renderTiles];
    }];
}
-(NSString *) getSpriteTile:(NSString *)name isAlt:(bool)isAlt {
    NSString *fileName = [NSString stringWithFormat:@"%@%sTile.png", name, (isAlt) ? "alt" : ""];
    return fileName;
}
@end
