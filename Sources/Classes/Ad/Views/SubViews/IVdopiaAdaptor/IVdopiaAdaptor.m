//
//  IVdopiaAdaptor.m
//  AdMobileSDK
//
//  Created by Constantine Mureev on 4/6/11.
//

#import "IVdopiaAdaptor.h"


@implementation IVdopiaAdaptor


- (void)dealloc {
#ifdef INCLUDE_IVDOPIA
	_bannerView.delegate = nil;
    //[_bannerView close];
    //[_bannerView release];
#endif
    
    [super dealloc];
}

- (void) showWithAppKey:(NSString*)appKey {
#ifdef INCLUDE_IVDOPIA
	_bannerView = [VDOAds alloc];
	_bannerView.delegate = self;
	[_bannerView openWithAppKey:appKey
                    useLocation:FALSE
                      withFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
               startWithBanners:YES
                startWithPreApp:NO];
	
	[_bannerView playVDOAd];
	[_bannerView retain];
	
	[self addSubview:_bannerView.adObject];
#endif
}

#ifdef INCLUDE_IVDOPIA

#pragma mark -
#pragma mark iVdopia Delagate methods


- (void) displayedBanner {
	if (self.superview) {
        NSMutableDictionary* senfInfo = [NSMutableDictionary dictionary];
        [senfInfo setObject:self.superview forKey:@"adView"];
        [senfInfo setObject:self forKey:@"subView"];
        [[NotificationCenter sharedInstance] postNotificationName:kReadyAdDisplayNotification object:senfInfo];
    }
}

- (void) noBanner {
    if (self.superview) {
        NSError* error = [[NSError alloc] initWithDomain:@"iVdopia ad request failed. no Banner" code:234 userInfo:nil];
        
        NSMutableDictionary* info = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:error, self.superview, nil]
                                                                       forKeys:[NSArray arrayWithObjects:@"error", @"adView", nil]];
        [error release];
        
        [[NotificationCenter sharedInstance] postNotificationName:kFailAdDownloadNotification object:info];
    }
}

- (void) noInApp {
    if (self.superview) {
        NSError* error = [[NSError alloc] initWithDomain:@"iVdopia ad request failed. no In App" code:234 userInfo:nil];
        
        NSMutableDictionary* info = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:error, self.superview, nil]
                                                                       forKeys:[NSArray arrayWithObjects:@"error", @"adView", nil]];
        [error release];
        
        [[NotificationCenter sharedInstance] postNotificationName:kFailAdDownloadNotification object:info];
    }
}

- (void) bannerTapStarted {
    if (self.superview) {
        // track url        
        [[NotificationCenter sharedInstance] postNotificationName:kTrackUrlNotification object:self.superview];
        
        // send callback
        NSMutableDictionary* sendInfo = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:self.superview, nil]
                                                                           forKeys:[NSArray arrayWithObjects:@"adView", nil]];
        
        [[NotificationCenter sharedInstance] postNotificationName:kOpenInternalBrowserNotification object:sendInfo];
    }
}


- (void) bannerTapEnded {
    if (self.superview) {
        [[NotificationCenter sharedInstance] postNotificationName:kCloseInternalBrowserNotification object:self.superview];
    }
}

#endif

@end

