//
//  MillennialAdaptor.m
//  AdMobileSDK
//
//  Created by Constantine Mureev on 4/4/11.
//

#import "MillennialAdaptor.h"


@implementation MillennialAdaptor

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void) showWithAdType:(NSString*)adType
				  appId:(NSString*)appId
			   latitude:(NSString*)latitude
              longitude:(NSString*)longitude
                    zip:(NSString*)zip {
#ifdef INCLUDE_MILLENNIAL
    _loaded = NO;
    _latitide = [latitude retain];
    _longitude = [longitude retain];
    _zip = [zip retain];
	
	if ([adType isEqualToString:@"MMBannerAdBottom"]) {
		_type = MMBannerAdBottom;
	}
	else if ([adType isEqualToString:@"MMBannerAdRectangle"]) {
		_type = MMBannerAdRectangle;
	}
	else if ([adType isEqualToString:@"MMFullScreenAdLaunch"]) {
		_type = MMFullScreenAdLaunch;
	}
	else if ([adType isEqualToString:@"MMFullScreenAdTransition"]) {
		_type = MMFullScreenAdTransition;
	}
	else {
		_type = MMBannerAdTop;
	}
    
    // TODO: remove hardcode!
    
    _bannerView = [MMAdView adWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
                                   type:_type
                                   apid:appId
                               delegate:self
                                 loadAd:YES
                             startTimer:NO];
    
    [_bannerView retain];
	
	[self addSubview:_bannerView];
#endif
}

-(void)addSubview:(UIView*)view
{
    [super addSubview:view];
    
}

- (void)update {
#ifdef INCLUDE_MILLENNIAL
    if (_loaded) {
        [_bannerView refreshAd];
    }
#endif
}


#ifdef INCLUDE_MILLENNIAL

#pragma mark -
#pragma mark MMAdDelegate methods


- (NSDictionary *) requestData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_latitide forKey:@"lat"];
    [params setObject:_longitude forKey:@"long"];
    [params setObject:_zip forKey:@"zip"];
	return params;
}

// Set the timer duration for the rotation of ads in seconds. Default: 60
// - (NSInteger) adRefreshDuration;

/**
 * Use this method to disable the accelerometer. Default: YES
 */	
// - (BOOL) accelerometerEnabled;

// Return true to enable test mode.
- (BOOL) testMode { return NO; }

/**
 * If the following methods are implemented, the delegate will be notified when
 * an ad request succeeds or fails. An ad request is considered to have failed
 * in any situation where no ad is recived.
 */



// - (void)adDidRefresh:(MMAdView *)adView;


- (void)adRequestSucceeded:(MMAdView *) adView {
    _loaded = YES;
	if (self.superview) {
        NSMutableDictionary* senfInfo = [NSMutableDictionary dictionary];
        [senfInfo setObject:self.superview forKey:@"adView"];
        [senfInfo setObject:self forKey:@"subView"];
        [[NotificationCenter sharedInstance] postNotificationName:kReadyAdDisplayNotification object:senfInfo];
    }
}

- (void)adRequestFailed:(MMAdView *) adView {
    _loaded = YES;
    if (self.superview) {
        NSError* error = [[NSError alloc] initWithDomain:@"Millennial ad request failed" code:234 userInfo:nil];
        
        NSMutableDictionary* info = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:error, self.superview, nil]
                                                                       forKeys:[NSArray arrayWithObjects:@"error", @"adView", nil]];
        [error release];
        
        [[NotificationCenter sharedInstance] postNotificationName:kFailAdDownloadNotification object:info];
    }
}

//- (void)adDidRefresh:(MMAdView *)adView;

- (void)adWasTapped:(MMAdView *) adView {
    if (self.superview) {
        // track url        
        [[NotificationCenter sharedInstance] postNotificationName:kTrackUrlNotification object:self.superview];
    }
}

//Asks the delegate to allow safari to be openned
//- (void)applicationWillTerminateFromAd;


- (void)adModalWillAppear {
    if (self.superview) {
        // send callback
        NSMutableDictionary* sendInfo = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:self.superview, nil]
                                                                           forKeys:[NSArray arrayWithObjects:@"adView", nil]];
        
        [[NotificationCenter sharedInstance] postNotificationName:kOpenInternalBrowserNotification object:sendInfo];
        
        [_bannerView retain];
    }
}

//- (void)adModalDidAppear;

- (void)adModalWasDismissed {
    if (self.superview) {
        [[NotificationCenter sharedInstance] postNotificationName:kCloseInternalBrowserNotification object:self.superview];
    }
}
#endif

- (void)dealloc {
#ifdef INCLUDE_MILLENNIAL
    _bannerView.delegate = nil;
    [_bannerView release];
#endif
    [_latitide release];
    [_longitude release];
    [_zip release];
    [super dealloc];
}


@end
