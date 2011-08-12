//
//  Utils.h
//  AdMobileSDK
//
//  Created by Constantine Mureev on 3/1/11.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

#define RELEASE_SAFELY(__POINTER) { [__POINTER release]; __POINTER = nil; }
#define INVALIDATE_TIMER(__TIMER) { [__TIMER invalidate]; __TIMER = nil; }

#define RELEASE_CF_SAFELY(__REF) { if (nil != (__REF)) { CFRelease(__REF); __REF = nil; } }

#import "NSObject+SBJSON.h"
#import "NSString+SBJSON.h"
#import "UIViewAdditions.h"
#import "UIWebViewAdditions.h"
#import "UIColorAdditions.m"


NSMutableArray* CreateNonRetainingArray();
NSMutableDictionary* CreateNonRetainingDictionary();


@interface Utils : NSObject {}

+ (NSString*)platform;
+ (NSString*)platformFormatedString;

+ (NSArray*)linksFromText:(NSString*)text;

+ (NSURL*)appUrl:(NSURLRequest *)request;

+ (NSString*)hexColor:(UIColor*)color;

+ (NSString*)videoUrlFromString:(NSString*)string;
+ (NSString*)aHrefUrlfromString:(NSString*)string;

+ (void)makeLibraryLinked;
+ (BOOL)isInternalURL:(NSURL*)url;

+ (NSString*)md5HashForData:(NSData*)data;
+ (NSString*)sha1HashForData:(NSData*)data;
+ (NSString*)md5HashForString:(NSString*)string;
+ (NSString*)sha1HashForString:(NSString*)string;

@end