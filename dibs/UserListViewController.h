//
//  UserListViewController.h
//  dibs
//
//  Created by Tolga Saglam on 4/16/13.
//
//

#import <UIKit/UIKit.h>

@interface UserListViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
{
    
}
@property (atomic,strong) NSArray *users;
@property (nonatomic,retain) NSDictionary *userList;

@property (nonatomic,retain) IBOutlet UITableView *userTableView;
@property (nonatomic,retain) IBOutlet UILabel *loadingLabel;
@property (nonatomic,retain) IBOutlet UIActivityIndicatorView *indicator;

@property (nonatomic,retain) NSMutableArray* userDataArray;
@property (nonatomic,retain) NSNumber *selectedIndex;
@property (nonatomic,retain) IBOutlet UIActivityIndicatorView *activityView;
@property (nonatomic,retain) NSMutableDictionary *likes;
@property (nonatomic,retain) NSIndexPath *indx;


@end
