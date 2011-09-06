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
- (void)enableLogForAd:(AdView*)adView withLevel:(AdLogMode)logMode;
- (void)disableLogForAd:(AdView*)adView;
- (BOOL)isLogEnabled:(AdView*)adView forLevel:(AdLogMode)level;

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
        _ads = [NSMutableDictionary new];
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


- (void)enableLogForAd:(AdView*)adView withLevel:(AdLogMode)logMode {
    NSString* adPtr = [adView uid];
    @synchronized(_ads) {
        if (logMode == AdLogModeAll) {
            [_allLogAds addObject:adPtr];
        }
        
        [_ads setObject:[NSNumber numberWithInt:logMode] forKey:adPtr];
    }
}

- (void)disableLogForAd:(AdView*)adView {
    NSString* adPtr = [adView uid];
    
    @synchronized(_ads) {
        if ([_allLogAds containsObject:adPtr]) {
            [_allLogAds removeObject:adPtr];
        }
        
        [_ads removeObjectForKey:adPtr];
    }
}

- (BOOL)isLogEnabled:(AdView*)adView forLevel:(AdLogMode)level {
    NSString* adPtr = [NSString stringWithFormat:@"%ld", adView];
    
    @synchronized(_ads) {
        for (NSString* ptr in _ads) {
            if ([ptr isEqualToString:adPtr]) {
                NSNumber* num = [_ads objectForKey:ptr];
                AdLogMode logMode = (AdLogMode)[num intValue];
                if (logMode == level) {
                    return YES;
                } else if (logMode == AdLogModeAll) {
                    return YES;
                }  else {
                    return NO;
                }
            }
        }
    }
    
    return NO;
}

- (void)printNotification:(NSNotification*)notification {
    @synchronized(self) {
        if ([[notification name] isEqualToString:kAdStartLoggingAllNotification]) {
            NSObject* obj = [notification object];
            AdView* adView = (AdView*)obj;
            [self enableLogForAd:adView withLevel:AdLogModeAll];
        } else if ([[notification name] isEqualToString:kAdStartLoggingErrorsNotification]) {
            NSObject* obj = [notification object];
            AdView* adView = (AdView*)obj;
            [self enableLogForAd:adView withLevel:AdLogModeErrorsOnly];
        } else if ([[notification name] isEqualToString:kAdStopLoggingNotification]) {
            NSObject* obj = [notification object];
            AdView* adView = (AdView*)obj;
            [self disableLogForAd:adView];
        } else if ([_ads count] > 0) {
            NSObject* obj = [notification object];
            
            if ([obj isKindOfClass:[AdView class]]) {
                AdView* adView = (AdView*)obj;
                
                if ([self isLogEnabled:adView forLevel:AdLogModeAll]) {
                    if ([[notification name] isEqualToString:kStartAdDownloadNotification]) {
                        NSString* url = [[adView adModel] urlIgnoreValifation];
                        [Logger logWithFormat:@" ad(%ld) - %@ | url: %@", adView, [notification name], url];
                    } else {
                        [Logger logWithFormat:@" ad(%ld) - %@", adView, [notification name]];
                    }
                }
            } else if ([obj isKindOfClass:[NSDictionary class]]) {
                NSDictionary* dic = (NSDictionary*)obj;
                AdView* adView = [dic objectForKey:@"adView"];
                NSError* error = [dic objectForKey:@"error"];
                
                if ([self isLogEnabled:adView forLevel:AdLogModeErrorsOnly]) {
                    if ([adView isKindOfClass:[AdView class]] && [error isKindOfClass:[NSError class]]) {
                        [Logger logWithFormat:@" ad(%ld) - %@ | error: %@", adView, [notification name], [error description]];
                    } else if ([self isLogEnabled:adView forLevel:AdLogModeAll]) {
                        if ([adView isKindOfClass:[AdView class]]) {
                            [Logger logWithFormat:@" ad(%ld) - %@", adView, [notification name]];
                        }
                        else {
                            [Logger logWithFormat:@" - %@", [notification name]];
                        }
                    }
                }
            } else if ([_allLogAds count] > 0) {
                [Logger logWithFormat:@" - %@", [notification name]];
            }
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
