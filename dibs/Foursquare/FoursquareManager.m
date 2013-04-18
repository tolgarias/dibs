//
//  FoursquareManager.m
//  dibs
//
//  Created by ; Saglam on 4/15/13.
//
//

#import "FoursquareManager.h"
#import "AppDelegate.h"


@implementation FoursquareManager

@synthesize foursquare = foursquare_;
@synthesize request = request_;
@synthesize meta = meta_;
@synthesize notifications = notifications_;
@synthesize response = response_;

@synthesize delegate =m_delegate;
@synthesize selector =m_selector;

static FoursquareManager* sharedInstance;

+(FoursquareManager*) sharedInstance{
    if(sharedInstance==nil){
        sharedInstance = [[FoursquareManager alloc] init];
    }
    return sharedInstance;
}
-(id) init {
    self = [super init];
    foursquare_ = [[BZFoursquare alloc] initWithClientID:@"2XMWXFMOYDSOF2MOFGX3GVC01433NYGS4PRKNH10TSBYUYHJ" callbackURL:@"https://www.dibstick.com/foursquare.php"];
    foursquare_.sessionDelegate = self;
    //[foursquare_ startAuthorization];
    return self;
}

-(void) startAuth {
    [foursquare_ startAuthorization];
}

-(void) getUserData {
    [self prepareForRequest];
    self.request = [foursquare_ requestWithPath:@"users/self" HTTPMethod:@"GET" parameters:nil delegate:self];
    [self.request start];
}


#pragma mark -
#pragma mark Anonymous category


- (void)cancelRequest {
    if (request_) {
        request_.delegate = nil;
        [request_ cancel];
        self.request = nil;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
}

- (void)prepareForRequest {
    [self cancelRequest];
    self.meta = nil;
    self.notifications = nil;
    self.response = nil;
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
    [m_delegate performSelector:m_selector withObject:nil];
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
    NSLog(@"forus:%@",foursquare.accessToken);
    [[NSUserDefaults standardUserDefaults] setObject:foursquare.accessToken forKey:@"accessToken"];
    //[m_delegate performSelector:m_selector];
    
    AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
    [app showUserView];
    
   // NSLog(@"login oldu");
}

- (void)foursquareDidNotAuthorize:(BZFoursquare *)foursquare error:(NSDictionary *)errorInfo {
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, errorInfo);
}
@end



