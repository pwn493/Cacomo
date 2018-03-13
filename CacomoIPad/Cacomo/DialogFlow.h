//
//  DialogFlow.h
//  Cacomo
//
//  Created by Danny Hyatt on 12/11/12.
//
//

#import <Foundation/Foundation.h>
#import "Dialog.h"

@interface DialogFlow : NSObject
-(id)initWithDialogs:(Dialog *) firstDialog, ...;
-(void)next;
-(Dialog *)getCurrent;
-(bool)isNextReady;
@end
