//
//  UserViewController.h
//  dibs
//
//  Created by Tolga Saglam on 4/15/13.
//
//

#import <UIKit/UIKit.h>
#import "FoursquareManager.h"


@interface UserViewController : UIViewController {
    BOOL isTimerStarted;
}

@property (nonatomic,strong) IBOutlet UIImageView *profileImg;

@property (nonatomic,strong) IBOutlet UILabel *lblName;
@property (nonatomic,strong) IBOutlet UILabel *lblVenue;
@property (nonatomic,strong) IBOutlet UILabel *lblDate;

@property (nonatomic,strong) IBOutlet UILabel *lblLikeBg;
@property (nonatomic,strong) IBOutlet UILabel *lblLike;

@property (nonatomic,strong) IBOutlet UILabel *lblLoading;

@property (nonatomic,strong) IBOutlet UIActivityIndicatorView *indicator;

@property (atomic,strong)  NSNumber *nextLike;


-(IBAction)ShowUserList:(id)sender;

-(void) getUserData_facebook;
-(void) getUserData_foursquare;
@end
