//
//  Utils.m
//  AdMobileSDK
//
//  Created by Constantine Mureev on 3/1/11.
//

#import "Utils.h"
#import "Constants.h"
#import "UIAlertView+Blocks.h"
#import "UIActionSheet+Blocks.h"
#import "UIViewAdditions.h"
#import "UIWebViewAdditions.h"
#import "UIColorAdditions.m"

#import <SystemConfiguration/SystemConfiguration.h>

#include <sys/types.h>
#include <sys/sysctl.h>


void NSProfile(const char *name, void (^work) (void)) {
    struct timeval start, end;
    gettimeofday (&start, NULL);
    
    work();
    
    gettimeofday (&end, NULL);
    
    double fstart = (start.tv_sec * 1000000.0 + start.tv_usec) / 1000000.0;
    double fend = (end.tv_sec * 1000000.0 + end.tv_usec) / 1000000.0;
    
    printf("%s took %f seconds", name, fend - fstart);
}

// No-ops for non-retaining objects.
static const void* RetainNoOp(CFAllocatorRef allocator, const void *value) { return value; }
static void ReleaseNoOp(CFAllocatorRef allocator, const void *value) { }

NSMutableArray* CreateNonRetainingArray() {
    CFArrayCallBacks callbacks = kCFTypeArrayCallBacks;
    callbacks.retain = RetainNoOp;
    callbacks.release = ReleaseNoOp;
    return (NSMutableArray*)CFArrayCreateMutable(nil, 0, &callbacks);
}

NSMutableDictionary* CreateNonRetainingDictionary() {
    CFDictionaryKeyCallBacks keyCallbacks = kCFTypeDictionaryKeyCallBacks;
    CFDictionaryValueCallBacks callbacks = kCFTypeDictionaryValueCallBacks;
    callbacks.retain = RetainNoOp;
    callbacks.release = ReleaseNoOp;
    return (NSMutableDictionary*)CFDictionaryCreateMutable(nil, 0, &keyCallbacks, &callbacks);
}


@implementation Utils


+ (NSString*)platform
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);
    return platform;
}

+ (NSString*)platformFormatedString {
    NSString *platform = [Utils platform];
    if ([platform isEqualToString:@"iPhone1,1"])	return PLTFORM_IPHONE_1G;
    if ([platform isEqualToString:@"iPhone1,2"])	return PLTFORM_IPHONE_3G;
    if ([platform isEqualToString:@"iPhone2,1"])	return PLTFORM_IPHONE_3GS;
    if ([platform isEqualToString:@"iPhone3,1"])	return PLTFORM_IPHONE_4;
    if ([platform isEqualToString:@"iPod1,1"])		return PLTFORM_IPOD_1G;
    if ([platform isEqualToString:@"iPod2,1"])		return PLTFORM_IPOD_2G;
    if ([platform isEqualToString:@"iPod3,1"])		return PLTFORM_IPOD_3G;
    if ([platform isEqualToString:@"i386"])			return PLTFORM_IPHONE_SIMULATOR;
    return platform;
}

+ (NSArray*)linksFromText:(NSString*)text {
    NSMutableArray* links = [NSMutableArray array];
    
    // TODO: get src from \' and ' and cache!
	
	NSScanner* strScanner = [NSScanner scannerWithString:text];
	NSString* tempString = [NSString string];
	
	while([strScanner scanUpToString:@"src=\"" intoString:NULL] &&
		  [strScanner scanString:@"src=\"" intoString:NULL] &&
		  [strScanner scanUpToString:@"\"" intoString:&tempString])
	{
		[links addObject:tempString];
	}
	
	return links;
}

+ (NSURL*)appUrl:(NSURLRequest *)request {
	return [NSURL URLWithString:[[[request URL] absoluteString] stringByReplacingOccurrencesOfString:@"http" withString:@"itms-apps"]];
}

+ (BOOL)canGetHexColor:(UIColor*)color {
    return [color canProvideRGBComponents];
}

+ (NSString*)hexColor:(UIColor*)color {
    if ([color canProvideRGBComponents]) {
        return [color hexStringFromColor];
    } else {
        return nil;
    }
}

+ (NSString*)videoUrlFromString:(NSString*)string {
	NSString* result = nil;
	
	NSScanner* strScanner = [NSScanner scannerWithString:string];
	NSString* tempString = [NSString string];
	
	if ([strScanner scanUpToString:@"<video" intoString:NULL] &&
		[strScanner scanUpToString:@"src=\"" intoString:NULL] &&
		[strScanner scanString:@"src=\"" intoString:NULL] &&
		[strScanner scanUpToString:@"\"" intoString:&tempString]) {
		result = tempString;
	}
	
	return result;
}

+ (NSString*)aHrefUrlfromString:(NSString*)string {
	NSString* result = nil;
	
	NSScanner* strScanner = [NSScanner scannerWithString:string];
	NSString* tempString = [NSString string];
	
	if ([strScanner scanUpToString:@"href=\"" intoString:NULL] &&
		[strScanner scanString:@"href=\"" intoString:NULL] &&
		[strScanner scanUpToString:@"\"" intoString:&tempString]) {
		result = tempString;
	}
	
	return result;
}

+ (BOOL)isInternalURL:(NSURL*)url {
    NSString* strURL = [url absoluteString];
    if (url && strURL) {        
        BOOL internalURL = YES;
        
        if ([strURL rangeOfString:@"http://"].location == NSNotFound) {
            internalURL = NO;
        } else {
            if ([strURL rangeOfString:@".apple.com/WebObjects"].location != NSNotFound) {
                internalURL = NO;
            } else if ([strURL rangeOfString:@"itunes.apple.com/"].location != NSNotFound) {
                internalURL = NO;
            } else if ([strURL rangeOfString:@"mailto:"].location != NSNotFound) {
                internalURL = NO;
            } else if ([strURL rangeOfString:@"tel:"].location != NSNotFound) {
                internalURL = NO;
            } else if ([strURL rangeOfString:@"sms:"].location != NSNotFound) {
                internalURL = NO;
            } else if ([strURL rangeOfString:@"www.youtube.com"].location != NSNotFound) {
                internalURL = NO;
            } else if ([strURL rangeOfString:@"maps.google.com/maps?"].location != NSNotFound) {
                internalURL = NO;
            }
        }
        
        return internalURL;
    } else {
        return  NO;
    }
    
    return YES;
}

+ (NSInteger)randomInteger:(NSInteger)maxInt {
    return arc4random() % maxInt;
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
	return [Utils md5HashForData:[string dataUsingEncoding:NSUTF8StringEncoding]];
}

+ (NSString*)sha1HashForString:(NSString*)string {
	return [Utils sha1HashForData:[string dataUsingEncoding:NSUTF8StringEncoding]];
}

+ (void)makeLibraryLinked {
    useCatagory3();
    useCatagory4();
    useCatagory5();
    useCatagory6();
}

@end
