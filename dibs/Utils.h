//
//  Utils.h
//  dibs
//
//  Created by Tolga Saglam on 4/19/13.
//
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

+(Utils*) sharedInstance;
-(NSString*) getIntervalString:(NSNumber  *) time;
-(NSString*) getToString:(NSNumber  *) time;
@end
