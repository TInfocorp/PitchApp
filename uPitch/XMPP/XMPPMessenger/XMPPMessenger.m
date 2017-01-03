//
//  XMPPMessenger.m
//  Messenger
//
//  Created by Himanshu Jadav on 10/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "XMPPMessenger.h"
#import "XMPPPing.h"
#import "XMPP.h"
#import "XMPPLogging.h"

#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

/**
 * Does ARC support support GCD objects?
 * It does if the minimum deployment target is iOS 6+ or Mac OS X 10.8+
 **/
#if TARGET_OS_IPHONE

// Compiling for iOS

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 60000 // iOS 6.0 or later
#define NEEDS_DISPATCH_RETAIN_RELEASE 0
#else                                         // iOS 5.X or earlier
#define NEEDS_DISPATCH_RETAIN_RELEASE 1
#endif

#else

// Compiling for Mac OS X

#if MAC_OS_X_VERSION_MIN_REQUIRED >= 1080     // Mac OS X 10.8 or later
#define NEEDS_DISPATCH_RETAIN_RELEASE 0
#else
#define NEEDS_DISPATCH_RETAIN_RELEASE 1     // Mac OS X 10.7 or earlier
#endif

#endif

// Log levels: off, error, warn, info, verbose
// Log flags: trace
#if DEBUG
static const int xmppLogLevel __attribute__((unused)) = XMPP_LOG_LEVEL_WARN;
#else
static const int xmppLogLevel = XMPP_LOG_LEVEL_WARN;
#endif



@implementation XMPPMessenger

- (id)init
{
	return [self initWithDispatchQueue:NULL];
}

- (id)initWithDispatchQueue:(dispatch_queue_t)queue
{
	if ((self = [super initWithDispatchQueue:queue]))
	{
		pingTimeout = 10;
		
//		lastReceiveTime = 0;
		
		xmppPing = [[XMPPPing alloc] initWithDispatchQueue:queue];
		xmppPing.respondsToQueries = NO;
		
//		[xmppPing addDelegate:self delegateQueue:moduleQueue];
	}
	return self;
}

- (BOOL)activate:(XMPPStream *)aXmppStream
{
	if ([super activate:aXmppStream])
	{
		[xmppPing activate:aXmppStream];
		
		return YES;
	}
	
	return NO;
}

- (void)deactivate
{
	dispatch_block_t block = ^{ @autoreleasepool {
		

		
//		lastReceiveTime = 0;
		awaitingPingResponse = NO;
		
		[xmppPing deactivate];
		[super deactivate];
		
	}};
	
	if (dispatch_get_specific(moduleQueueTag))
		block();
	else
		dispatch_sync(moduleQueue, block);
}

- (void)dealloc
{
	[xmppPing removeDelegate:self];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Properties
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSTimeInterval)pingTimeout
{
	if (dispatch_get_specific(moduleQueueTag))
	{
		return pingTimeout;
	}
	else
	{
		__block NSTimeInterval result;
		
		dispatch_sync(moduleQueue, ^{
			result = pingTimeout;
		});
		return result;
	}
}

- (void)setPingTimeout:(NSTimeInterval)timeout
{
	dispatch_block_t block = ^{
		
		if (pingTimeout != timeout)
		{
			pingTimeout = timeout;
		}
	};
	
	if (dispatch_get_specific(moduleQueueTag))
		block();
	else
		dispatch_async(moduleQueue, block);
}

- (XMPPJID *)targetJID
{
	if (dispatch_get_specific(moduleQueueTag))
	{
		return targetJID;
	}
	else
	{
		__block XMPPJID *result;
		
		dispatch_sync(moduleQueue, ^{
			result = targetJID;
		});
		return result;
	}
}

- (void)setTargetJID:(XMPPJID *)jid
{
	dispatch_block_t block = ^{
		
		if (![targetJID isEqualToJID:jid])
		{
			targetJID = jid;
			
			targetJIDStr = [targetJID full];
		}
	};
	
	if (dispatch_get_specific(moduleQueueTag))
		block();
	else
		dispatch_async(moduleQueue, block);
}

- (BOOL)respondsToQueries
{
	return xmppPing.respondsToQueries;
}

- (void)setRespondsToQueries:(BOOL)respondsToQueries
{
	xmppPing.respondsToQueries = respondsToQueries;
}
-(void)sendMessage:(NSString*)message
{
    [xmppPing sendPingToJID:self.targetJID withTimeout:pingTimeout message:message thread:[constant myWannAId] displayName:[constant myFirstName]];
}

- (void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message
{
//    [multicastDelegate xmppMessengerDidSentMessage:message];
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
//	if (targetJID == nil || [targetJIDStr isEqualToString:[message fromStr]])
//	{
//		lastReceiveTime = [NSDate timeIntervalSinceReferenceDate];
//	}
//    [multicastDelegate xmppMessengerDidReceiveMessage:message];
}

//- (NSString *)sendPingToJID:(XMPPJID *)jid
//{
//	// This is a public method.
//	// It may be invoked on any thread/queue.
//	
////	return [self sendPingToJID:jid withTimeout:DEFAULT_TIMEOUT];
//}
@end
