//
//  XMPPMessenger.h
//  Messenger
//
//  Created by Himanshu Jadav on 10/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"
#import "XMPPPing.h"
#import "constant.h"
@class XMPPJID;

@interface XMPPMessenger : XMPPModule
{
//    XMPPStream *xmppStream;
	NSTimeInterval pingTimeout;
	XMPPJID *targetJID;
	NSString *targetJIDStr;
    
	BOOL awaitingPingResponse;
	XMPPPing *xmppPing;
}
/**
 * How long to wait after sending a ping before timing out.
 * 
 * The timeout is decoupled from the pingInterval to allow for longer pingIntervals,
 * which avoids flooding the network, and to allow more precise control overall.
 * 
 * After a ping is sent, if a reply is not received by this timeout,
 * the delegate method is invoked.
 * 
 * The default pingTimeout is 10 seconds.
 **/
@property (readwrite) NSTimeInterval pingTimeout;

/**
 * The target to send pings to.
 * 
 * If the targetJID is nil, this implies the target is the xmpp server we're connected to.
 * In this case, receiving any data means we've received data from the target.
 * 
 * If the targetJID is non-nil, it must be a full JID (user@domain.tld/rsrc).
 * In this case, the module will monitor the stream for data from the given JID.
 * 
 * The default targetJID is nil.
 **/
@property (readwrite, strong) XMPPJID *targetJID;

/**
 * XMPPAutoPing is used to automatically send pings on a regular interval.
 * Sometimes the target is also sending pings to us as well.
 * If so, you may optionally set respondsToQueries to YES to allow the module to respond to incoming pings.
 * 
 * If you create multiple instances of XMPPAutoPing or XMPPPing,
 * then only one instance should respond to queries. 
 * 
 * The default value is NO.
 **/
@property (readwrite) BOOL respondsToQueries;

-(void)sendMessage:(NSString*)message;
@end


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@protocol XMPPMessengerDelegate
@optional

- (void)xmppMessengerDidSendPing:(XMPPMessenger *)sender;
- (void)xmppMessengerDidReceivePong:(XMPPMessenger *)sender;
- (void)xmppMessengerDidReceiveMessage:(XMPPMessage *)message;
- (void)xmppMessengerDidSentMessage:(XMPPMessage *)message;
- (void)xmppMessengerDidTimeout:(XMPPMessenger *)sender;
@end