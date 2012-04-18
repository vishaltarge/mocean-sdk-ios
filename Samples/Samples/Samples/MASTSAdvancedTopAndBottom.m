//
//  MASTSAdvancedTopAndBottom.m
//  AdMobileSamples
//
//  Created by Jason Dickert on 4/18/12.
//  Copyright (c) 2012 mOcean Mobile. All rights reserved.
//

#import "MASTSAdvancedTopAndBottom.h"

@interface MASTSAdvancedTopAndBottom ()
@property (nonatomic, retain) MASTAdView* bottomAdView;
@property (nonatomic, assign) BOOL bottomFirstAppear;
@end

@implementation MASTSAdvancedTopAndBottom

@synthesize bottomAdView, bottomFirstAppear;

- (id)init
{
    self = [super init];
    if (self)
    {
        self.bottomFirstAppear = YES;
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    // As with the BOTTOM sample, setup the frame for the bottom view.
    CGRect adjustedFrame = super.view.frame;
    adjustedFrame.size.height -= [[UIApplication sharedApplication] statusBarFrame].size.height;
    CGRect frame = super.adView.frame;
    frame.origin.y = CGRectGetMaxY(adjustedFrame) - frame.size.height;
    
    // Setup (or possibly resetup) the BOTTOM ad view (super covers the adView)
    [self.bottomAdView stopEverythingAndNotfiyDelegateOnCleanup];
    [self.bottomAdView removeFromSuperview];
    
    self.bottomAdView = [[[MASTAdView alloc] initWithFrame:frame] autorelease];
    self.bottomAdView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | 
        UIViewAutoresizingFlexibleTopMargin;
    self.bottomAdView.backgroundColor = self.adView.backgroundColor;
    self.bottomAdView.showPreviousAdOnError = self.adView.showPreviousAdOnError;
    self.bottomAdView.logMode = self.adView.logMode;
    [self.view addSubview:self.bottomAdView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSInteger site = 19829;
    NSInteger zone = 88269;
    
    super.adView.site = site;
    super.adView.zone = zone;
    self.bottomAdView.site = site;
    self.bottomAdView.zone = zone;
    
    super.adConfigController.site = site;
    super.adConfigController.zone = zone;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.bottomFirstAppear)
    {
        self.bottomFirstAppear = NO;
        [self.bottomAdView update];
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    
    [self.bottomAdView update];
}

#pragma mark -

- (void)updateAdWithConfig:(MASTSAdConfigController *)configController
{
    [super updateAdWithConfig:configController];

    NSInteger site = configController.site;
    NSInteger zone = configController.zone;

    self.bottomAdView.site = site;
    self.bottomAdView.zone = zone;

    [self.bottomAdView update];
}

@end
