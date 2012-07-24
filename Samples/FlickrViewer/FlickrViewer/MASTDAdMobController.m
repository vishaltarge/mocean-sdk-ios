//
//  MASTDAdMobController.m
//  FlickrViewer
//
//  Copyright (c) 2012 mOcean Mobile. All rights reserved.
//

#import "MASTDAdMobController.h"
#import "GADBannerView.h"
#import "GADRequest.h"


@interface MASTDAdController ()
@property (nonatomic, strong) GADBannerView* bannerView;
@property (nonatomic, strong) NSString* publisherId;
@end


@implementation MASTDAdMobController

@synthesize bannerView, publisherId;

- (void)dealloc
{
    [self.bannerView setRootViewController:nil];
    [self.bannerView setDelegate:nil];
    self.bannerView = nil;
}

- (id)initWithAdFrame:(CGRect)adFrame campaignId:(NSString *)cid publisherId:(NSString*)pid
{
    self = [super initWithAdFrame:adFrame campaignId:cid];
    if (self)
    {
        self.publisherId = pid;
    }
    return self;
}

- (void)close
{
    [super close];
    
    [self.bannerView setRootViewController:nil];
    [self.bannerView setDelegate:nil];
    self.bannerView = nil;
    
    self.view = nil;
}

- (void)update
{
    [super update];

    GADRequest* request = [GADRequest request];
    request.testing = YES;
    
    [self.bannerView loadRequest:request];
}

#pragma mark -

- (void)loadView
{
    if (self.bannerView == nil)
    {
        GADAdSize adSize = GADAdSizeFromCGSize(self.adFrame.size);
        
        self.bannerView = [[GADBannerView alloc] initWithAdSize:adSize
                                                         origin:self.adFrame.origin];
        
        self.bannerView.delegate = self;
        self.bannerView.rootViewController = self.rootViewController;
        self.bannerView.adUnitID = self.publisherId;
    }
    
    self.view = self.bannerView;
}

#pragma mark -

// Sent when an ad request loaded an ad.  This is a good opportunity to add this
// view to the hierarchy if it has not yet been added.  If the ad was received
// as a part of the server-side auto refreshing, you can examine the
// hasAutoRefreshed property of the view.
- (void)adViewDidReceiveAd:(GADBannerView *)view
{
    
}

// Sent when an ad request failed.  Normally this is because no network
// connection was available or no ads were available (i.e. no fill).  If the
// error was received as a part of the server-side auto refreshing, you can
// examine the hasAutoRefreshed property of the view.
- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error
{
    
}

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
- (void)adViewWillPresentScreen:(GADBannerView *)adView
{
    
}

// Sent just before dismissing a full screen view.
- (void)adViewWillDismissScreen:(GADBannerView *)adView
{
    
}

// Sent just after dismissing a full screen view.  Use this opportunity to
// restart anything you may have stopped as part of adViewWillPresentScreen:.
- (void)adViewDidDismissScreen:(GADBannerView *)adView
{
    
}

// Sent just before the application will background or terminate because the
// user clicked on an ad that will launch another application (such as the App
// Store).  The normal UIApplicationDelegate methods, like
// applicationDidEnterBackground:, will be called immediately before this.
- (void)adViewWillLeaveApplication:(GADBannerView *)adView
{
    
}

@end
