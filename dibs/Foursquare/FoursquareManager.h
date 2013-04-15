//
//  FoursquareManager.h
//  dibs
//
//  Created by Tolga Saglam on 4/15/13.
//
//

#import <Foundation/Foundation.h>
#import "BZFoursquare.h"
#import "BZFoursquareRequest.h"
//#import "ScreenManager.h"


//#define kClientID       FOURSQUARE_CLIENT_ID
//#define kCallbackURL    FOURSQUARE_CALLBACK_URL


@interface FoursquareManager : NSObject <BZFoursquareSessionDelegate,BZFoursquareRequestDelegate>{
    
}

@property (nonatomic,readwrite,strong) BZFoursquare *foursquare;
@property (nonatomic,strong) BZFoursquareRequest *request;
@property (nonatomic,copy) NSDictionary *meta;
@property (nonatomic,copy) NSArray *notifications;
@property (nonatomic,copy) NSDictionary *response;

@property (assign,nonatomic) id delegate;
@property (assign,nonatomic) SEL selector;


+(FoursquareManager*) sharedInstance;

-(void) startAuth;
-(void) getUserData;
@end


