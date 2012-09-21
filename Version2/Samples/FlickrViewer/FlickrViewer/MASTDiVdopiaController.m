//
//  MASTDiVdopiaController.m
//  FlickrViewer
//
//  Copyright (c) 2012 mOcean Mobile. All rights reserved.
//

#import "MASTDiVdopiaController.h"


@interface MASTDiVdopiaController ()
@property (nonatomic, strong) VDOAds* vdoAds;
@property (nonatomic, strong) VDOAdObject* vdoAdObject;
@property (nonatomic, strong) NSString* appKey;
@property (nonatomic, assign) BOOL isTop;
@end


@implementation MASTDiVdopiaController

@synthesize vdoAds, vdoAdObject;
@synthesize appKey, isTop;

- (void)dealloc
{
    [self.vdoAds setDelegate:nil];
    [self.vdoAds close];
    self.vdoAds = nil;
    
    self.vdoAdObject = nil;
}

- (id)initWithAdFrame:(CGRect)adFrame campaignId:(NSString *)campaignId appKey:(NSString*)ak isTop:(BOOL)t
{
    self = [super initWithAdFrame:adFrame campaignId:campaignId];
    if (self)
    {
        self.appKey = ak;
        self.isTop = t;
    }
    return self;
}

- (void)loadView
{
    if (self.vdoAds == nil)
    {
        self.vdoAds = [VDOAds new];
        self.vdoAds.delegate = self;
        
        [vdoAds openWithAppKey:self.appKey useLocation:NO];
    }
    
    if (self.vdoAdObject == nil)
    {
        int location = top;
        if (!self.isTop)
            location = bottom;
        
        self.vdoAdObject = [self.vdoAds requestBannerOfSize:STANDARD_IPHONE_BANNER :location];
    }
    
    self.view = self.vdoAdObject.adObject;
}

#pragma mark -

//Either displayedBanner or noBanner will be called at any given time. Both will not be called
- (void) displayedBanner:(VDOAdObject*)object
{
    if (self.delegate != nil)
        [self.delegate adControllerDidReceiveAd:self];
}

- (void) noBanner:(VDOAdObject*)object
{
    if (self.delegate != nil)
        [self.delegate adControllerDidFailToReceiveAd:self withError:nil];
}

//Either playedInApp or noInApp will be called at any given time. Both will not be called
- (void) playedInApp:(VDOAdObject*)object
{
    
}

- (void) playedPreApp:(VDOAdObject*)object
{
    
}

- (void) noInApp:(VDOAdObject*)object
{
    
}

- (void) noPreApp:(VDOAdObject*)object
{
    
}

- (void) bannerTapStarted:(VDOAdObject*)object
{
    if (self.delegate != nil)
        [self.delegate adControllerAdOpened:self];
}

- (void) bannerTapEnded:(VDOAdObject*)object
{
    if (self.delegate != nil)
        [self.delegate adControllerAdClosed:self];
}

- (void) interstitialWillShow:(VDOAdObject*)object
{
    
}

- (void) interstitialDidDismiss:(VDOAdObject*)object
{
    
}


@end
