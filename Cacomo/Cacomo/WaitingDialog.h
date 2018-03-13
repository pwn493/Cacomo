//
//  WaitingDialog.h
//  Cacomo
//
//  Created by Danny Hyatt on 12/12/12.
//
//

#import "Dialog.h"

@interface WaitingDialog : Dialog
extern NSString *const taskCompletedEventName;
-(id)initWithString:(NSString *)text EventName:(NSString *)name ActionObject:(id)actionObject;
@end
