//
//  DibsMaibViewController.m
//  dibs
//
//  Created by Tolga Saglam on 4/12/13.
//
//

#import "DibsMaibViewController.h"


@interface DibsMaibViewController ()

@end

@implementation DibsMaibViewController




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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)LoginWithFourSquare:(id)sender{
    [[FoursquareManager sharedInstance] startAuth];
    //return self;
}



@end
