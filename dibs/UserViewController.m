//
//  UserViewController.m
//  dibs
//
//  Created by Tolga Saglam on 4/15/13.
//
//

#import "UserViewController.h"

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
    //UIImage *imageYouWantToPass = [UIImage imageNamed:@"Icon-72.png"];
    //[profileImg setImage:imageYouWantToPass];
    [FoursquareManager sharedInstance].delegate = self;
    [FoursquareManager sharedInstance].selector = @selector(onUserDataReceived:);
    [[FoursquareManager sharedInstance] getUserData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) onUserDataReceived:(NSObject*) data {
    NSDictionary* responseData = [FoursquareManager sharedInstance].response;
    NSString *photo = [[responseData objectForKey:@"user"] objectForKey:@"photo"];
    NSString *firstName = [[responseData objectForKey:@"user"] objectForKey:@"firstName"];
    NSString *lastName = [[responseData objectForKey:@"user"] objectForKey:@"lastName"];
    NSDictionary *checkIns = [[responseData objectForKey:@"user"] objectForKey:@"checkins"];
    NSLog(@"%@",checkIns);
    NSDictionary *venue = [[[checkIns objectForKey:@"items"] objectAtIndex:0] objectForKey:@"venue"];
    
    NSString *venueName = [venue objectForKey:@"name"];
    NSString *venueId = [venue objectForKey:@"id"];
    NSNumber *createdAt =[[[checkIns objectForKey:@"items"] objectAtIndex:0] objectForKey:@"createdAt"];
    NSString *bar = [[NSDate dateWithTimeIntervalSince1970:[createdAt intValue]] description];
    
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:photo]]];
    [profileImg setImage:image];
    [lblName setText:[NSString stringWithFormat:@"%@ %@",firstName,lastName]];
    [lblVenue setText:[NSString stringWithFormat:@"Last check-in:%@",venueName]];
    [lblDate setText:[NSString stringWithFormat:@"Last check-in date:%@",bar]];
    //NSLog(@"%@",photo);
}

@end
