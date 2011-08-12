//
//  AdMobAdaptor.m
//  AdMobileSDK
//
//  Created by Constantine Mureev on 4/12/11.
//

#import "AdMobAdaptor.h"


@implementation AdMobAdaptor

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)dealloc
{
#ifdef INCLUDE_ADMOB
    [_latitide release];
    [_longitude release];
    [_zip release];
    [_pubId release];
    _adView.delegate = nil;
    [_adView removeFromSuperview];
    [_adView release];
#endif
    [super dealloc];
}

- (void)showWithPublisherID:(NSString*)publisherId
                   latitude:(NSString*)latitude
                  longitude:(NSString*)longitude
                        zip:(NSString*)zip {
#ifdef INCLUDE_ADMOB
    _loaded = NO;
    _latitide = [latitude retain];
    _longitude = [longitude retain];
    _zip = [zip retain];
    _pubId = [publisherId retain];
    _adView = [[GADBannerView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _adView.adUnitID = _pubId;
    _adView.delegate = self;
    _adView.rootViewController = [self.superview viewControllerForView];
    
    GADRequest* request = [GADRequest request];
    [request setLocationWithLatitude:[_latitide floatValue] longitude:[_longitude floatValue] accuracy:100.0f];
    if ([_pubId isEqualToString:@"a14d5d3001ef3a1"]) {
        request.testing = YES;
    }
    
    [_adView loadRequest:request];
    [self addSubview:_adView];
#endif
}

- (void)update {
#ifdef INCLUDE_ADMOB
    if (_loaded) {
        GADRequest* request = [GADRequest request];
        [request setLocationWithLatitude:[_latitide floatValue] longitude:[_longitude floatValue] accuracy:100.0f];
        if ([_pubId isEqualToString:@"a14d5d3001ef3a1"]) {
            request.testing = YES;
        }
        
        [_adView loadRequest:request];
    }
#endif
}

#ifdef INCLUDE_ADMOB

#pragma mark 
#pragma mark AdMob delegate



// Sent when an ad request loaded an ad.  This is a good opportunity to add this
// view to the hierarchy if it has not yet been added.  If the ad was received
// as a part of the server-side auto refreshing, you can examine the
// hasAutoRefreshed property of the view.
- (void)adViewDidReceiveAd:(GADBannerView *)view {
    _loaded = YES;
    if (self.superview) {
        NSMutableDictionary* senfInfo = [NSMutableDictionary dictionary];
        [senfInfo setObject:self.superview forKey:@"adView"];
        [senfInfo setObject:self forKey:@"subView"];
        [[NotificationCenter sharedInstance] postNotificationName:kReadyAdDisplayNotification object:senfInfo];
    }
}

// Sent when an ad request failed.  Normally this is because no network
// connection was available or no ads were available (i.e. no fill).  If the
// error was received as a part of the server-side auto refreshing, you can
// examine the hasAutoRefreshed property of the view.
- (void)adView:(GADBannerView *)view
didFailToReceiveAdWithError:(GADRequestError *)error {
    _loaded = YES;
    if (self.superview && error) {        
        NSMutableDictionary* info = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:error, self.superview, nil]
                                                                       forKeys:[NSArray arrayWithObjects:@"error", @"adView", nil]];
        
        [[NotificationCenter sharedInstance] postNotificationName:kFailAdDownloadNotification object:info];
    }
}

#pragma mark Click-Time Lifecycle Notifications

// Sent just before presenting the user a full screen view, such as a browser,
// in response to clicking on an ad.  Use this opportunity to stop animations,
// time sensitive interactions, etc.
//
// Normally the user looks at the ad, dismisses it, and control returns to your
// application by calling adViewDidDismissScreen:.  However if the user hits the
// Home button or clicks on an App Store link your application will end.  On iOS
// 4.0+ the next method called will be applicationWillResignActive: of your
// UIViewController (UIApplicationWillResignActiveNotification).  Immediately
// after that adViewWillLeaveApplication: is called.
- (void)adViewWillPresentScreen:(GADBannerView *)adView {
    if (self.superview) {
        // track url        
        [[NotificationCenter sharedInstance] postNotificationName:kTrackUrlNotification object:self.superview];
        
        // send callback
        NSMutableDictionary* sendInfo = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:self.superview, nil]
                                                                           forKeys:[NSArray arrayWithObjects:@"adView", nil]];
        
        [[NotificationCenter sharedInstance] postNotificationName:kOpenInternalBrowserNotification object:sendInfo];
    }
}

// Sent just before dismissing a full screen view.
//- (void)adViewWillDismissScreen:(GADBannerView *)adView;

// Sent just after dismissing a full screen view.  Use this opportunity to
// restart anything you may have stopped as part of adViewWillPresentScreen:.
- (void)adViewDidDismissScreen:(GADBannerView *)adView {
    if (self.superview) {
        [[NotificationCenter sharedInstance] postNotificationName:kCloseInternalBrowserNotification object:self.superview];
    }
}

// Sent just before the application will background or terminate because the
// user clicked on an ad that will launch another application (such as the App
// Store).  The normal UIApplicationDelegate methods, like
// applicationDidEnterBackground:, will be called immediately before this.
//- (void)adViewWillLeaveApplication:(GADBannerView *)adView;

#endif

@end
