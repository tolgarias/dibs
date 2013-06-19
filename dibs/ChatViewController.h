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
@property (nonatomic,retain) NSString* chatWith;
@property (nonatomic,retain) NSString* pictureUrl;
@property (nonatomic,retain) NSString* displayName;

-(id)initWithNibNameAndInfo:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil name:(NSString*) name picture:(NSString*) picture accessToken:(NSString*) accessToken;
-(IBAction) sendMessage:(id)sender;
+(NSString *) getCurrentTime;
@end
