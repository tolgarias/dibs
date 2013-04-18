//
//  ScreenManager.m
//  dibs
//
//  Created by Tolga Saglam on 4/15/13.
//
//

#import "ScreenManager.h"


@implementation ScreenManager
static ScreenManager *sharedInstance;
+(ScreenManager*) sharedInstance {
    if(sharedInstance==nil){
        sharedInstance = [[ScreenManager alloc] init];
    }
    return sharedInstance;
}
-(id) init {
    self = [super init];
    return self;
}
-(void) showUserView {
    AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
    [app showUserView];
 }

-(void) showUserListView {
    AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
    [app showUserListView];
    
    
}

-(void) showLoginView {
    AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
    [app showLoginView];
    
    
}
@end
