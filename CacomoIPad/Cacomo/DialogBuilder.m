//
//  DialogBuilder.m
//  Cacomo
//
//  Created by Danny Hyatt on 12/12/12.
//
//

#import "DialogBuilder.h"
#import "WaitingDialog.h"
#import "SpritePositions.h"
#import "Game.h"
#import "Player.h"
@class BasicCard;

@implementation DialogBuilder
+(DialogFlow *)capturingStones:(PlayBuilder *)playBuilder cardLookup:(NSDictionary *) lookup{
    Dialog *description = [[Dialog alloc] initWithString:@"Your opponent will play stones of a different color."];
    description.drawDeck = [[Deck alloc] initWithUI:false stacked:true];
    description.board = [Board initWithSize:8];
    
    Dialog *objective = [[Dialog alloc] initWithString:@"To capture a stone you must surround it on all four sides"];
    objective.isLow = true;
    Board *b = [Board initWithSize:8];
    [b addMove:[[Stone alloc] initWithColor:White row:2 col:3]];
    objective.board = b;
    [objective.sprites addObject:[self buildTriangle:1 :3 size:8]];
    [objective.sprites addObject:[self buildTriangle:2 :2 size:8]];
    [objective.sprites addObject:[self buildTriangle:2 :4 size:8]];
    [objective.sprites addObject:[self buildTriangle:3 :3 size:8]];
    
    Dialog *objective2 = [[Dialog alloc] initWithString:@"So to capture this white stone, you would need a blue stone at every ∆"];
    objective2.isLow = true;
    [objective2.sprites addObject:[self buildTriangle:1 :3 size:8]];
    [objective2.sprites addObject:[self buildTriangle:2 :2 size:8]];
    [objective2.sprites addObject:[self buildTriangle:2 :4 size:8]];
    [objective2.sprites addObject:[self buildTriangle:3 :3 size:8]];
    
    Dialog *prompt = [[Dialog alloc] initWithString:@"Try to surround the white stone."];
    prompt.isLow = true;
    
    WaitingDialog *captureTest = [[WaitingDialog alloc] initWithString:@"" EventName:@"3-3played" ActionObject:playBuilder];
    Deck *drawDeck = [[Deck alloc] initWithUI:false stacked:true];
    [drawDeck add:[lookup objectForKey:@"3-3"]];
    Board *board = [Board initWithSize:8];
    [board addMove:[[Stone alloc] initWithColor:Black row:2 col:2]];
    [board addMove:[[Stone alloc] initWithColor:Black row:1 col:3]];
    [board addMove:[[Stone alloc] initWithColor:Black row:2 col:4]];
    [board addMove:[[Stone alloc] initWithColor:White row:2 col:3]];
    captureTest.board = board;
    captureTest.drawDeck = drawDeck;
    captureTest.isInvisible = true;
    
    Dialog *great = [[Dialog alloc] initWithString:@"Great!"];
    great.delayInSeconds = 1.0f;
    
    Dialog *score = [[Dialog alloc] initWithString:@"Your score increases when you capture stones."];
                     
    Dialog *score2 = [[Dialog alloc] initWithString:@"You can see your current score up top."];
    [score2.sprites addObject:[self buildOval:0]];
    
    Dialog *victoryCondition = [[Dialog alloc] initWithString:@"The player with the highest score at the end of the game wins."];
    
    Dialog *butWait = [[Dialog alloc] initWithString:@"What happens if we have two white stones touching, like this?"];
    Board *b2 = [Board initWithSize:8];
    [b2 addMove:[[Stone alloc] initWithColor:White row:2 col:3]];
    [b2 addMove:[[Stone alloc] initWithColor:White row:3 col:3]];
    butWait.isLow = true;
    butWait.board = b2;
    
    Dialog *weCant = [[Dialog alloc] initWithString:@"We can't play a stone in D4, like we did last time"];
    [weCant.sprites addObject:[self buildTriangle:1 :3 size:8]];
    [weCant.sprites addObject:[self buildTriangle:2 :2 size:8]];
    [weCant.sprites addObject:[self buildTriangle:2 :4 size:8]];
    [weCant.sprites addObject:[self buildTriangle:3 :3 size:8]];
    weCant.isLow = true;
    
    Dialog *soWe = [[Dialog alloc] initWithString:@"So we need to surround both stones by playing blue stones on all the ∆'s"];
    [soWe.sprites addObject:[self buildTriangle:1 :3 size:8]];
    [soWe.sprites addObject:[self buildTriangle:2 :2 size:8]];
    [soWe.sprites addObject:[self buildTriangle:2 :4 size:8]];
    [soWe.sprites addObject:[self buildTriangle:3 :2 size:8]];
    [soWe.sprites addObject:[self buildTriangle:3 :4 size:8]];
    [soWe.sprites addObject:[self buildTriangle:4 :3 size:8]];
    soWe.isLow = true;
    
    Dialog *prompt2 = [[Dialog alloc] initWithString:@"Try to capture the white stones."];
    prompt2.isLow = true;
    
    WaitingDialog *captureTest2 = [[WaitingDialog alloc] initWithString:@"" EventName:@"4-3played" ActionObject:playBuilder];
    Deck *drawDeck2 = [[Deck alloc] initWithUI:false stacked:true];
    [drawDeck2 add:[lookup objectForKey:@"4-3"]];
    Board *board2 = [Board initWithSize:8];
    [board2 addMove:[[Stone alloc] initWithColor:Black row:2 col:2]];
    [board2 addMove:[[Stone alloc] initWithColor:Black row:1 col:3]];
    [board2 addMove:[[Stone alloc] initWithColor:Black row:2 col:4]];
    [board2 addMove:[[Stone alloc] initWithColor:Black row:3 col:2]];
    [board2 addMove:[[Stone alloc] initWithColor:Black row:3 col:4]];
    [board2 addMove:[[Stone alloc] initWithColor:White row:2 col:3]];
    [board2 addMove:[[Stone alloc] initWithColor:White row:3 col:3]];
    captureTest2.board = board2;
    captureTest2.drawDeck = drawDeck2;
    captureTest2.isInvisible = true;

    Dialog *great2 = [[Dialog alloc] initWithString:@"Great!"];
    great2.delayInSeconds = 1.0f;
    
    Dialog *useful = [[Dialog alloc] initWithString:@"Stones that are touching each other are harder to capture than a single stone"];
    Dialog *useful2 = [[Dialog alloc] initWithString:@"It's a good idea to place a new stone next to another stone of the same color"];

    DialogFlow *flow = [[DialogFlow alloc] initWithDialogs:description, objective, objective2, prompt, captureTest, great, score, score2, victoryCondition, butWait, weCant, soWe, prompt2, captureTest2, great2, useful, useful2, nil];
    return flow;
}

+(DialogFlow *)cardsAndStones:(CardLayer *)cardLayer playBuilder:(PlayBuilder *)playBuilder cardLookup:(NSDictionary *) lookup {
    Dialog *welcome = [[Dialog alloc] initWithString:@"Welcome to Cacomo.\n In Cacomo you want to capture more stones than your opponent."];
    
    WaitingDialog *selectCard = [[WaitingDialog alloc] initWithString:@"To play a stone touch a card. Let's touch \"D3\"" EventName:@"3-2selected" ActionObject:cardLayer];
    Deck *drawDeck = [[Deck alloc] initWithUI:false stacked:true];
    
    [drawDeck add:[lookup objectForKey:@"3-2"]];
    selectCard.drawDeck = drawDeck;
    
    Dialog *rowAndColumn = [[Dialog alloc] initWithString:@"You can see a preview of your stone at row D and column 3"];
    CCSprite *dCircle = [[CCSprite alloc] initWithFile:@"small-circle.png"];
    dCircle.position = ccp([SpritePositions colPosition:0 size:8] - 30, [SpritePositions rowPosition:3 size:8]);
    CCSprite *threeCircle = [[CCSprite alloc] initWithFile:@"small-circle.png"];
    threeCircle.position = ccp([SpritePositions colPosition:2 size:8], [SpritePositions rowPosition:0 size:8] + 23);
    [rowAndColumn.sprites addObject:dCircle];
    [rowAndColumn.sprites addObject:threeCircle];
    rowAndColumn.isLow = true;
    
    WaitingDialog *touchToPlay = [[WaitingDialog alloc] initWithString:@"Touch the card again to play a stone at D3" EventName:@"3-2played" ActionObject:playBuilder];
    
    Dialog *great = [[Dialog alloc] initWithString:@"Great!"];
    great.isLow = true;
    
    Dialog *butWait = [[Dialog alloc] initWithString:@"In Cacomo you will have 5 cards to choose from."];
    Deck *drawDeck2 = [[Deck alloc] initWithUI:false stacked:true];
    [drawDeck2 add:[lookup objectForKey:@"1-2"]];
    [drawDeck2 add:[lookup objectForKey:@"1-3"]];
    [drawDeck2 add:[lookup objectForKey:@"1-4"]];
    [drawDeck2 add:[lookup objectForKey:@"1-5"]];
    [drawDeck2 add:[lookup objectForKey:@"1-6"]];
    butWait.drawDeck = drawDeck2;
    
    Dialog *theresMore = [[Dialog alloc] initWithString:@"You can preview several moves, before playing your move."];
    
    WaitingDialog *previewACard = [[WaitingDialog alloc] initWithString:@"Touch one of the cards below once." EventName:@"cardSelected" ActionObject:cardLayer];
    
    WaitingDialog *previewDifferent = [[WaitingDialog alloc] initWithString:@"Now touch a different card in your hand." EventName:@"cardSelected" ActionObject:cardLayer];
    previewDifferent.delayInSeconds = 1;

    Dialog *useful = [[Dialog alloc] initWithString:@"Seeing the stone on the board can be really helpful."];
    useful.isLow = true;
    useful.delayInSeconds = 1;
    Dialog *useful2 = [[Dialog alloc] initWithString:@"If you ever have trouble picking a move, try previewing all the moves."];
    useful2.isLow = true;
    
    DialogFlow *flow = [[DialogFlow alloc] initWithDialogs:welcome, selectCard, rowAndColumn, touchToPlay, great, butWait, theresMore, previewACard, previewDifferent, useful, useful2, nil];
    return flow;
}
+(void)updateStateForDeck:(id)sender {
    [Game getNextPlayer].handSize = 5;
    [GameState updateHandPassing:true];
}
+(void)forceHandPass:(id)sender {
    Player *me = [Game getCurrentPlayer];
    [me.playBuilder addCardToPlay:nil player:me];
}
+(void)revertState:(id)sender {
    [Game getNextPlayer].handSize = 0;
    [GameState updateHandPassing:false];
}
+(DialogFlow *)theDeck:(PlayBuilder *)playBuilder cardLookup:(NSDictionary *)lookup {
    
    Dialog *drawDeck = [[Dialog alloc] initWithString:@"Everyone draws cards from the same draw deck."];
    Deck *deck = [[Deck alloc] initWithUI:false stacked:true];
    [deck add:[lookup objectForKey:@"0-0"]];
    [deck add:[lookup objectForKey:@"0-1"]];
    [deck add:[lookup objectForKey:@"0-2"]];
    [deck add:[lookup objectForKey:@"0-3"]];
    [deck add:[lookup objectForKey:@"0-4"]];
    [deck add:[lookup objectForKey:@"0-5"]];
    [deck add:[lookup objectForKey:@"1-0"]];
    [deck add:[lookup objectForKey:@"1-1"]];
    [deck add:[lookup objectForKey:@"1-2"]];
    [deck add:[lookup objectForKey:@"1-3"]];
    [deck add:[lookup objectForKey:@"1-4"]];
    [deck add:[lookup objectForKey:@"1-5"]];
    [deck add:[lookup objectForKey:@"0-6"]];
    [deck add:[lookup objectForKey:@"0-7"]];
    drawDeck.drawDeck = deck;
    [drawDeck updateMechanicChange:@selector(updateStateForDeck:) object:[DialogBuilder class]];
    
    Dialog *cards = [[Dialog alloc] initWithString:@"The draw deck contains one card for every coordinate on the board."];
    Dialog *implication = [[Dialog alloc] initWithString:@"This means each possible move on the board can be played only once."];
    
    Dialog *endCondition = [[Dialog alloc] initWithString:@"The game ends once all the cards have been played."];
    
    Dialog *passingHands = [[Dialog alloc] initWithString:@"Once every player has played, each player passes their hand to their opponent."];
    [passingHands updateMechanicChange:@selector(forceHandPass:) object:[DialogBuilder class]];
    
    Dialog *caution = [[Dialog alloc] initWithString:@"So your opponent will get to play any of the moves you don't play on your turn"];
    caution.delayInSeconds = 1;
    
    DialogFlow *flow = [[DialogFlow alloc] initWithDialogs:drawDeck, cards, implication, endCondition, passingHands, caution, nil];
    return flow;
}
+(DialogFlow *)selfCapture:(PlayBuilder *)playBuilder cardLookup:(NSDictionary *)lookup {
    Dialog *question = [[Dialog alloc] initWithString:@"What do you think happens if we play at D4?"];
    Board *board = [Board initWithSize:8];
    [board addMove:[[Stone alloc] initWithColor:Black row:2 col:2]];
    [board addMove:[[Stone alloc] initWithColor:Black row:2 col:3]];
    [board addMove:[[Stone alloc] initWithColor:White row:4 col:3]];
    [board addMove:[[Stone alloc] initWithColor:White row:3 col:2]];
    [board addMove:[[Stone alloc] initWithColor:White row:3 col:4]];
    [board addMove:[[Stone alloc] initWithColor:White row:2 col:1]];
    [board addMove:[[Stone alloc] initWithColor:White row:2 col:4]];
    [board addMove:[[Stone alloc] initWithColor:White row:1 col:2]];
    [board addMove:[[Stone alloc] initWithColor:White row:1 col:3]];
    question.drawDeck = [[Deck alloc] initWithUI:false stacked:true];
    
    question.board = board;
    question.isLow = true;
    
    WaitingDialog *letsSee = [[WaitingDialog alloc] initWithString:@"" EventName:@"3-3played" ActionObject:playBuilder];
    Deck *drawDeck1 = [[Deck alloc] initWithUI:false stacked:true];
    [drawDeck1 add:[lookup objectForKey:@"3-3"]];
    letsSee.drawDeck = drawDeck1;
    letsSee.isInvisible = true;
    
    Dialog *whoa = [[Dialog alloc] initWithString:@"Whoa!\nYour stones are gone!"];
    whoa.delayInSeconds = 1.0f;
    whoa.isLow = true;
    
    Dialog *selfcapture1 = [[Dialog alloc] initWithString:@"When you played D4 you filled your group's last open space. This is called self capture."];
    Board *board2 = [Board initWithSize:8];
    [board2 addMove:[[Stone alloc] initWithColor:Black row:2 col:2]];
    [board2 addMove:[[Stone alloc] initWithColor:Black row:2 col:3]];
    [board2 addMove:[[Stone alloc] initWithColor:White row:4 col:3]];
    [board2 addMove:[[Stone alloc] initWithColor:White row:3 col:2]];
    [board2 addMove:[[Stone alloc] initWithColor:White row:3 col:4]];
    [board2 addMove:[[Stone alloc] initWithColor:White row:2 col:1]];
    [board2 addMove:[[Stone alloc] initWithColor:White row:2 col:4]];
    [board2 addMove:[[Stone alloc] initWithColor:White row:1 col:2]];
    [board2 addMove:[[Stone alloc] initWithColor:White row:1 col:3]];
    selfcapture1.board = board2;
    selfcapture1.isLow = true;
    [selfcapture1.sprites addObject:[self buildTriangle:3 :3 size:8]];
    
    Dialog *opponentScore = [[Dialog alloc] initWithString:@"If you look at your opponent's score, you'll see he got three points for those stones."]; // TODO add another player
    opponentScore.isLow = true;
    [opponentScore.sprites addObject:[self buildOval:1]];
    
    Dialog *letsGoBack = [[Dialog alloc] initWithString:@"Let's go back to that previous situation."];
    letsGoBack.isLow = true;
    Deck *drawDeck2 = [[Deck alloc] initWithUI:false stacked:true];
    [drawDeck2 add:[lookup objectForKey:@"3-3"]];

    letsGoBack.drawDeck = drawDeck2;
    
    Dialog *but = [[Dialog alloc] initWithString:@"but let's add two more stones this time."];
    Board *board3 = [Board initWithSize:8];
    [board3 addMove:[[Stone alloc] initWithColor:Black row:2 col:2]];
    [board3 addMove:[[Stone alloc] initWithColor:Black row:2 col:3]];
    [board3 addMove:[[Stone alloc] initWithColor:White row:4 col:3]];
    [board3 addMove:[[Stone alloc] initWithColor:White row:3 col:2]];
    [board3 addMove:[[Stone alloc] initWithColor:White row:3 col:4]];
    [board3 addMove:[[Stone alloc] initWithColor:White row:2 col:1]];
    [board3 addMove:[[Stone alloc] initWithColor:White row:2 col:4]];
    [board3 addMove:[[Stone alloc] initWithColor:White row:1 col:2]];
    [board3 addMove:[[Stone alloc] initWithColor:White row:1 col:3]];
    [board3 addMove:[[Stone alloc] initWithColor:Black row:4 col:2]];
    [board3 addMove:[[Stone alloc] initWithColor:Black row:3 col:1]];
    but.board = board3;
    Deck *drawDeck3 = [[Deck alloc] initWithUI:false stacked:true];
    [drawDeck3 add:[lookup objectForKey:@"3-3"]];
    but.drawDeck = drawDeck3;
    but.isLow = true;
    
    Dialog *nowWhat = [[Dialog alloc] initWithString:@"What do you think will happen when we play at D4 now?"];
    nowWhat.isLow = true;
    
    WaitingDialog *test = [[WaitingDialog alloc] initWithString:@"" EventName:@"3-3played" ActionObject:playBuilder];
    test.isInvisible = true;
    
    Dialog *okay = [[Dialog alloc] initWithString:@"The white stone at D3 was captured instead!"];
    okay.delayInSeconds = 1.5f;
    okay.isLow = true;
    
    Dialog *explanation = [[Dialog alloc] initWithString:@"You can play in your last open space if you can capture a stone with the same move"];
    explanation.isLow = true;
    [explanation.sprites addObject:[self buildTriangle:2 :2 size:8]];
    [explanation.sprites addObject:[self buildTriangle:3 :1 size:8]];
    [explanation.sprites addObject:[self buildTriangle:3 :3 size:8]];
    [explanation.sprites addObject:[self buildTriangle:4 :2 size:8]];
    
    DialogFlow *flow = [[DialogFlow alloc] initWithDialogs: question, letsSee, whoa, selfcapture1, opponentScore, letsGoBack, but, nowWhat, test, okay, explanation, nil];
    return flow;
    
}
+(DialogFlow *)finalTest {
    Dialog *nowYouReady = [[Dialog alloc] initWithString:@"Now you know everything about how to play Cacomo!"];
    
    Dialog *soLetsGo = [[Dialog alloc] initWithString:@"So let's play a game"];
    Dialog *dontWorry = [[Dialog alloc] initWithString:@"Remember to capture the white stones by surrounding them"];
    Dialog *liberties = [[Dialog alloc] initWithString:@"and to play next to the stones you already have"];
    Dialog *haveFun = [[Dialog alloc] initWithString:@"and, most importantly, to have fun!"];
    
    DialogFlow *flow = [[DialogFlow alloc] initWithDialogs:nowYouReady, soLetsGo, dontWorry, liberties, haveFun, nil];
    return flow;
}
+(DialogFlow *)threePlayer {
    return nil;
}
+(CCSprite *)buildTriangle:(int)row :(int)col size:(int)size {
    CCSprite *tri = [[CCSprite alloc] initWithFile:@"triangle.png"];
    tri.position = ccp([SpritePositions colPosition:col size:size], [SpritePositions rowPosition:row size:size]);
    return tri;
}
+(CCSprite *)buildOval:(int)index {
    CCSprite *oval = [[CCSprite alloc] initWithFile:@"oblong-circle.png"];
    oval.position = [SpritePositions scoreLocation:index];
    return oval;
}
@end
