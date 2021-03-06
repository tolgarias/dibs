//
//  ChatViewController.m
//  dibs
//
//  Created by Tolga Saglam's mac on 5/15/13.
//
//

#import "ChatViewController.h"
#import "SMMessageViewTableCell.h"
#import "AppDelegate.h"
#import "XmppHandler.h"
@interface ChatViewController ()

@end


@implementation ChatViewController {
    NSString *receiver;
}
@synthesize tView,messageField,messages,displayName,chatWith,pictureUrl,vCard,chatter;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    messages = [[NSMutableArray alloc] init];
    [XmppHandler sharedInstance].delegate=self;
    [XmppHandler sharedInstance].selector = @selector(messageReceived:);
    [[XmppHandler sharedInstance] connect];
    return self;
}

-(id) initWithNibNameAndInfo:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil name:(NSString *)name picture:(NSString *)picture accessToken:(NSString *)accessToken {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    messages = [[NSMutableArray alloc] init];
    [XmppHandler sharedInstance].delegate=self;
    [XmppHandler sharedInstance].selector = @selector(messageReceived:);
    //[[XmppHandler sharedInstance] connect];
    
    //pictureUrl = picture;
    chatWith = accessToken;
    //displayName = name;
    vCard = [[XmppHandler sharedInstance] getVCard:accessToken];
    return self;
}


-(id) initWithNibNameAndMessage:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil message:(NSString *)msg accessToken:(NSString *)acs{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    messages = [[NSMutableArray alloc] init];
    [XmppHandler sharedInstance].delegate=self;
    [XmppHandler sharedInstance].selector = @selector(messageReceived:);
    [XmppHandler sharedInstance].chatWith = [NSString stringWithFormat:@"%@@www.dibstick.com",acs];
    //chatWith =acs;
    //receiver = acs;
    ///NSLog(@"chatWith:%@",receiver);
    vCard  = [[XmppHandler sharedInstance] getVCard:acs];
    if(msg!=nil){
        [self messageReceived:msg];
    }
    return self;
}
-(void) messageReceived:(NSString*) msg{
    NSMutableDictionary *m = [[NSMutableDictionary alloc] init];
    [m setObject:msg forKey:@"msg"];
    [m setObject:@"other" forKey:@"sender"];
    [m setObject:[ChatViewController getCurrentTime] forKey:@"time"];
    
    [messages addObject:m];
    [self.tView reloadData];
    [m release];
    
    NSIndexPath *topIndexPath = [NSIndexPath indexPathForRow:messages.count-1
												   inSection:0];
	
	[self.tView scrollToRowAtIndexPath:topIndexPath
					  atScrollPosition:UITableViewScrollPositionMiddle
							  animated:YES];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage *image = [UIImage imageWithData:[vCard photo]];
    UIButton *a1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [a1 setFrame:CGRectMake(0.0f, 0.0f, 40.0f, 40.0f)];
    [a1 addTarget:self action:@selector(onProfileButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [a1 setImage:image forState:UIControlStateNormal];

    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:a1];
                                  //initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                  //initWithImage:image style:UIBarButtonItemStylePlain
                                  //target:self
                                  //action:@selector(onProfileButtonPressed)];
    [[self navigationItem] setRightBarButtonItem:barButton];
    [[self navigationItem] setTitle:[vCard nickname]];
    
    [self.tView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chatbg.png"]];
    [tempImageView setFrame:self.tView.frame];
    
    self.tView.backgroundView = tempImageView;
    [tempImageView release];
    
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"viewbg.png"] drawInRect:self.view.bounds];
    UIImage *image1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:image1];

}

-(void) onProfileButtonPressed{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


+(NSString *) getCurrentTime {
    
	NSDate *nowUTC = [NSDate date];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	[dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
	return [dateFormatter stringFromDate:nowUTC];
	
}


- (IBAction) sendMessage:(id)sender{
	receiver = [NSString stringWithFormat:@"%@@www.dibstick.com",chatWith];
    NSLog(@"ChatWith:%@",receiver);
    NSString *messageStr = self.messageField.text;
	
    if([messageStr length] > 0) {
		self.messageField.text = @"";
        NSMutableDictionary *m = [[NSMutableDictionary alloc] init];
		[m setObject:messageStr forKey:@"msg"];
		[m setObject:@"you" forKey:@"sender"];
		[m setObject:[ChatViewController getCurrentTime] forKey:@"time"];
		
		[messages addObject:m];
		[self.tView reloadData];
		[m release];
		[[XmppHandler sharedInstance] sendMessage:messageStr];
    }
	
	NSIndexPath *topIndexPath = [NSIndexPath indexPathForRow:messages.count-1
												   inSection:0];
	
	[self.tView scrollToRowAtIndexPath:topIndexPath
					  atScrollPosition:UITableViewScrollPositionMiddle
							  animated:YES];
    
    self.messageField.text = @"";
}


#pragma mark -
#pragma mark Table view delegates

static CGFloat padding = 20.0;


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	
	NSDictionary *s = (NSDictionary *) [messages objectAtIndex:indexPath.row];
	
	static NSString *CellIdentifier = @"MessageCellIdentifier";
	
	SMMessageViewTableCell *cell = (SMMessageViewTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
		cell = [[[SMMessageViewTableCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
	}
    
	NSString *sender = [s objectForKey:@"sender"];
	NSString *message = [s objectForKey:@"msg"];
	NSString *time = [s objectForKey:@"time"];
	
	CGSize  textSize = { 260.0, 10000.0 };
	CGSize size = [message sizeWithFont:[UIFont boldSystemFontOfSize:13]
					  constrainedToSize:textSize
						  lineBreakMode:UILineBreakModeWordWrap];
    
	
	size.width += (padding/2);
	
	
	cell.messageContentView.text = message;
	cell.accessoryType = UITableViewCellAccessoryNone;
	cell.userInteractionEnabled = NO;
	
    
	UIImage *bgImage = nil;
	
    
	if ([sender isEqualToString:@"you"]) { // left aligned
        
		bgImage = [[UIImage imageNamed:@"orange.png"] stretchableImageWithLeftCapWidth:24  topCapHeight:15];
		
		[cell.messageContentView setFrame:CGRectMake(padding, padding*2, size.width+5, size.height)];
		
		[cell.bgImageView setFrame:CGRectMake( cell.messageContentView.frame.origin.x - padding/2,
											  cell.messageContentView.frame.origin.y - padding/2,
											  size.width+padding,
											  size.height+padding)];
        
	} else {
        
		bgImage = [[UIImage imageNamed:@"aqua.png"] stretchableImageWithLeftCapWidth:24  topCapHeight:15];
		
		[cell.messageContentView setFrame:CGRectMake(320 - size.width - padding,
													 padding*2,
													 size.width+5,
													 size.height)];
		
		[cell.bgImageView setFrame:CGRectMake(cell.messageContentView.frame.origin.x - padding/2,
											  cell.messageContentView.frame.origin.y - padding/2,
											  size.width+padding,
											  size.height+padding)];
		
	}
	
	cell.bgImageView.image = bgImage;
	cell.senderAndTimeLabel.text = [NSString stringWithFormat:@"%@ %@", sender, time];
    cell.senderAndTimeLabel.alpha = 0.5;
	
	return cell;
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSDictionary *dict = (NSDictionary *)[messages objectAtIndex:indexPath.row];
	NSString *msg = [dict objectForKey:@"msg"];
	
	CGSize  textSize = { 260.0, 10000.0 };
	CGSize size = [msg sizeWithFont:[UIFont boldSystemFontOfSize:13]
				  constrainedToSize:textSize
					  lineBreakMode:UILineBreakModeWordWrap];
	
	size.height += padding*2;
	
	CGFloat height = size.height < 65 ? 65 : size.height;
	return height;
	
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return [messages count];
	
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	
	return 1;
	
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [messageField resignFirstResponder];
    
    receiver = [NSString stringWithFormat:@"%@@www.dibstick.com",chatWith];
    NSLog(@"ChatWith:%@",receiver);
    NSString *messageStr = self.messageField.text;
	
    if([messageStr length] > 0) {
		self.messageField.text = @"";
        NSMutableDictionary *m = [[NSMutableDictionary alloc] init];
		[m setObject:messageStr forKey:@"msg"];
		[m setObject:@"you" forKey:@"sender"];
		[m setObject:[ChatViewController getCurrentTime] forKey:@"time"];
		
		[messages addObject:m];
		[self.tView reloadData];
		[m release];
		[[XmppHandler sharedInstance] sendMessage:messageStr];
    }
	
	NSIndexPath *topIndexPath = [NSIndexPath indexPathForRow:messages.count-1
												   inSection:0];
	
	[self.tView scrollToRowAtIndexPath:topIndexPath
					  atScrollPosition:UITableViewScrollPositionMiddle
							  animated:YES];
    
    self.messageField.text = @"";

   
    return NO;
}

@end
