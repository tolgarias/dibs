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
@property (nonatomic,retain) NSArray *users;
@property (nonatomic,retain) NSDictionary *userList;
@property (nonatomic,retain) IBOutlet UITableView *userTableView;
@end
