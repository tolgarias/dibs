//
//  ScreenManager.h
//  dibs
//
//  Created by Tolga Saglam on 4/15/13.
//
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
@interface ScreenManager : NSObject

+(ScreenManager*) sharedInstance;

-(void) showUserView;
-(void) showUserListView;
@end
