//
//  UserData.h
//  GuessMyFriend
//
//  Created by tolga SAGLAM on 1/12/13.
//
//

#import <Foundation/Foundation.h>

@interface UserData : NSObject

+(UserData*) sharedInstance;
    

@property (retain,atomic) NSString* name;
@property (retain,atomic) NSString* photoUrl;
@property (retain,atomic) NSString* accessToken;
@property (retain,atomic) NSString* lastCheckInVenue;
@property (retain,atomic) NSString* lastCheckInDate;


@end
