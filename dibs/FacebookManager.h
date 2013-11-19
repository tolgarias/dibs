//
//  Facebook.h
//  GuessMyFriend
//
//  Created by bilal demirci on 10/18/12.
//
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>


@interface FacebookManager : NSObject


//@property (strong,nonatomic) FBFriendPickerViewController *friendController;
//@property (strong,nonatomic) NSArray *selectedFriends;

-(void) sessionStateChanged:(FBSession*) session state:(FBSessionState)state error:(NSError*) error;
-(void) openSession;
//-(void) showFriendSelector;

+(FacebookManager*) sharedInstance;
@end
