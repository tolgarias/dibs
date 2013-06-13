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
@interface ChatViewController ()

@end


@implementation ChatViewController
@synthesize tView,messageField,messages;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
    [app connect];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //messages = [[NSMutableArray alloc] init];
    
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
		
    }
	
	NSIndexPath *topIndexPath = [NSIndexPath indexPathForRow:messages.count-1
												   inSection:0];
	
	[self.tView scrollToRowAtIndexPath:topIndexPath
					  atScrollPosition:UITableViewScrollPositionMiddle
							  animated:YES];
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
		
		[cell.messageContentView setFrame:CGRectMake(padding, padding*2, size.width, size.height)];
		
		[cell.bgImageView setFrame:CGRectMake( cell.messageContentView.frame.origin.x - padding/2,
											  cell.messageContentView.frame.origin.y - padding/2,
											  size.width+padding,
											  size.height+padding)];
        
	} else {
        
		bgImage = [[UIImage imageNamed:@"aqua.png"] stretchableImageWithLeftCapWidth:24  topCapHeight:15];
		
		[cell.messageContentView setFrame:CGRectMake(320 - size.width - padding,
													 padding*2,
													 size.width,
													 size.height)];
		
		[cell.bgImageView setFrame:CGRectMake(cell.messageContentView.frame.origin.x - padding/2,
											  cell.messageContentView.frame.origin.y - padding/2,
											  size.width+padding,
											  size.height+padding)];
		
	}
	
	cell.bgImageView.image = bgImage;
	cell.senderAndTimeLabel.text = [NSString stringWithFormat:@"%@ %@", sender, time];
	
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
    //[textField setHidden:YES];
    return TRUE;
}

@end
