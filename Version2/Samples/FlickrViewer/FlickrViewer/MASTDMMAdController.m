//
//  MASTDMMAdController.m
//  FlickrViewer
//
//  Copyright (c) 2012 mOcean Mobile. All rights reserved.
//

#import "MASTDMMAdController.h"

@interface MASTDAdController ()
@property (nonatomic, strong) NSString* appId;
@property (nonatomic, strong) MMAdView* bannerView;
@end

@implementation MASTDMMAdController

@synthesize appId;
@synthesize bannerView;

- (void)dealloc
{
    self.bannerView.refreshTimerEnabled = NO;
    [self.bannerView setRootViewController:nil];
    [self.bannerView setDelegate:nil];
    self.bannerView = nil;
}

- (id)initWithAdFrame:(CGRect)adFrame campaignId:(NSString *)campaignId appId:(NSString*)aid
{
    self = [super initWithAdFrame:adFrame campaignId:campaignId];
    if (self)
    {
        self.appId = aid;
    }
    return self;
}

#pragma mark -

- (void)loadView
{
    if (self.bannerView == nil)
    {       
        self.bannerView = [MMAdView adWithFrame:self.adFrame 
                                           type:MMBannerAdTop 
                                           apid:self.appId
                                       delegate:self 
                                         loadAd:YES 
                                     startTimer:NO]; 
        
        self.bannerView.delegate = self;
        self.bannerView.rootViewController = self.rootViewController;
    }
    
    self.view = self.bannerView;
}


#pragma mark - MMAdDelegate

- (NSDictionary *)requestData
{
    // pass demographic data to serve targeted ads. For example
    return [NSDictionary dictionaryWithObjectsAndKeys: @"21224", @"zip", @"35", @"age", @"male", @"gender", nil]; 
}

// Set the timer duration for the rotation of ads in seconds. Default: 60
- (NSInteger)adRefreshDuration
{
    // Don't support the MMSDK refreshing since we want the Mocean SDK 
    // refreshing ad content which may not be another MM based ad.
    return 0;
}

/**
 * Use this method to disable the accelerometer. Default: YES
 */	
- (BOOL)accelerometerEnabled
{
    return YES;
}

/**
 * If the following methods are implemented, the delegate will be notified when
 * an ad request succeeds or fails. An ad request is considered to have failed
 * in any situation where no ad is received.
 */

- (void)adRequestSucceeded:(MMAdView *) adView
{
    NSLog(@"MM Ad request succeeded");
    
    if (self.delegate != nil)
        [self.delegate adControllerDidReceiveAd:self];
}

- (void)adRequestFailed:(MMAdView *) adView
{
    NSLog(@"MM Ad request failed");
    
    if (self.delegate != nil)
        [self.delegate adControllerDidFailToReceiveAd:self withError:nil];
}

- (void)adDidRefresh:(MMAdView *) adView
{
    NSLog(@"MM Ad refreshed");
    
    // Not sure if this is invoked in addition to adRequestSucceeded 
    // so treat both the same for now.
    if (self.delegate != nil)
        [self.delegate adControllerDidReceiveAd:self];
}

- (void)adWasTapped:(MMAdView *) adView
{
     NSLog(@"MM Ad was tapped");
}

- (void)adRequestIsCaching:(MMAdView *) adView
{
    NSLog(@"MM Ad request is caching");
}
- (void)adRequestFinishedCaching:(MMAdView *) adView successful: (BOOL) didSucceed
{
    NSLog(@"MM Ad request finished caching");
}

- (void)applicationWillTerminateFromAd
{
    NSLog(@"MM Application will terminate from Ad");
}

- (void)adModalWillAppear
{
    NSLog(@"MM Ad modal will appear");
}

- (void)adModalDidAppear
{
    NSLog(@"MM Ad modal did appear");
    
    if (self.delegate != nil)
        [self.delegate adControllerAdOpened:self];
}

- (void)adModalWasDismissed
{
    NSLog(@"MM Ad was dismissed");
    
    if (self.delegate != nil)
        [self.delegate adControllerAdClosed:self];
}


@end
