//
//  Logger.m
//  AdMobileSDK
//
//  Created by Constantine Mureev on 8/19/10.
//

#import "Logger.h"

@interface Logger()

- (void)registerObserver;

- (void)printNotification:(NSNotification*)notification;
- (void)enableLogForAd:(AdView*)adView;
- (void)disableLogForAd:(AdView*)adView;
- (BOOL)isLogEnabled:(AdView*)adView;

+ (void)showAlertWithMessage:(NSString*)message;
+ (void)printLogWithMessage:(NSString*)message;

+ (void)logWithString:(NSString*)message;
+ (void)logWithFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);

+ (void)logUsingAlertWithString:(NSString*)message;
+ (void)logUsingAlertWithFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);

@end


@implementation Logger

static Logger* sharedInstance = nil;


#pragma mark -
#pragma mark Singleton


- (id) init {
    self =[super init];
    
	if (self) {
        _ads = [NSMutableArray new];
        [self registerObserver];
	}
	
	return self;
}

+ (id)sharedInstance {
	@synchronized(self) {
		if (nil == sharedInstance) {
			sharedInstance = [[self alloc] init];
		}
	}
	return sharedInstance;
}

- (oneway void)superRelease {
    [_ads release];
	[super release];
}

+ (void)releaseSharedInstance {
	@synchronized(self) {
		[sharedInstance superRelease];
		sharedInstance = nil;
	}
}

+ (id)allocWithZone:(NSZone*)zone {
	@synchronized(self) {
		if (nil == sharedInstance) {
			sharedInstance = [super allocWithZone:zone];
		}
	}
	
	return sharedInstance;
}

- (id)copyWithZone:(NSZone *)zone {
	return sharedInstance;
}

- (id)retain {
	return sharedInstance;
}

- (unsigned)retainCount {
	return NSUIntegerMax;
}

- (oneway void)release {
	// Do nothing.
}

- (id)autorelease {
	return sharedInstance;
}


#pragma mark -
#pragma mark Public


- (void)registerObserver {
	[[NotificationCenter sharedInstance] addObserver:self selector:@selector(printNotification:) name:nil object:nil];
}

+ (void) logWithString:(NSString*)message
{
	[Logger printLogWithMessage:message];
}

+ (void) logWithFormat:(NSString*)format, ...
{
	va_list args;
	va_start(args, format);
	NSString* message = [LogBasicFormatter stringWithFormat:format valist:args];
	va_end(args);
	
	[Logger logWithString:message];
}

+ (void) logUsingAlertWithString:(NSString*)message
{
	[Logger printLogWithMessage:message];
	[Logger showAlertWithMessage:message];
}


+ (void) logUsingAlertWithFormat:(NSString*)format, ...
{
	va_list args;
	va_start(args, format);
	NSString* message = [LogBasicFormatter stringWithFormat:format valist:args];
	va_end(args);
	[Logger logUsingAlertWithString:message];
}


#pragma mark -
#pragma mark Private


- (void)enableLogForAd:(AdView*)adView {
    NSString* adPtr = [NSString stringWithFormat:@"%ld", adView];
    
    @synchronized(_ads) {
        [_ads addObject:adPtr];
    }
}

- (void)disableLogForAd:(AdView*)adView {
    NSString* adPtr = [NSString stringWithFormat:@"%ld", adView];
    
    @synchronized(_ads) {
        [_ads removeObject:adPtr];
    }
}

- (BOOL)isLogEnabled:(AdView*)adView {
    NSString* adPtr = [NSString stringWithFormat:@"%ld", adView];
    
    @synchronized(_ads) {
        for (NSString* ptr in _ads) {
            if ([ptr isEqualToString:adPtr]) {
                return YES;
            }
        }
    }
    
    return NO;
}

- (void)printNotification:(NSNotification*)notification {
    @synchronized(self) {
		NSObject* obj = [notification object];
        
        if ([obj isKindOfClass:[AdView class]]) {
            AdView* adView = (AdView*)obj;
            
            if ([[notification name] isEqualToString:kAdStartLoggingNotification]) {
                [self enableLogForAd:adView];
            }
            else if ([[notification name] isEqualToString:kAdStopLoggingNotification]) {
                [self disableLogForAd:adView];
                return;
            }
            
            if ([self isLogEnabled:adView]) {
                if ([[notification name] isEqualToString:kStartAdDownloadNotification]) {
                    NSString* url = [[adView adModel] url];
                    [Logger logWithFormat:@" ad(%ld) - %@ | url: %@", adView, [notification name], url];
                } else {
                    [Logger logWithFormat:@" ad(%ld) - %@", adView, [notification name]];
                }
            }
        }
        else if ([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary* dic = (NSDictionary*)obj;
            AdView* adView = [dic objectForKey:@"adView"];
            NSError* error = [dic objectForKey:@"error"];
            
            if ([[notification name] isEqualToString:kAdStartLoggingNotification]) {
                [self enableLogForAd:adView];
            }
            else if ([[notification name] isEqualToString:kAdStopLoggingNotification]) {
                [self disableLogForAd:adView];
                return;
            }
            
            if ([self isLogEnabled:adView]) {
                if ([adView isKindOfClass:[AdView class]] && [error isKindOfClass:[NSError class]]) {
                    [Logger logWithFormat:@" ad(%ld) - %@ | error: %@", adView, [notification name], [error description]];
                }
                else if ([adView isKindOfClass:[AdView class]]) {
                    [Logger logWithFormat:@" ad(%ld) - %@", adView, [notification name]];
                }
                else {
                    [Logger logWithFormat:@" - %@", [notification name]];
                }
            }        
        }
        else if (_ads && [_ads count] > 0) {
            [Logger logWithFormat:@" - %@", [notification name]];
        }
	}
}

+ (void)showAlertWithMessage:(NSString*)message
{
	if (TARGET_IPHONE_SIMULATOR) {
		if (message && [message length] > 0) {
			NSString* debugMessage = [[NSString alloc] initWithFormat:@":: Ad %@\nNOTE: this message displays only in the simulator", message];
			
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:debugMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil]; 
			[alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES]; 
			[alert release];
			
			[debugMessage release];
		}
	}
}

+ (void) printLogWithMessage:(NSString*)message
{
	if (message && [message length] > 0) {
		NSLog(@":: Ad %@", message);
	}
}

@end
