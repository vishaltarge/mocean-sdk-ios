//
//  CoreAdditions.m
//  AdMobileSDK
//
//  Created by Constantine Mureev on 3/5/11.
//  Copyright 2011 AdMobile Mobile. A subsidiary of Mojiva, Inc. All rights reserved.
//

#import "CoreAdditions.h"


@implementation CoreAdditions



#pragma mark -
#pragma mark NSObject


+ (id)object:(NSObject*)object performSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3 {
	NSMethodSignature *sig = [object methodSignatureForSelector:selector];
	if (sig) {
		NSInvocation* invo = [NSInvocation invocationWithMethodSignature:sig];
		[invo setTarget:object];
		[invo setSelector:selector];
		[invo setArgument:&p1 atIndex:2];
		[invo setArgument:&p2 atIndex:3];
		[invo setArgument:&p3 atIndex:4];
		[invo invoke];
		if (sig.methodReturnLength) {
			id anObject;
			[invo getReturnValue:&anObject];
			return anObject;
		} else {
			return nil;
		}
	} else {
		return nil;
	}
}

+ (id)object:(NSObject*)object performSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3
  withObject:(id)p4 {
	NSMethodSignature *sig = [object methodSignatureForSelector:selector];
	if (sig) {
		NSInvocation* invo = [NSInvocation invocationWithMethodSignature:sig];
		[invo setTarget:object];
		[invo setSelector:selector];
		[invo setArgument:&p1 atIndex:2];
		[invo setArgument:&p2 atIndex:3];
		[invo setArgument:&p3 atIndex:4];
		[invo setArgument:&p4 atIndex:5];
		[invo invoke];
		if (sig.methodReturnLength) {
			id anObject;
			[invo getReturnValue:&anObject];
			return anObject;
		} else {
			return nil;
		}
	} else {
		return nil;
	}
}

+ (id)object:(NSObject*)object performSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3
  withObject:(id)p4 withObject:(id)p5 {
	NSMethodSignature *sig = [object methodSignatureForSelector:selector];
	if (sig) {
		NSInvocation* invo = [NSInvocation invocationWithMethodSignature:sig];
		[invo setTarget:object];
		[invo setSelector:selector];
		[invo setArgument:&p1 atIndex:2];
		[invo setArgument:&p2 atIndex:3];
		[invo setArgument:&p3 atIndex:4];
		[invo setArgument:&p4 atIndex:5];
		[invo setArgument:&p5 atIndex:6];
		[invo invoke];
		if (sig.methodReturnLength) {
			id anObject;
			[invo getReturnValue:&anObject];
			return anObject;
		} else {
			return nil;
		}
	} else {
		return nil;
	}
}

+ (id)object:(NSObject*)object performSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3
  withObject:(id)p4 withObject:(id)p5 withObject:(id)p6 {
	NSMethodSignature *sig = [object methodSignatureForSelector:selector];
	if (sig) {
		NSInvocation* invo = [NSInvocation invocationWithMethodSignature:sig];
		[invo setTarget:object];
		[invo setSelector:selector];
		[invo setArgument:&p1 atIndex:2];
		[invo setArgument:&p2 atIndex:3];
		[invo setArgument:&p3 atIndex:4];
		[invo setArgument:&p4 atIndex:5];
		[invo setArgument:&p5 atIndex:6];
		[invo setArgument:&p6 atIndex:7];
		[invo invoke];
		if (sig.methodReturnLength) {
			id anObject;
			[invo getReturnValue:&anObject];
			return anObject;
		} else {
			return nil;
		}
	} else {
		return nil;
	}
}

+ (id)object:(NSObject*)object performSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3
  withObject:(id)p4 withObject:(id)p5 withObject:(id)p6 withObject:(id)p7 {
	NSMethodSignature *sig = [object methodSignatureForSelector:selector];
	if (sig) {
		NSInvocation* invo = [NSInvocation invocationWithMethodSignature:sig];
		[invo setTarget:object];
		[invo setSelector:selector];
		[invo setArgument:&p1 atIndex:2];
		[invo setArgument:&p2 atIndex:3];
		[invo setArgument:&p3 atIndex:4];
		[invo setArgument:&p4 atIndex:5];
		[invo setArgument:&p5 atIndex:6];
		[invo setArgument:&p6 atIndex:7];
		[invo setArgument:&p7 atIndex:8];
		[invo invoke];
		if (sig.methodReturnLength) {
			id anObject;
			[invo getReturnValue:&anObject];
			return anObject;
		} else {
			return nil;
		}
	} else {
		return nil;
	}
}


#pragma mark -
#pragma mark NSArray


+ (void)array:(NSArray*)array perform:(SEL)selector {
	NSArray *copy = [[NSArray alloc] initWithArray:array];
	NSEnumerator* e = [copy objectEnumerator];
	for (id delegate; (delegate = [e nextObject]); ) {
		if ([delegate respondsToSelector:selector]) {
			[delegate performSelector:selector];
		}
	}
	[copy release];
}

+ (void)array:(NSArray*)array perform:(SEL)selector withObject:(id)p1 {
	NSArray *copy = [[NSArray alloc] initWithArray:array];
	NSEnumerator* e = [copy objectEnumerator];
	for (id delegate; (delegate = [e nextObject]); ) {
		if ([delegate respondsToSelector:selector]) {
			[delegate performSelector:selector withObject:p1];
		}
	}
	[copy release];
}

+ (void)array:(NSArray*)array perform:(SEL)selector withObject:(id)p1 withObject:(id)p2 {
	NSArray *copy = [[NSArray alloc] initWithArray:array];
	NSEnumerator* e = [copy objectEnumerator];
	for (id delegate; (delegate = [e nextObject]); ) {
		if ([delegate respondsToSelector:selector]) {
			[delegate performSelector:selector withObject:p1 withObject:p2];
		}
	}
	[copy release];
}

+ (void)array:(NSArray*)array perform:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3 {
	NSArray *copy = [[NSArray alloc] initWithArray:array];
	NSEnumerator* e = [copy objectEnumerator];
	for (id delegate; (delegate = [e nextObject]); ) {
		if ([delegate respondsToSelector:selector]) {
			[CoreAdditions object:delegate performSelector:selector withObject:p1 withObject:p2 withObject:p3];
		}
	}
	[copy release];
}


#pragma mark -
#pragma mark NSData


+ (NSString*)md5HashForData:(NSData*)data  {
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5([data bytes], [data length], result);
	
	return [NSString stringWithFormat:
			@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
			result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
			];
}

+ (NSString*)sha1HashForData:(NSData*)data {
	unsigned char result[CC_SHA1_DIGEST_LENGTH];
	CC_SHA1([data bytes], [data length], result);
	
	return [NSString stringWithFormat:
			@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
			result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15],
			result[16], result[17], result[18], result[19]
			];
}


#pragma mark -
#pragma mark NSString


+ (NSString*)md5HashForString:(NSString*)string {
	return [CoreAdditions md5HashForData:[string dataUsingEncoding:NSUTF8StringEncoding]];
}

+ (NSString*)sha1HashForString:(NSString*)string {
	return [CoreAdditions sha1HashForData:[string dataUsingEncoding:NSUTF8StringEncoding]];
}


@end
