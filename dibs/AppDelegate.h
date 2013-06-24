//
//  AppDelegate.h
//  dibs
//
//  Created by Tolga Saglam on 4/9/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"
#import "DibsMaibViewController.h"
#import "UserViewController.h"
#import "FoursquareManager.h"
#import "UserListViewController.h"

typedef enum {
    kUserView = 1,
    kUserListView = 2,
    kMainView = 3
    } viewToShow;


@interface AppController : NSObject <UIApplicationDelegate, CCDirectorDelegate>
{
	UIWindow *window_;
	UINavigationController *navController_;

	CCDirectorIOS	*director_;							// weak ref
}

@property (nonatomic, retain) UIWindow *window;
@property (readonly) UINavigationController *navController;
@property (readonly) CCDirectorIOS *director;
@property (nonatomic,retain) DibsMaibViewController *dibsMainViewController_;
@property (nonatomic,retain) UserViewController *userViewController_;
@property (nonatomic,retain) UserListViewController *userListViewController_;



-(void) showUserView;
-(void) showUserListView;
-(void) showLoginView;
-(void) showChatView:(NSString*) accessToken name:(NSString*) displayName picture:(NSString*) pictureUrl;
-(BOOL) showChatView:(NSString*) msg accessToken:(NSString*) accessToken;
-(void) showView:(viewToShow) view;

@end
