//
//  AdController.m
//  AdMobileSDK
//
//  Created by Constantine Mureev on 2/24/11.
//

#import "AdController.h"

#import "NotificationCenterAdditions.h"
#import "UIViewAdditions.h"
#import "Utils.h"


@interface AdController ()

- (void)visibleCheckerThread;

- (void)addAdView:(AdView*)adView;
- (void)removeAdView:(AdView*)adView;

- (void)registerObserver;
- (void)registerAd:(NSNotification*)notification;
- (void)unregisterAd:(NSNotification*)notification;
- (void)adDownloaded:(NSNotification*)notification;
- (void)adClicked:(NSNotification*)notification;
- (void)adOpenRequest:(NSNotification*)notification;
- (void)failToReceiveAd:(NSNotification*)notification;
- (void)trackExternalCampaignURL:(NSNotification*)notification;

@end


@implementation AdController

@synthesize checkerThread;

static AdController* sharedInstance = nil;

#pragma mark -
#pragma mark Singleton

- (id) init {
    self = [super init];
	if (self) {
		_ads = [NSMutableArray new];
		_adsVisibleState = [NSMutableArray new];
		_adUpdateControllers = [NSMutableArray new];
		_visibleCheckerThreadValid = NO;
		
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
	RELEASE_SAFELY(_ads);
	RELEASE_SAFELY(_adsVisibleState);
	RELEASE_SAFELY(_adUpdateControllers);
	
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


#pragma mark -
#pragma mark Private


- (void)visibleCheckerThread {
	NSAutoreleasePool* pool = [NSAutoreleasePool new];
	
	self.checkerThread = [NSThread currentThread];
	
	while (_visibleCheckerThreadValid) {
		@synchronized(_ads) {
			NSUInteger ind = 0;
			for (AdView* adView in _ads) {
				BOOL newState = [adView isViewVisible];
				BOOL oldSate = [((NSNumber*)[_adsVisibleState objectAtIndex:ind]) boolValue];
				
				if (oldSate != newState) {
					// set new value
					[_adsVisibleState replaceObjectAtIndex:ind withObject:[NSNumber numberWithBool:newState]];
					
					if (oldSate == NO) {
						// ad become visible
						[[NotificationCenter sharedInstance] postNotificationName:kAdViewBecomeVisibleNotification object:adView];
					}
					else {
						// ad become invisible
						[[NotificationCenter sharedInstance] postNotificationName:kAdViewBecomeInvisibleNotification object:adView];
					}

				}
				
				ind++;
			}
		}
		[NSThread sleepForTimeInterval:0.5];
	}
	
	[pool drain];
}

- (void)addAdView:(AdView*)adView {
	NSAutoreleasePool* pool = [NSAutoreleasePool new];
    
	@synchronized(_ads) {
		[_ads addObject:adView];
		[_adsVisibleState addObject:[NSNumber numberWithBool:[adView isViewVisible]]];
		
		//start visible checker thread
		if ([_ads count] == 1) {
			_visibleCheckerThreadValid = YES;
			[NSThread detachNewThreadSelector:@selector(visibleCheckerThread) toTarget:self withObject:nil];
		}
	}
    
	[pool drain];
}

- (void)removeAdView:(AdView*)adView {
	NSAutoreleasePool* pool = [NSAutoreleasePool new];
	
	@synchronized(_ads) {
		NSUInteger ind = [_ads indexOfObject:adView];
		
		if (ind != NSNotFound) {
			AdUpdater* updater = [_adUpdateControllers objectAtIndex:ind];
			[updater invalidate];
			[_adUpdateControllers removeObjectAtIndex:ind];
		}
		
		[_ads removeObject:adView];
		
		//stop visible checker thread
		if ([_ads count] == 0) {
			_visibleCheckerThreadValid = NO;
		}
	}
	
	[pool drain];
}

- (void)registerObserver {
	[[NotificationCenter sharedInstance] addObserver:self selector:@selector(registerAd:) name:kRegisterAdNotification object:nil];
	[[NotificationCenter sharedInstance] addObserver:self selector:@selector(unregisterAd:) name:kUnregisterAdNotification object:nil];
	[[NotificationCenter sharedInstance] addObserver:self selector:@selector(adDownloaded:) name:kFinishAdDownloadNotification object:nil];
	[[NotificationCenter sharedInstance] addObserver:self selector:@selector(adClicked:) name:kOpenURLNotification object:nil];
	[[NotificationCenter sharedInstance] addObserver:self selector:@selector(adOpenRequest:) name:kOpenVerifiedRequestNotification object:nil];
	[[NotificationCenter sharedInstance] addObserver:self selector:@selector(failToReceiveAd:) name:kFailAdDownloadNotification object:nil];
	[[NotificationCenter sharedInstance] addObserver:self selector:@selector(trackExternalCampaignURL:) name:kTrackUrlNotification object:nil];
}

- (void)statrLoad:(AdView*)adView {
    AdModel* adModel = [adView adModel];

    if ( adModel.latitude == nil && adModel.longitude == nil )
    {
#ifdef INCLUDE_LOCATION_MANAGER
        if ([LocationManager sharedInstance].currentLocationCoordinate.longitude == 0 &&
            [LocationManager sharedInstance].currentLocationCoordinate.latitude == 0)
        {
            [[LocationManager sharedInstance] startUpdatingLocation];                    
        }
#endif
    }

	[[NotificationCenter sharedInstance] postNotificationName:kStartAdDownloadNotification object:adView];
}

- (void)registerAd:(NSNotification*)notification {
	AdView* adView = [notification object];
    
    AdUpdater* updater = [AdUpdater new];
    updater.adView = adView;
    [_adUpdateControllers addObject:updater];
    [updater release];
    
	[NSThread detachNewThreadSelector:@selector(addAdView:) toTarget:self withObject:adView];
	
    [self performSelector:@selector(statrLoad:) withObject:adView afterDelay:0.1];
}

- (void)unregisterAd:(NSNotification*)notification {
	AdView* adView = [notification object];
    
	[NSThread detachNewThreadSelector:@selector(removeAdView:) toTarget:self withObject:adView];
}

- (void)processDownload:(NSNotification*)notification {
    NSAutoreleasePool* pool = [NSAutoreleasePool new];
    
    NSDictionary *info = [notification object];
	AdView* adView = [info objectForKey:@"adView"];
    AdModel* adModel = [adView adModel];
    
	NSURLRequest* request = [info objectForKey:@"request"];
	NSData* data = [info objectForKey:@"data"];
	AdDescriptor* adDescriptor = [AdDescriptor descriptorFromContent:data frameSize:[adView adModel].frame.size aligmentCenter:adModel.aligmentCenter];
    
	if (adDescriptor.adContentType == AdContentTypeInvalidParams) {
        [[NotificationCenter sharedInstance] postNotificationName:kInvalidParamsNotification object:adView];
    }
    else if (adDescriptor.adContentType != AdContentTypeEmpty && adDescriptor.adContentType != AdContentTypeUndefined) {
        if (adModel && [adModel.descriptor.serverReponse isEqualToData:adDescriptor.serverReponse]) {
            if (adDescriptor.adContentType == AdContentTypeDefaultHtml) {
                [pool release];
                return;
            } else if (adDescriptor.adContentType == AdContentTypeGreystripe ||
                       adDescriptor.adContentType == AdContentTypeAdMob ||
                       adDescriptor.adContentType == AdContentTypeMillennial) {
                NSMutableDictionary* senfInfo = [NSMutableDictionary dictionary];
                
                NSUInteger ind = NSNotFound;
                @synchronized(_ads) {
                    ind = [_ads indexOfObject:adView];
                }
                
                if (ind != NSNotFound) {
                    [senfInfo setObject:adView forKey:@"adView"];
                    [senfInfo setObject:adDescriptor forKey:@"descriptor"];
                    [NotificationCenterAdditions NC:[NotificationCenter sharedInstance] postNotificationOnMainThreadWithName:kUpdateAdDisplayNotification object:senfInfo];
                }
            }
            
            [pool release];
            return;
        }
        
        NSMutableDictionary* senfInfo = [NSMutableDictionary dictionary];
        
        NSUInteger ind = NSNotFound;
        @synchronized(_ads) {
            ind = [_ads indexOfObject:adView];
        }
		
        if (ind != NSNotFound) {
            [senfInfo setObject:adView forKey:@"adView"];
            [senfInfo setObject:adDescriptor forKey:@"descriptor"];
            [NotificationCenterAdditions NC:[NotificationCenter sharedInstance] postNotificationOnMainThreadWithName:kStartAdDisplayNotification object:senfInfo];
        }
    }
    else
    {
        NSMutableDictionary* senfInfo = [NSMutableDictionary dictionary];
        [senfInfo setObject:adView forKey:@"adView"];
        [senfInfo setObject:adDescriptor forKey:@"descriptor"];
        [NotificationCenterAdditions NC:[NotificationCenter sharedInstance] postNotificationOnMainThreadWithName:kFailAdDisplayNotification object:senfInfo];
    }
    
    [pool release];
}

- (void)adDownloaded:(NSNotification*)notification {
    [NSThread detachNewThreadSelector:@selector(processDownload:) toTarget:self withObject:notification];
}

- (void)adClicked:(NSNotification*)notification {
    NSDictionary *info = [notification object];
	AdView* adView = [info objectForKey:@"adView"];
    NSURLRequest* request = [info objectForKey:@"request"];
    
    if (adView && request) {
            NSMutableDictionary* sendInfo = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:request, adView, nil]
                                                                               forKeys:[NSArray arrayWithObjects:@"request", @"adView", nil]];
            
            [[NotificationCenter sharedInstance] postNotificationName:kVerifyRequestNotification object:sendInfo];
    }
}

- (void)adOpenRequest:(NSNotification*)notification {
    NSDictionary *info = [notification object];
	AdView* adView = [info objectForKey:@"adView"];
    NSURLRequest* request = [info objectForKey:@"request"];
    
    if (adView && request) {
        // check url
        if ([Utils isInternalURL:[request URL]]) {
            [[NotificationCenter sharedInstance] postNotificationName:kShouldOpenInternalBrowserNotification object:info];
        } else {
            [[NotificationCenter sharedInstance] postNotificationName:kShouldOpenExternalAppNotification object:info];
        }
    }
}

- (void)failToReceiveAd:(NSNotification*)notification {
    @synchronized(notification) {
        NSDictionary *info = [notification object];
        AdView* adView = [info objectForKey:@"adView"];
        NSError* error = [info objectForKey:@"error"];
        
        AdModel* model = [adView adModel];
        
        if (adView && error && model && model.descriptor && model.descriptor.campaignId) {
            if (model.excampaigns) {
                BOOL find = NO;
                for (NSString* campaing in model.excampaigns) {
                    if ([campaing isEqualToString:model.descriptor.campaignId]) {
                        find = YES;
                        break;
                    }
                }
                if (!find) {
                    [model.excampaigns addObject:model.descriptor.campaignId];
                    [[NotificationCenter sharedInstance] postNotificationName:kStartAdDownloadNotification object:adView];
                }
            }
            else {
                model.excampaigns = [NSMutableArray arrayWithObject:model.descriptor.campaignId];
                [[NotificationCenter sharedInstance] postNotificationName:kStartAdDownloadNotification object:adView];
            }
        }
    }
}

- (void)sendTrackRequest:(NSURLRequest*)request {
    NSAutoreleasePool* pool = [NSAutoreleasePool new];
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    [pool release];
}

- (void)trackExternalCampaignURL:(NSNotification*)notification {
    @synchronized(notification) {
        AdView* adView = [notification object];        
        AdModel* model = [adView adModel];
        
        if (adView && model && model.descriptor && model.descriptor.trackUrl) {
            NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:model.descriptor.trackUrl]];
            
            [NSThread detachNewThreadSelector:@selector(sendTrackRequest:) toTarget:self withObject:request];
        }
    }
}

@end
