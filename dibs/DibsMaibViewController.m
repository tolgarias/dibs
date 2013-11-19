//
//  DibsMaibViewController.m
//  dibs
//
//  Created by Tolga Saglam on 4/12/13.
//
//

#import "DibsMaibViewController.h"
#import "FacebookManager.h"

@interface DibsMaibViewController ()

@end

@implementation DibsMaibViewController

@synthesize infoLabel,hiImage;


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
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"viewbg.png"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem setTitle:@"Welcome To Dibs"];
    [hiImage setImage:[UIImage imageNamed:@"hi.png"]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)LoginWithFourSquare:(id)sender{
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"loginType"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[FoursquareManager sharedInstance] startAuth];
    //return self;
}

-(IBAction)LoginWithFacebook:(id)sender{
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"loginType"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if(FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded && FBSession.activeSession.isOpen){
        //[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GameLayer scene] withColor:ccWHITE]];
        //[[SceneManager sharedSceneManager] changeScene:kProfileLayer];
    }
    else {
        //[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[LoginLayer scene] withColor:ccWHITE]];
        //[[SceneManager sharedSceneManager] changeScene:kLoginLayer];
        [[FacebookManager sharedInstance] openSession];
        
    }

}

@end
