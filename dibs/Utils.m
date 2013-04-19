//
//  Utils.m
//  dibs
//
//  Created by Tolga Saglam on 4/19/13.
//
//

#import "Utils.h"

@implementation Utils
static Utils *sharedInstance;
+(Utils*) sharedInstance {
    if(sharedInstance==nil){
        sharedInstance = [[Utils alloc] init];
    }
    return sharedInstance;
}
-(id) init {
    self = [super self];
    return self;
}

-(NSString *) getIntervalString:(NSNumber *)timeInSeconds {
    NSTimeInterval currentTimeInSeconds = [[NSDate date] timeIntervalSince1970];
    double interval = currentTimeInSeconds-[timeInSeconds doubleValue];

    NSMutableString *result=[[NSMutableString alloc] init];
    if(interval>3600*24){
        return [[NSDate dateWithTimeIntervalSince1970:[timeInSeconds intValue]] description];
    }
    else {
        int hour = interval/3600;
        int minutes = (interval-hour*3600)/60;
        int seconds = interval - (hour*3600) - minutes*60;
        if(hour>0){
            [result appendString:[NSString stringWithFormat:@"%i hour(s) ",hour]];
        }
        if(minutes>0){
            [result appendString:[NSString stringWithFormat:@"%i minute(s) ",minutes]];
        }
        if(seconds>0){
            [result appendString:[NSString stringWithFormat:@"%i second(s) ",seconds]];
        }

    }
    return result;
}
@end
