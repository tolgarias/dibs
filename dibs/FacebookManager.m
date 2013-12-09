//
//  Facebook.m
//  GuessMyFriend
//
//  Created by bilal demirci on 10/18/12.
//
//

#import "FacebookManager.h"
#import "AppDelegate.h"

@implementation FacebookManager

//@synthesize selectedFriends;
static FacebookManager* sharedInstance;
+(FacebookManager*) sharedInstance {
    if(sharedInstance==nil){
        sharedInstance = [[FacebookManager alloc] init];
    }
    
    return sharedInstance;
}
-(id) init{
    self = [super init];
    return self;
}

-(void) sessionStateChanged:(FBSession *)session state:(FBSessionState)state error:(NSError *)error {
    switch (state) {
        case FBSessionStateOpen:
        {
        	//[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GameLayer scene] withColor:ccWHITE]];
            //[[SceneManager sharedSceneManager] changeScene:kProfileLayer];
            AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
            [app showUserView];

        }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed : {
            [FBSession.activeSession closeAndClearTokenInformation];
            //[[SceneManager sharedSceneManager] changeScene:kLoginLayer];
        }
        default:
            break;
    }
    
}

-(void) openSession {
    NSArray *permissions = [NSArray arrayWithObjects:@"user_photos,user_checkins,user_location,user_status",
                            nil];
    [FBSession openActiveSessionWithReadPermissions:permissions allowLoginUI:YES completionHandler:^(FBSession* session,FBSessionState state,NSError *error){
        [self sessionStateChanged:session state:state error:error];
    }];
}



@end
