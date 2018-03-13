//
//  DialogFlow.m
//  Cacomo
//
//  Created by Danny Hyatt on 12/11/12.
//
//

#import "DialogFlow.h"

@interface DialogFlow()
@property (assign) NSMutableArray *dialogs;
@property (nonatomic,strong) Dialog *current;
@end

@implementation DialogFlow
@synthesize dialogs = _dialogs;
@synthesize current = _current;
-(id)initWithDialogs:(Dialog *)firstDialog, ... {
    if ([self init]) {
        _dialogs = [[NSMutableArray alloc]init];
        id eachObject;
        va_list argumentList;
        if (firstDialog)
        {
            [_dialogs addObject: firstDialog];
            va_start(argumentList, firstDialog);
            while ((eachObject = va_arg(argumentList, id)))
                [_dialogs addObject: eachObject];
            va_end(argumentList);
            _current = firstDialog;
        }
    }
    
    return self;
}
-(void)next {
    self.current = [self getNext];
}
-(Dialog *)getCurrent {
    return self.current;
}
-(bool)isNextReady {
    return [self.current isReadyForNext];
}
-(Dialog *)getNext {
    int index = [self.dialogs indexOfObject:self.current];
    if (index + 1 >= [self.dialogs count]) {
        return nil;
    }
    return [self.dialogs objectAtIndex:index + 1];
}
@end
