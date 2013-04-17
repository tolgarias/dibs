//
//  UrlConnectionManager.h
//  GuessMyFriend
//
//  Created by Tolga Saglam on 10/22/12.
//
//

#import <Foundation/Foundation.h>

@interface UrlConnectionManager : NSObject {
    SEL m_selector;
    id m_delegate;
}

@property (assign,nonatomic) id delegate;
@property (assign,nonatomic) SEL selector;

+(UrlConnectionManager*) sharedInstance;
-(void) postData:(NSString*) postData withUrl:(NSString*) url;


@end
