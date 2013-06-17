//
//  AppDelegate.m
//  dibs
//
//  Created by Tolga Saglam on 4/9/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//

#import "cocos2d.h"

#import "AppDelegate.h"
#import "IntroLayer.h"
#import "ChatViewController.h"

@implementation AppController

@synthesize window=window_, navController=navController_, director=director_,dibsMainViewController_ = dibsMainViewController,userViewController_ = userViewController,userListViewController_ = userListViewController ;



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// Create the main window
	window_ = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];


	// Create a Navigation Controller with the Director
    //dibsMainViewController = [[DibsMaibViewController alloc] initWithNibName:@"DibsMaibViewController" bundle:[NSBundle mainBundle]];
    //userViewController = [[UserViewController alloc] initWithNibName:@"UserViewController" bundle:[NSBundle mainBundle]];
    //userListViewController = [[UserListViewController alloc] initWithNibName:@"UserListViewController" bundle:[NSBundle mainBundle]];
    
    
    
    NSString* accessToken =  [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
    //NSLog(@"accesToken:%@",accessToken);
    if(accessToken!=nil && ![accessToken isEqualToString:@""]){
        [[FoursquareManager sharedInstance] foursquare].accessToken = accessToken;
        UserViewController *viewController = [[UserViewController alloc] initWithNibName:@"UserViewController" bundle:[NSBundle mainBundle]];
        navController_ = [[UINavigationController alloc] initWithRootViewController:viewController];
        [viewController release];
    }
    else {
        DibsMaibViewController *viewController = [[DibsMaibViewController alloc] initWithNibName:@"DibsMaibViewController" bundle:[NSBundle mainBundle]];
        navController_ = [[UINavigationController alloc] initWithRootViewController:viewController];
        [viewController release];
    }
    
    //ChatViewController *viewController = [[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:[NSBundle mainBundle]];
    //navController_ = [[UINavigationController alloc] initWithRootViewController:viewController];
    //[viewController release];
    
    navController_.title = @"Welcome to Dibs";
	navController_.navigationBarHidden = NO;
    //[navController_ pushViewController:userListViewController animated:YES];
	// set the Navigation Controller as the root view controller
//	[window_ addSubview:navController_.view];	// Generates flicker.
	[window_ setRootViewController:navController_];
	
	// make main window visible
	[window_ makeKeyAndVisible];
	
	return YES;
}

// Supported orientations: Landscape. Customize it for your own needs
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}


// getting a call, pause the game
-(void) applicationWillResignActive:(UIApplication *)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ pause];
}

// call got rejected
-(void) applicationDidBecomeActive:(UIApplication *)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ resume];
}

-(void) applicationDidEnterBackground:(UIApplication*)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ startAnimation];
}

// application will be killed
- (void)applicationWillTerminate:(UIApplication *)application
{
	CC_DIRECTOR_END();
}

// purge memory
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	[[CCDirector sharedDirector] purgeCachedData];
}

// next delta time will be zero
-(void) applicationSignificantTimeChange:(UIApplication *)application
{
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [[FoursquareManager sharedInstance].foursquare handleOpenURL:url];
}
-(void) showUserView {
    UserViewController *viewController = [[UserViewController alloc] initWithNibName:@"UserViewController" bundle:[NSBundle mainBundle]];
    [navController_ pushViewController:viewController animated:YES];
    [viewController release];
}

-(void) showUserListView {
    UserListViewController *viewController = [[UserListViewController alloc] initWithNibName:@"UserListViewController" bundle:[NSBundle mainBundle]];
    [navController_ pushViewController:viewController animated:YES];
    [viewController release];
}

-(void) showChatView {
    ChatViewController *viewController = [[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:[NSBundle mainBundle]];
    [navController_ pushViewController:viewController animated:YES];
    [viewController release];
}

-(void) showLoginView {
    DibsMaibViewController *viewController = [[DibsMaibViewController alloc] initWithNibName:@"DibsMaibViewController" bundle:[NSBundle mainBundle]];
    [navController_ pushViewController:viewController animated:YES];
    [viewController release];
}

-(void) showView:(viewToShow)view {
    
    switch (view) {
        case kMainView:
            [self showLoginView];
            break;
        case kUserListView:
            [self showUserListView];
            break;
        case kUserView:
            [self showUserView];
            break;
        default:
            break;
    }
}
- (void) dealloc
{
	[window_ release];
	[navController_ release];

	[super dealloc];
}




@end

