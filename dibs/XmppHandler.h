//
//  XmppHandler.h
//  dibs
//
//  Created by Tolga Saglam's mac on 6/13/13.
//
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"

@interface XmppHandler : NSObject <XMPPRosterDelegate>
{
    XMPPStream *xmppStream;
	XMPPReconnect *xmppReconnect;
    XMPPRoster *xmppRoster;
	XMPPRosterCoreDataStorage *xmppRosterStorage;
    XMPPvCardCoreDataStorage *xmppvCardStorage;
	XMPPvCardTempModule *xmppvCardTempModule;
	XMPPvCardAvatarModule *xmppvCardAvatarModule;
	XMPPCapabilities *xmppCapabilities;
	XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;
	
	NSString *password;
	
	BOOL allowSelfSignedCertificates;
	BOOL allowSSLHostNameMismatch;
	
	BOOL isXmppConnected;
}

+(XmppHandler*) sharedInstance;


@property (nonatomic, strong, readonly) XMPPStream *xmppStream;
@property (nonatomic, strong, readonly) XMPPReconnect *xmppReconnect;
@property (nonatomic, strong, readonly) XMPPRoster *xmppRoster;
@property (nonatomic, strong, readonly) XMPPRosterCoreDataStorage *xmppRosterStorage;
@property (nonatomic, strong, readonly) XMPPvCardTempModule *xmppvCardTempModule;
@property (nonatomic, strong, readonly) XMPPvCardAvatarModule *xmppvCardAvatarModule;
@property (nonatomic, strong, readonly) XMPPCapabilities *xmppCapabilities;
@property (nonatomic, strong, readonly) XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;
@property (nonatomic,strong) NSString* displayName;
@property (nonatomic,strong) NSData* photo;
@property (nonatomic,assign) id delegate;
@property (nonatomic,assign) SEL selector;
@property (nonatomic,strong) NSString* chatWith;

- (NSManagedObjectContext *)managedObjectContext_roster;
- (NSManagedObjectContext *)managedObjectContext_capabilities;

- (BOOL)connect;
- (void)disconnect;
-(void) sendMessage:(NSString*) msg;
-(void) registerUser:(NSString*) username;
-(void) updateVCard:(NSString*) display photo:(NSData*) ph;
-(XMPPUserCoreDataStorageObject*) getUser:(NSString*) username;
-(XMPPvCardTemp*) getVCard:(NSString*) username;
@end
