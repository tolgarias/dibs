//
//  UserListViewController.m
//  dibs
//
//  Created by Tolga Saglam on 4/16/13.
//
//

#import "UserListViewController.h"
#import "SimpleTableCell.h"
#import "UserData.h"
#import "UrlConnectionManager.h"
#import "Utils.h"
#import "AppDelegate.h"
#import "XmppHandler.h"
@interface UserListViewController ()
    -(void) likeUser:(BOOL) insertLike;
    
@end

@implementation UserListViewController

@synthesize users=users_,userList,userTableView,userDataArray,selectedIndex,likes;
@synthesize activityView,indx;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        users_ = [[NSArray alloc] init];
        userDataArray = [[NSMutableArray alloc] init];
            //[barButton setTitle:@"Like"];
            
        //activityView =[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        likes = [[NSMutableDictionary alloc] init];
    }
    return self;
}
-(void) likeUser:(BOOL)insertLike{
    if([[UserData sharedInstance].remainingLikeCount intValue]>0){
        NSString* like = @"0";
        if(insertLike==YES) {
            like = @"1";
        }
        NSString *postData = [NSString stringWithFormat:@"accessToken=%@&likeAccessToken=%@&venueId=%@&insertLike=%@",[UserData sharedInstance].accessToken,[[userDataArray objectAtIndex:[selectedIndex intValue]] objectForKey:@"accessToken"],[UserData sharedInstance].lastCheckInVenue,like];
        
        [UrlConnectionManager sharedInstance].delegate = self;
        [UrlConnectionManager sharedInstance].selector = @selector(onLikeResponse:);
        [[UrlConnectionManager sharedInstance] postData:postData withUrl:@"https://www.dibstick.com/dibs_likeuser.php"];
    
        [likes setObject:@"1" forKey:selectedIndex];
        [self.userTableView reloadData];
        int likeCount = [[UserData sharedInstance].remainingLikeCount intValue]-1;
        [UserData sharedInstance].remainingLikeCount = [NSNumber numberWithInt:likeCount];
        NSString *buttonTitle = [NSString stringWithFormat:@"%i like",[[UserData sharedInstance].remainingLikeCount intValue]];
        [[self navigationItem].rightBarButtonItem setTitle:buttonTitle];
        
        NSNumber *currentTime = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]+600];
        [[NSUserDefaults standardUserDefaults] setObject:currentTime forKey:@"likeTime"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
}
-(void) likeUserSelector {
    [self likeUser:NO];
}
-(void) likeButtonPressed {
    if(selectedIndex>0){
        [self likeUser:YES];
    }
}
bool activityIsLoaded = NO;
-(void) onLikeResponse:(NSDictionary*) jsonData{
    //NSLog(@"%@",jsonData);
    //[self ]
    NSNumber* result = [jsonData objectForKey:@"result"];
    if([result intValue]==0){
        /*[NSTimer scheduledTimerWithTimeInterval:1
                                         target:self
                                       selector:@selector(likeUserSelector)
                                       userInfo:nil
                                        repeats:NO];
        if(activityIsLoaded==NO){
            activityView.center = self.view.center;
            //[self.view addSubview:activityView];
            [activityView startAnimating];
            [activityView setHidden:NO];
            activityIsLoaded = YES;
        }*/
    }
    else {
        NSString* accessToken = [[userDataArray objectAtIndex:[selectedIndex intValue]] objectForKey:@"accessToken"];
       // NSString* displayName = [[userDataArray objectAtIndex:[selectedIndex intValue]] objectForKey:@"name"];
       // NSString* photo = [[userDataArray objectAtIndex:[selectedIndex intValue]] objectForKey:@"photo"];
        AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
        [app showChatView:nil accessToken:accessToken];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //[tableView reloadData];
    //tableData = [[NSArray alloc] initWithObjects:@"tolga",@"molga",nil];
    NSString *postData = [NSString stringWithFormat:@"accessToken=%@&venueId=%@",[UserData sharedInstance].accessToken,[UserData sharedInstance].lastCheckInVenue];
    NSLog(@"%@",postData);
    [UrlConnectionManager sharedInstance].delegate = self;
    [UrlConnectionManager sharedInstance].selector = @selector(onUserListReceived:);
    [[UrlConnectionManager sharedInstance] postData:postData withUrl:@"https://www.dibstick.com/dibs_userlist.php"];
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"viewbg.png"]];
    [tempImageView setFrame:self.userTableView.frame];
    
    self.userTableView.backgroundView = tempImageView;
    [tempImageView release];
    [self.navigationItem setTitle:[UserData sharedInstance].lastCheckInVenueName];
    
    if([[UserData sharedInstance].remainingLikeCount intValue]==0){
        NSNumber *lastLikeInSec = [[NSUserDefaults standardUserDefaults] objectForKey:@"likeTime"];
        NSNumber *currentTimeInSec = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
        if([currentTimeInSec doubleValue]-[lastLikeInSec doubleValue]>600){
            [UserData sharedInstance].remainingLikeCount = [NSNumber numberWithInt:1];
        }
    }
    
    
    NSString *buttonTitle = [NSString stringWithFormat:@"%i like",[[UserData sharedInstance].remainingLikeCount intValue]];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:buttonTitle style:UIBarButtonSystemItemAction target:self action:@selector(likeButtonPressed)];
    [[self navigationItem] setRightBarButtonItem:barButton];

}
-(void) onUserListReceived:(NSDictionary*) jsonData {
    //NSLog(@"%@",jsonData);
    users_ = (NSArray*)[jsonData objectForKey:@"userList"];
    for (NSDictionary* dic in users_) {
        //NSLog(@"name:%@",[dic objectForKey:@"name"]);
        [userDataArray addObject:dic];
    }
    [userTableView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%@",userDataArray);

    return [userDataArray count];
    //return 0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    selectedIndex = [NSNumber numberWithInt:indexPath.row];
    indx = indexPath;
    //NSLog(@"selected row:%i",indexPath.row);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString *simpleTableIdentifier = @"SimpleTableItem";
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    SimpleTableCell *cell = (SimpleTableCell*)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SimpleTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSNumber *createdAt =(NSNumber*)[[userDataArray objectAtIndex:indexPath.row] objectForKey:@"lastCheckInDate"];
    NSString *bar = [[Utils sharedInstance] getIntervalString:createdAt];
    
    cell.nameLabel.text = [[userDataArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.timeLabel.text=bar;
    //cell.thumbnailImageView.image = [UIImage imageNamed:@"Icon.png"];
    //UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[userDataArray objectAtIndex:indexPath.row] objectForKey:@"photo"]]]];
    NSString *act = [[userDataArray objectAtIndex:indexPath.row] objectForKey:@"accessToken"];
    //NSData *imageData = [[[XmppHandler sharedInstance] getVCard:act] photo];
    XMPPvCardTemp *vCard = [[XmppHandler sharedInstance] getVCard:act];
    UIImage *image  = [UIImage imageWithData:[vCard photo]];
    
    cell.thumbnailImageView.image = image;
    if([likes objectForKey:[NSNumber numberWithInt:indexPath.row]]!=nil){
        cell.likedImageView.image = [UIImage imageNamed:@"like.png"];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 78;
}
@end
