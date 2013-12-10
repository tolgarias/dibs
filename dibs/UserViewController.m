//
//  UserViewController.m
//  dibs
//
//  Created by Tolga Saglam on 4/15/13.
//
//

#import "UserViewController.h"
#import "UserData.h"
#import "UrlConnectionManager.h"
#import "ScreenManager.h"
#import "Utils.h"
#import "XmppHandler.h"
#import "FacebookManager.h"

@interface UserViewController (){
    
}
@end

@implementation UserViewController
@synthesize profileImg,lblDate,lblVenue,lblName,indicator,lblLike,lblLikeBg,nextLike,lblLoading;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //UIButton *a1 = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *a1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //[a1 setFrame:CGRectMake(0.0f, 0.0f, 25.0f, 25.0f)];
    [a1 addTarget:self action:@selector(logoutButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [a1.titleLabel setText:@"logout"];
    //[a1 setImage:[UIImage imageNamed:@"Icon.png"] forState:UIControlStateNormal];
    //UIBarButtonItem *random = [[UIBarButtonItem alloc] initWithCustomView:a1];
    //[[UIBarButtonItem alloc] init]
    //UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:a1];
                                  //initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                  //initWithImage:[UIImage imageNamed:@"Icon.png"] style:UIBarButtonItemStylePlain
                                  //target:self
                                  //action:@selector(logoutButtonPressed)];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"logout" style:UIBarButtonSystemItemAction target:self action:@selector(logoutButtonPressed)];
    [[self navigationItem] setLeftBarButtonItem:barButton];
    
    UIBarButtonItem *reloadButton = [[UIBarButtonItem alloc] initWithTitle:@"reload" style:UIBarButtonSystemItemAction target:self action:@selector(getUserData)];
    [[self navigationItem] setRightBarButtonItem:reloadButton];
    [self getUserData];
    
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"viewbg.png"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    //[profileImg.layer setBorderWidth:2.0];
    //[profileImg.layer setBorderColor:[[UIColor blackColor] CGColor]];
    
    lblVenue.layer.cornerRadius = 7.0;
    lblVenue.layer.masksToBounds = YES;
    lblDate.layer.cornerRadius = 7.0;
    lblDate.layer.masksToBounds = YES;
    
    
    if([[UserData sharedInstance].remainingLikeCount intValue]==0 && isTimerStarted == NO){
        isTimerStarted = YES;
        double likeTime = [[[NSUserDefaults standardUserDefaults] objectForKey:@"likeTime"] doubleValue]-[[NSDate date] timeIntervalSince1970];
        [UserData sharedInstance].nextLike = [NSNumber numberWithDouble:likeTime];
        
        [NSTimer scheduledTimerWithTimeInterval:1
                                         target:self
                                       selector:@selector(showNextLike)
                                       userInfo:nil
                                        repeats:0];
        
    }

    
    
}
-(void) getUserData_foursquare {
 [[FoursquareManager sharedInstance] getUserData];
 [indicator setHidden:NO];
 [indicator startAnimating];
 [lblLoading setHidden:NO];
}
-(void) getUserData {
    int loginType = [[NSUserDefaults standardUserDefaults] integerForKey:@"loginType"];
    if(loginType==1){
        [self getUserData_facebook];
    }
    else {
        [FoursquareManager sharedInstance].delegate = self;
        [FoursquareManager sharedInstance].selector = @selector(onUserDataReceived_foursquare:);
        [self getUserData_foursquare];
    }

}
-(void) getUserData_facebook{
    NSString *query =
    @"{"
    @"'user':'SELECT uid, name, pic_square,username,uid FROM user WHERE uid = me()',"
    @"'checkins':'SELECT page_id,timestamp FROM location_post WHERE author_uid=me()',"
    @"'page':'select  name,location,page_id from page where page_id in (select page_id from #checkins)'"
    @"}";
    // Set up the query parameter
    //@"select target_id,timestamp from checkin where author_id=me()";
    NSDictionary *queryParam =
    [NSDictionary dictionaryWithObjectsAndKeys:query, @"q", nil];
    // Make the API request that uses FQL
    [FBRequestConnection startWithGraphPath:@"/fql"
                                 parameters:queryParam
                                 HTTPMethod:@"GET"
                          completionHandler:^(FBRequestConnection *connection,
                                              id result,
                                              NSError *error) {
                              if (error) {
                                  NSLog(@"Error: %@", [error localizedDescription]);
                              } else {
                                  NSLog(@"%@",[result data]);
                                  NSArray* checkins = (NSArray*)[result data];
                                  [self onUserDataReceived_facebook:checkins];
                                  
                              }
                          }];
    [indicator setHidden:NO];
    [indicator startAnimating];
    [lblLoading setHidden:NO];
    
}
-(void) logoutButtonPressed {
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"accessToken"];
    [[ScreenManager sharedInstance] showLoginView];
    isTimerStarted = NO;
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) onUserDataReceived_facebook:(NSArray*) data {
    NSDictionary* checkinsArray = data[0];
    NSDictionary* userInfoArray = data[1];
    NSDictionary* placeInfoArray = data[2];
    
    NSArray* chckins = [checkinsArray objectForKey:@"fql_result_set"];
    NSArray* user = [userInfoArray objectForKey:@"fql_result_set"];
    NSArray* places = [placeInfoArray objectForKey:@"fql_result_set"];
    
    NSDictionary *checkinInfo = chckins[0];
    NSDictionary *userInfo = user[0];
    NSDictionary *placeInfo = places[0];
    
    NSDictionary *locationInfo = [placeInfo objectForKey:@"location"];
    
    NSString *photo = [userInfo objectForKey:@"pic_square"];
    NSString *firstName = [userInfo objectForKey:@"name"];
    NSString *lastName = @"";
    NSInteger *uid = (NSInteger*)[userInfo objectForKey:@"uid"];
    NSString *uidStr = [NSString stringWithFormat:@"%i",uid];
    
    [[NSUserDefaults standardUserDefaults] setObject:uidStr forKey:@"accessToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    NSMutableDictionary* venueLocation = [[NSMutableDictionary alloc] init];
   [venueLocation setObject:[locationInfo objectForKey:@"latitude"] forKey:@"lat"];
   [venueLocation setObject:[locationInfo objectForKey:@"longitude"] forKey:@"lng"];
    
    NSString *venueName = [placeInfo objectForKey:@"name"];
    NSNumber *ven = (NSNumber*)[checkinInfo objectForKey:@"page_id"];
    NSString *venueId = [NSString stringWithFormat:@"%@",ven];
    
   // NSString *venueId = [checkinInfo objectForKey:@"page_id"];
    NSNumber *createdAt =[checkinInfo objectForKey:@"timestamp"];
    
    NSMutableDictionary *datas = [[NSMutableDictionary alloc] init];
    [datas setObject:photo forKey:@"photo"];
    [datas setObject:firstName forKey:@"firstName"];
    [datas setObject:lastName forKey:@"lastName"];
    [datas setObject:venueLocation forKey:@"venueLocation"];
    [datas setObject:venueId forKey:@"venueId"];
    [datas setObject:createdAt forKey:@"createdAt"];
    [datas setObject:venueName forKey:@"venueName"];
    
    [self onUserDataReceived:datas];
    
    
}

- (void) onUserDataReceived_foursquare:(NSObject*) data {
    NSDictionary* responseData = [FoursquareManager sharedInstance].response;
    
    NSString *photo = [[responseData objectForKey:@"user"] objectForKey:@"photo"];
    NSString *firstName = [[responseData objectForKey:@"user"] objectForKey:@"firstName"];
    NSString *lastName = [[responseData objectForKey:@"user"] objectForKey:@"lastName"];
    NSDictionary *checkIns = [[responseData objectForKey:@"user"] objectForKey:@"checkins"];
    NSDictionary *venue = [[[checkIns objectForKey:@"items"] objectAtIndex:0] objectForKey:@"venue"];
    
    NSDictionary* venueLocation = [venue objectForKey:@"location"];
    NSString *venueName = [venue objectForKey:@"name"];
    NSString *venueId = [venue objectForKey:@"id"];
    NSNumber *createdAt =[[[checkIns objectForKey:@"items"] objectAtIndex:0] objectForKey:@"createdAt"];
    
    NSMutableDictionary *datas = [[NSMutableDictionary alloc] init];
    [datas setObject:photo forKey:@"photo"];
    [datas setObject:firstName forKey:@"firstName"];
    [datas setObject:lastName forKey:@"lastName"];
    [datas setObject:venueLocation forKey:@"venueLocation"];
    [datas setObject:venueId forKey:@"venueId"];
    [datas setObject:createdAt forKey:@"createdAt"];
    [datas setObject:venueName forKey:@"venueName"];
    
    [self onUserDataReceived:datas];
    

}
- (void) onUserDataReceived:(NSObject*) data {
    [lblLoading setHidden:YES];
    
    NSString *photo = [data objectForKey:@"photo"];
    NSString *firstName = [data objectForKey:@"firstName"];
    NSString *lastName = [data objectForKey:@"lastName"];
    
    NSDictionary* venueLocation = [data objectForKey:@"venueLocation"];
    NSString *venueName = [data objectForKey:@"venueName"];
    NSString *venueId = [data objectForKey:@"venueId"];
    NSNumber *createdAt =[data objectForKey:@"createdAt"];
    
    
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
    NSString *name = [NSString stringWithFormat:@"%@ %@",firstName,lastName];
    NSString *bar = [[Utils sharedInstance] getIntervalString:createdAt];
    
    [UserData sharedInstance].lastCheckInDate = bar;//[NSString stringWithFormat:@"%i",[createdAt intValue]];
    
    
    
    
    
    
    if(![[UserData sharedInstance].lastCheckInVenue isEqualToString:venueId]){
        [UserData sharedInstance].name = name;
        [UserData sharedInstance].accessToken = accessToken;
        [UserData sharedInstance].lastCheckInVenue = venueId;
        [UserData sharedInstance].lastCheckInVenueName = venueName;
        
        [UserData sharedInstance].photoUrl = photo;
        [UrlConnectionManager sharedInstance].delegate = self;
        [UrlConnectionManager sharedInstance].selector = @selector(onUserDataSend:);
        NSString* postData = [NSString stringWithFormat:@"&accessToken=%@&name=%@&photo=%@&lastCheckInDate=%@&lastCheckInValue=%@&venueName=%@&lat=%@&lng=%@",accessToken,name,photo,[NSString stringWithFormat:@"%i",[createdAt intValue]],venueId,venueName,[venueLocation objectForKey:@"lat"],[venueLocation objectForKey:@"lng"]];
        NSLog(@"%@",postData);
        [[UrlConnectionManager sharedInstance] postData:postData withUrl:@"https://www.dibstick.com/dibs_user.php"];
        //NSDictionary *params = [[NSDictionary alloc] initWithObjects:<#(NSArray *)#> forKeys:<#(NSArray *)#>]
    }
    //NSString *about = [NSString stringWithFormat:@"You last checked in %@ at %@ and you have %i like remaining",venueName,bar,[[UserData sharedInstance].remainingLikeCount intValue]];
    //NSString *userListfInfo = [NSString stringWithFormat:@"To see users who also checked in %@ please tap show user list button",venueName];
    [self showUserInfo];
    
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:photo]]];
    [profileImg setImage:image];
    
    
    [XmppHandler sharedInstance].displayName = name;
    [XmppHandler sharedInstance].photo = UIImagePNGRepresentation(image);;
    [[XmppHandler sharedInstance] connect];
    [indicator stopAnimating];
    [indicator setHidden:YES];
    [[self navigationItem] setTitle:name];
    

    
    /*if([[UserData sharedInstance].remainingLikeCount intValue]==0){
        
        double likeTime = [[[NSUserDefaults standardUserDefaults] objectForKey:@"likeTime"] doubleValue]-[[NSDate date] timeIntervalSince1970];
        [UserData sharedInstance].nextLike = [NSNumber numberWithDouble:likeTime];
       
        [NSTimer scheduledTimerWithTimeInterval:1
                                         target:self
                                       selector:@selector(showNextLike)
                                        userInfo:nil
                                        repeats:0];
    }*/
    
}
-(void) showUserInfo {
    //BOOL repeat = YES;
    
    NSString *about = [NSString stringWithFormat:@"You last checked in %@ at %@ and you have %i like remaining",[UserData sharedInstance].lastCheckInVenueName,[UserData sharedInstance].lastCheckInDate,[[UserData sharedInstance].remainingLikeCount intValue]];
    NSString *userListfInfo = [NSString stringWithFormat:@"To see users who also checked in %@ please tap show user list button",[UserData sharedInstance].lastCheckInVenueName];
    [lblVenue setText:about];
    [lblDate setText:userListfInfo];


}
- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"userDataChanged:%i",[[UserData sharedInstance].userInfoChanged intValue]);
    if([[UserData sharedInstance].userInfoChanged intValue]==1){
        [self showUserInfo];
        [UserData sharedInstance].userInfoChanged = [NSNumber numberWithInt:0];
        
        if([[UserData sharedInstance].remainingLikeCount intValue]==0 && isTimerStarted == NO){
            isTimerStarted = YES;
            double likeTime = [[[NSUserDefaults standardUserDefaults] objectForKey:@"likeTime"] doubleValue]-[[NSDate date] timeIntervalSince1970];
            [UserData sharedInstance].nextLike = [NSNumber numberWithDouble:likeTime];
            
            [NSTimer scheduledTimerWithTimeInterval:1
                                             target:self
                                           selector:@selector(showNextLike)
                                           userInfo:nil
                                            repeats:0];
            
        }

    }

}
-(void) setNextLikeLabels {
    NSString *toLikeString = [NSString stringWithFormat:@"Next like in %@",[[Utils sharedInstance] getToString:[UserData sharedInstance].nextLike]];
    [lblLike setHidden:NO];
    [lblLikeBg setHidden:NO];
    [lblLike setText:toLikeString];
}
-(void) showNextLike {
    [UserData sharedInstance].nextLike = [NSNumber numberWithDouble:[[UserData sharedInstance].nextLike doubleValue]-1];
    if([[UserData sharedInstance].nextLike intValue]<=0){
        [UserData sharedInstance].nextLike = 0;
        [UserData sharedInstance].remainingLikeCount= [NSNumber numberWithInt:1];
        [lblLikeBg setHidden:YES];
        [lblLike setHidden:YES];
        isTimerStarted = NO;
        [self showUserInfo];
    }
    else {
        if(isTimerStarted==YES){
            [self setNextLikeLabels];
            [NSTimer scheduledTimerWithTimeInterval:1
                                     target:self
                                   selector:@selector(showNextLike)
                                   userInfo:nil
                                    repeats:0];
        }
    }
}

-(void) onUserDataSend:(NSData*) data {
    
}
-(IBAction)ShowUserList:(id)sender
{
    AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
    [app showUserListView];
}
@end
