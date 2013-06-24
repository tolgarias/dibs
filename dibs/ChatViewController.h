//
//  ChatViewController.h
//  dibs
//
//  Created by Tolga Saglam's mac on 5/15/13.
//
//

#import <UIKit/UIKit.h>
#import "XMPPvCardTemp.h"
@interface ChatViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic,retain) NSMutableArray *messages;
@property (nonatomic,retain) IBOutlet UITableView *tView;
@property (nonatomic,retain) IBOutlet UITextField *messageField;
@property (nonatomic,retain) IBOutlet UILabel *chatter;
@property (atomic,retain) NSString* chatWith;
@property (nonatomic,retain) NSString* pictureUrl;
@property (nonatomic,retain) NSString* displayName;
@property (nonatomic,retain) XMPPvCardTemp* vCard;
@property (nonatomic,retain) NSString* msg;

-(id)initWithNibNameAndInfo:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil name:(NSString*) name picture:(NSString*) picture accessToken:(NSString*) accessToken;

-(id)initWithNibNameAndMessage:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil message:(NSString*) msg accessToken:(NSString*)acs;
-(IBAction) sendMessage:(id)sender;
+(NSString *) getCurrentTime;
@end
