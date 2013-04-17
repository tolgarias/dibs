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
@interface UserListViewController ()

@end

@implementation UserListViewController

@synthesize users,userList,userTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        users = [[NSArray alloc] init];
    }
    return self;
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
    users = [jsonData objectForKey:@"userList"];
    [userTableView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%@",users);
    return [users count];
    //return 0;
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
    NSLog(@"index path: %i",indexPath.row);
    NSDictionary *userData = [users objectAtIndex:indexPath.row];
    NSNumber *createdAt =[[users objectAtIndex:indexPath.row] objectForKey:@"lastCheckInDate"];
    NSString *bar = [[NSDate dateWithTimeIntervalSince1970:[createdAt intValue]] description];

    cell.nameLabel.text = [[users objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.timeLabel.text=bar;
    //cell.thumbnailImageView.image = [UIImage imageNamed:@"Icon.png"];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[users objectAtIndex:indexPath.row] objectForKey:@"photo"]]]];
    cell.thumbnailImageView.image = image;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 78;
}
@end
