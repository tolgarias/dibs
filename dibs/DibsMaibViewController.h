//
//  DibsMaibViewController.h
//  dibs
//
//  Created by Tolga Saglam on 4/12/13.
//
//

#import <UIKit/UIKit.h>
#import "FoursquareManager.h"

@interface DibsMaibViewController : UIViewController{
    
}
@property (nonatomic,strong) IBOutlet UILabel *infoLabel;
@property (nonatomic,strong) IBOutlet UIImageView *hiImage;


-(IBAction)LoginWithFourSquare:(id)sender;

@end
