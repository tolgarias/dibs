//
//  HelloFoursquare.h
//  dibs
//
//  Created by Tolga Saglam on 4/9/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "BZFoursquare.h"
#import "BZFoursquareRequest.h"

@interface HelloFoursquare : CCLayer <BZFoursquareSessionDelegate,BZFoursquareRequestDelegate>{
    
}
@property (nonatomic,readwrite,strong) BZFoursquare *foursquare;
@property (nonatomic,strong) BZFoursquareRequest *request;
@property (nonatomic,copy) NSDictionary *meta;
@property (nonatomic,copy) NSArray *notifications;
@property (nonatomic,copy) NSDictionary *response;

+(CCScene *) scene;
@end
