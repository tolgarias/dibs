//
//  DibsMaibViewController.h
//  dibs
//
//  Created by Tolga Saglam on 4/12/13.
//
//

#import <UIKit/UIKit.h>
#import "BZFoursquare.h"
#import "BZFoursquareRequest.h"

@interface DibsMaibViewController : UIViewController <BZFoursquareSessionDelegate,BZFoursquareRequestDelegate>{
    
}

@property (nonatomic,readwrite,strong) BZFoursquare *foursquare;
@property (nonatomic,strong) BZFoursquareRequest *request;
@property (nonatomic,copy) NSDictionary *meta;
@property (nonatomic,copy) NSArray *notifications;
@property (nonatomic,copy) NSDictionary *response;



-(IBAction)LoginWithFourSquare:(id)sender;
@property (nonatomic,strong) IBOutlet UIActivityIndicatorView *spinner;
@end
