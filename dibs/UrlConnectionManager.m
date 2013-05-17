//
//  UrlConnectionManager.m
//  GuessMyFriend
//
//  Created by Tolga Saglam on 10/22/12.
//
//

#import "UrlConnectionManager.h"

@implementation UrlConnectionManager

@synthesize delegate =m_delegate;
@synthesize selector =m_selector;

static UrlConnectionManager* sharedInstance;
+(UrlConnectionManager*) sharedInstance {
    if(sharedInstance==nil){
        sharedInstance = [[UrlConnectionManager alloc] init];
    }
    return sharedInstance;
}

-(void) postData:(NSString *)post withUrl:(NSString *)url {

    NSData *pData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d",[pData length]];
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
    [request setHTTPBody:pData];
     NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if(conn)
    {
        NSLog(@"Connection Successful");
    }
    else
    {
        NSLog(@"Connection could not be made");
    }
}

-(void) connection:(NSURLConnection*) connection didReceiveData:(NSData *)data {
    NSError* e = nil;
    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error: &e];
    if(jsonData) {
        //NSNumber* dataType = [jsonData objectForKey:@"dataType"];
        [m_delegate performSelector:m_selector withObject:jsonData];
        
    }
}
@end
