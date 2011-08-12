//
//  IAdAdaptor.m
//  AdMobileSDK
//
//  Created by Constantine Mureev on 4/1/11.
//

#import "IAdAdaptor.h"


@implementation IAdAdaptor


- (id) initWithFrame:(CGRect)frame section:(NSString*)adSection {
    self = [super initWithFrame:frame];
    if (self) {
        loadedFirstTime = YES;
        _lastErorCode = 778;
#ifdef INCLUDE_IAD
        adBannerView = [[ADBannerView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        adBannerView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
        adBannerView.delegate = self;
        [self addSubview:adBannerView];
#endif
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame section:nil];
}

- (void)dealloc {
#ifdef INCLUDE_IAD
    adBannerView.delegate = nil;
    [adBannerView release];
#endif
    [super dealloc];
}


#pragma mark -
#pragma mark Public


- (void)updateSection:(NSString*)adSection {
    //
}

#ifdef INCLUDE_IAD

#pragma mark -
#pragma mark Private


#pragma mark -
#pragma mark ADBannerViewDelegate methods


- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave {
    if (self.superview) {
        // track url        
        [[NotificationCenter sharedInstance] postNotificationName:kTrackUrlNotification object:self.superview];
        
        // send callback
        NSMutableDictionary* sendInfo = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:self.superview, nil]
                                                                           forKeys:[NSArray arrayWithObjects:@"adView", nil]];
        
        [[NotificationCenter sharedInstance] postNotificationName:kOpenInternalBrowserNotification object:sendInfo];
    }
	
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner {
    if (self.superview) {
        [[NotificationCenter sharedInstance] postNotificationName:kCloseInternalBrowserNotification object:self.superview];
    }
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    if (self.superview) {
        NSMutableDictionary* senfInfo = [NSMutableDictionary dictionary];
        [senfInfo setObject:self.superview forKey:@"adView"];
        [senfInfo setObject:self forKey:@"subView"];
        [[NotificationCenter sharedInstance] postNotificationName:kReadyAdDisplayNotification object:senfInfo];
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    if (self.superview && [error code] != _lastErorCode) {
        _lastErorCode = [error code];
        /*
        if ([error code] == 3) {
            [[NotificationCenter sharedInstance] postNotificationName:kNoIAdAvailableNotification object:self.superview];
        }
        else {
            NSMutableDictionary* info = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:error, self.superview, nil]
                                                                           forKeys:[NSArray arrayWithObjects:@"error", @"adView", nil]];
            [[NotificationCenter sharedInstance] postNotificationName:kFailAdDownloadNotification object:info];
        }
         */
        
        NSMutableDictionary* info = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:error, self.superview, nil]
                                                                       forKeys:[NSArray arrayWithObjects:@"error", @"adView", nil]];
        [[NotificationCenter sharedInstance] postNotificationName:kFailAdDownloadNotification object:info];
    }
}

#endif

@end
