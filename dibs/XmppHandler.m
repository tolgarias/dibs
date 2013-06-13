//
//  XmppHandler.m
//  dibs
//
//  Created by Tolga Saglam's mac on 6/13/13.
//
//

#import "XmppHandler.h"

@implementation XmppHandler
static XmppHandler* sharedInstance;
+(XmppHandler*) sharedInstance {
    if(sharedInstance == nil){
        sharedInstance = [[XmppHandler alloc] init];
    }
    return sharedInstance;
}
@end
