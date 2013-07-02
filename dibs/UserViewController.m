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

@interface UserViewController ()

@end

@implementation UserViewController
@synthesize profileImg,lblDate,lblVenue,lblName;

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
    UIButton *a1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [a1 setFrame:CGRectMake(0.0f, 0.0f, 25.0f, 25.0f)];
    [a1 addTarget:self action:@selector(logoutButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [a1 setImage:[UIImage imageNamed:@"Icon.png"] forState:UIControlStateNormal];
    //UIBarButtonItem *random = [[UIBarButtonItem alloc] initWithCustomView:a1];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:a1];
                                  //initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                  //initWithImage:[UIImage imageNamed:@"Icon.png"] style:UIBarButtonItemStylePlain
                                  //target:self
                                  //action:@selector(logoutButtonPressed)];
    [[self navigationItem] setLeftBarButtonItem:barButton];
    
    [FoursquareManager sharedInstance].delegate = self;
    [FoursquareManager sharedInstance].selector = @selector(onUserDataReceived:);
    [[FoursquareManager sharedInstance] getUserData];
    [[self navigationItem] setTitle:@"Play Dibs"];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
    [label setBackgroundColor:[UIColor colorWithRed:255.f
                                              green:255.f
                                               blue:255.f
                                              alpha:255.f]];
    [[self navigationItem] setTitleView:label];
    
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"viewbg.png"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    
}
-(void) logoutButtonPressed {
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"accessToken"];
    [[ScreenManager sharedInstance] showLoginView];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) onUserDataReceived:(NSObject*) data {
    NSDictionary* responseData = [FoursquareManager sharedInstance].response;
    
    NSLog(@"%@",responseData);
    NSString *photo = [[responseData objectForKey:@"user"] objectForKey:@"photo"];
    NSString *firstName = [[responseData objectForKey:@"user"] objectForKey:@"firstName"];
    NSString *lastName = [[responseData objectForKey:@"user"] objectForKey:@"lastName"];
    NSDictionary *checkIns = [[responseData objectForKey:@"user"] objectForKey:@"checkins"];
    NSDictionary *venue = [[[checkIns objectForKey:@"items"] objectAtIndex:0] objectForKey:@"venue"];
    
    NSDictionary* venueLocation = [venue objectForKey:@"location"];
    NSString *venueName = [venue objectForKey:@"name"];
    NSString *venueId = [venue objectForKey:@"id"];
    NSNumber *createdAt =[[[checkIns objectForKey:@"items"] objectAtIndex:0] objectForKey:@"createdAt"];
    
    
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
    NSString *name = [NSString stringWithFormat:@"%@ %@",firstName,lastName];
    NSString *bar = [[Utils sharedInstance] getIntervalString:createdAt];
    
    if(![[UserData sharedInstance].lastCheckInVenue isEqualToString:venueId]){
        [UserData sharedInstance].name = name;
        [UserData sharedInstance].accessToken = accessToken;
        [UserData sharedInstance].lastCheckInVenue = venueId;
        [UserData sharedInstance].lastCheckInDate = [NSString stringWithFormat:@"%i",[createdAt intValue]];
        [UserData sharedInstance].photoUrl = photo;
        [UrlConnectionManager sharedInstance].delegate = self;
        [UrlConnectionManager sharedInstance].selector = @selector(onUserDataSend:);
        NSString* postData = [NSString stringWithFormat:@"&accessToken=%@&name=%@&photo=%@&lastCheckInDate=%@&lastCheckInValue=%@&venueName=%@&lat=%@&lng=%@",accessToken,name,photo,[NSString stringWithFormat:@"%i",[createdAt intValue]],venueId,venueName,[venueLocation objectForKey:@"lat"],[venueLocation objectForKey:@"lng"]];
        NSLog(@"%@",postData);
        [[UrlConnectionManager sharedInstance] postData:postData withUrl:@"https://www.dibstick.com/dibs_user.php"];
        //NSDictionary *params = [[NSDictionary alloc] initWithObjects:<#(NSArray *)#> forKeys:<#(NSArray *)#>]
    }
    
    
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:photo]]];
    [profileImg setImage:image];
    [lblName setText:name];
    [lblVenue setText:[NSString stringWithFormat:@"Last check-in:%@",venueName]];
    [lblDate setText:[NSString stringWithFormat:@"Last check-in date:%@",bar]];
    [XmppHandler sharedInstance].displayName = name;
    [XmppHandler sharedInstance].photo = UIImagePNGRepresentation(image);;
    [[XmppHandler sharedInstance] connect];
    
}

-(void) onUserDataSend:(NSData*) data {
    
}
-(IBAction)ShowUserList:(id)sender
{
    AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
    [app showUserListView];
}
@end
