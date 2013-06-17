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
@interface UserListViewController ()
    -(void) likeUser:(BOOL) insertLike;
@end

@implementation UserListViewController

@synthesize users=users_,userList,userTableView,userDataArray,selectedIndex;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        users_ = [[NSArray alloc] init];
        userDataArray = [[NSMutableArray alloc] init];
        
            UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonItemStylePlain target:self action:@selector(likeButtonPressed)];
            [[self navigationItem] setRightBarButtonItem:barButton];
        
    }
    return self;
}
-(void) likeUser:(BOOL)insertLike{
    NSString* like = @"0";
    if(insertLike==YES) {
        like = @"1";
    }
    NSString *postData = [NSString stringWithFormat:@"accessToken=%@&likeAccessToken=%@&venueId=%@&insertLike=%@",[UserData sharedInstance].accessToken,[[userDataArray objectAtIndex:[selectedIndex intValue]] objectForKey:@"accessToken"],[UserData sharedInstance].lastCheckInVenue,like];
    NSLog(@"postData:%@",postData);
    [UrlConnectionManager sharedInstance].delegate = self;
    [UrlConnectionManager sharedInstance].selector = @selector(onLikeResponse:);
    [[UrlConnectionManager sharedInstance] postData:postData withUrl:@"https://www.dibstick.com/dibs_likeuser.php"];
}
-(void) likeUserSelector {
    [self likeUser:NO];
}
-(void) likeButtonPressed {
    [self likeUser:YES];
}
-(void) onLikeResponse:(NSDictionary*) jsonData{
    //NSLog(@"%@",jsonData);
    //[self ]
    NSNumber* result = [jsonData objectForKey:@"result"];
    if([result intValue]==0){
        [NSTimer scheduledTimerWithTimeInterval:1
                                         target:self
                                       selector:@selector(likeUserSelector)
                                       userInfo:nil
                                        repeats:NO];
    }
    else {
        AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
        [app showChatView];
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
}
-(void) onUserListReceived:(NSDictionary*) jsonData {
    NSLog(@"%@",jsonData);
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
    //NSLog(@"%@",users);

    return [users_ count];
    //return 0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    selectedIndex = [NSNumber numberWithInt:indexPath.row];
    NSLog(@"selected row:%i",indexPath.row);
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
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[userDataArray objectAtIndex:indexPath.row] objectForKey:@"photo"]]]];
    cell.thumbnailImageView.image = image;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 78;
}
@end
