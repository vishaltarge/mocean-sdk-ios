//
//  DownloadController.m
//  AdMobileSDK
//
//  Created by Constantine Mureev on 2/21/11.
//

#import "DownloadController.h"
#import "NetworkQueue.h"

@interface DownloadController (PrivateMethods)

- (void)registerObserver;
- (void)startAdDownloadNotification:(NSNotification*)notification;
- (void)cancelAdDownloadNotification:(NSNotification*)notification;
- (void)removeAdNotification:(NSNotification*)notification;

@end


@implementation DownloadController

static DownloadController* sharedInstance = nil;

#pragma mark -
#pragma mark Singleton

- (id) init {
    self = [super init];
	if (self) {
		_adRequests = [AdRequests new];
        _cacheController = [[CacheController alloc] init];
		
		// TODO: add shared model
		//_sharedRequestQueue.userAgent = [SharedModel sharedInstance].userAgent;
		
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
	RELEASE_SAFELY(_adRequests);
	RELEASE_SAFELY(_cacheController);
	
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


- (void)cancelAll{
    [NetworkQueue cancelAll];
}

- (void)downladAd:(AdView*)adView {
    NSAutoreleasePool* pool = [NSAutoreleasePool new];
    
	@synchronized(_adRequests) {        
		if (adView) {
            // remove old requests
            //[_adRequests removeAd:adView];
            
            // start new reqest
            NSString* url = [[adView adModel] url];
            
            if (url) {
                NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
                [_adRequests addRequest:request forAd:adView];
                                
                NSMutableDictionary* info = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:request, adView, nil]
                                                                               forKeys:[NSArray arrayWithObjects:@"request", @"adView", nil]];
                [[NotificationCenter sharedInstance] postNotificationName:kGetAdServerResponseNotification object:info];
                
                [NetworkQueue loadWithRequest:request completion:^(NSURLRequest *req, NSHTTPURLResponse *response, NSData *data, NSError *error) {
                    if (error) {                        
                        @synchronized(_adRequests) {
                            if ([_adRequests containsRequest:request]) {
                                NSMutableDictionary* sendInfo = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:error, adView, nil]
                                                                                                   forKeys:[NSArray arrayWithObjects:@"error", @"adView", nil]];
                                
                                // remove from ads request array
                                [_adRequests removeRequest:request];
                                
                                if ([NSThread isMainThread]) {
                                    [[NotificationCenter sharedInstance] postNotificationName:kFailAdDownloadNotification object:sendInfo];
                                } else {
                                    [NotificationCenterAdditions NC:[NotificationCenter sharedInstance] postNotificationOnMainThreadWithName:kFailAdDownloadNotification object:sendInfo];
                                }
                            }
                        }
                    } else {
                        if ([_adRequests containsRequest:request]) {
                            NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                            NSArray* links = [Utils linksFromText:responseString];
                            [responseString release];
                            
                            if (links && [links count] > 0) {
                                [_cacheController loadLinks:links forAdView:adView request:request origData:data];
                            }
                            else {
                                if (adView && req) {
                                    NSMutableDictionary* infoBlock = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:request, data, adView, nil]
                                                                                                   forKeys:[NSArray arrayWithObjects:@"request", @"data", @"adView", nil]];
                                    [[NotificationCenter sharedInstance] postNotificationName:kFinishAdDownloadNotification object:infoBlock];
                                }
                            }
                            
                            // remove from ads request array
                            [_adRequests removeRequest:request];
                        }
                    }
                }];
            }
		}
	}
    
    [pool drain];
}


#pragma mark -
#pragma mark Private


- (void)registerObserver {
	[[NotificationCenter sharedInstance] addObserver:self selector:@selector(startAdDownloadNotification:) name:kStartAdDownloadNotification object:nil];
	[[NotificationCenter sharedInstance] addObserver:self selector:@selector(cancelAdDownloadNotification:) name:kAdStopUpdateNotification object:nil];
	[[NotificationCenter sharedInstance] addObserver:self selector:@selector(cancelAdDownloadNotification:) name:kAdCancelUpdateNotification object:nil];
	[[NotificationCenter sharedInstance] addObserver:self selector:@selector(cancelAdDownloadNotification:) name:kAdViewBecomeInvisibleNotification object:nil];
    
	[[NotificationCenter sharedInstance] addObserver:self selector:@selector(removeAdNotification:) name:kUnregisterAdNotification object:nil];
}

- (void)startAdDownloadNotification:(NSNotification*)notification {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self downladAd:[notification object]];
    });
}

- (void)cancelAdDownloadNotification:(NSNotification*)notification {
}

- (void)removeAdNotification:(NSNotification*)notification {
}

@end

