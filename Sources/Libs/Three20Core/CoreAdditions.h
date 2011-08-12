//
//  CoreAdditions.h
//  AdMobileSDK
//
//  Created by Constantine Mureev on 3/5/11.
//  Copyright 2011 AdMobile Mobile. A subsidiary of Mojiva, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>


@interface CoreAdditions : NSObject {}

+ (id)object:(NSObject*)object performSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3;
+ (id)object:(NSObject*)object performSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3
  withObject:(id)p4;
+ (id)object:(NSObject*)object performSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3
  withObject:(id)p4 withObject:(id)p5;
+ (id)object:(NSObject*)object performSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3
  withObject:(id)p4 withObject:(id)p5 withObject:(id)p6;
+ (id)object:(NSObject*)object performSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3
  withObject:(id)p4 withObject:(id)p5 withObject:(id)p6 withObject:(id)p7;

+ (void)array:(NSArray*)array perform:(SEL)selector;
+ (void)array:(NSArray*)array perform:(SEL)selector withObject:(id)p1;
+ (void)array:(NSArray*)array perform:(SEL)selector withObject:(id)p1 withObject:(id)p2;
+ (void)array:(NSArray*)array perform:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3;

+ (NSString*)md5HashForData:(NSData*)data;
+ (NSString*)sha1HashForData:(NSData*)data;

+ (NSString*)md5HashForString:(NSString*)string;
+ (NSString*)sha1HashForString:(NSString*)string;

@end
