//
//  HelloFoursquare.m
//  dibs
//
//  Created by Tolga Saglam on 4/9/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "HelloFoursquare.h"


@implementation HelloFoursquare
@synthesize foursquare = foursquare_;
@synthesize request = request_;
@synthesize meta = meta_;
@synthesize notifications = notifications_;
@synthesize response = response_;


+(CCScene *) scene {
    CCScene * scene = [CCScene node];
    HelloFoursquare * layer = [HelloFoursquare node];
    [scene addChild:layer];
    return scene;
}
-(id) init {
   foursquare_ = [[BZFoursquare alloc] initWithClientID:@"2XMWXFMOYDSOF2MOFGX3GVC01433NYGS4PRKNH10TSBYUYHJ" callbackURL:@"https://www.dibstick.com/foursquare.php"];
    foursquare_.sessionDelegate = self;
    [foursquare_ startAuthorization];
    return self;
}

#pragma mark -
#pragma mark BZFoursquareRequestDelegate

- (void)requestDidFinishLoading:(BZFoursquareRequest *)request {
    self.meta = request.meta;
    self.notifications = request.notifications;
    self.response = request.response;
    self.request = nil;
    //[self updateView];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)request:(BZFoursquareRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, error);
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[[error userInfo] objectForKey:@"errorDetail"] delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
    [alertView show];
    self.meta = request.meta;
    self.notifications = request.notifications;
    self.response = request.response;
    self.request = nil;
    //[self updateView];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark -
#pragma mark BZFoursquareSessionDelegate

- (void)foursquareDidAuthorize:(BZFoursquare *)foursquare {
    //NSIndexPath *indexPath = [NSIndexPath indexPathForRow:kAccessTokenRow inSection:kAuthenticationSection];
    //NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
    //[self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    NSLog(@"login oldu");
}

- (void)foursquareDidNotAuthorize:(BZFoursquare *)foursquare error:(NSDictionary *)errorInfo {
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, errorInfo);
}
@end
