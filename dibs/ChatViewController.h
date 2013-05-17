//
//  ChatViewController.h
//  dibs
//
//  Created by Tolga Saglam's mac on 5/15/13.
//
//

#import <UIKit/UIKit.h>

@interface ChatViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic,retain) NSMutableArray *messages;
@property (nonatomic,retain) IBOutlet UITableView *tView;
@property (nonatomic,retain) IBOutlet UITextField *messageField;


-(IBAction) sendMessage:(id)sender;
+(NSString *) getCurrentTime;
@end
