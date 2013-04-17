//
//  UserData.m
//  GuessMyFriend
//
//  Created by tolga SAGLAM on 1/12/13.
//
//

#import "UserData.h"

@implementation UserData
@synthesize name,photoUrl,accessToken,lastCheckInVenue,lastCheckInDate;

static UserData* sharedInstance;

+(UserData*) sharedInstance {
    if(sharedInstance==nil) {
        sharedInstance=[[UserData alloc] init];
    }
    return sharedInstance;
}

-(id) init {
    self = [super init];
    return self;
}
@end
