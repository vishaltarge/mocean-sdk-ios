//
//  MASTSAdvancedTopAndBottom.m
//  AdMobileSamples
//
//  Created by Jason Dickert on 4/18/12.
//  Copyright (c) 2012 mOcean Mobile. All rights reserved.
//

#import "MASTSAdvancedTopAndBottom.h"

@interface MASTSAdvancedTopAndBottom ()
@property (nonatomic, retain) MASTSAdConfigController* bottomAdConfigController;
@property (nonatomic, retain) MASTAdView* bottomAdView;
@property (nonatomic, assign) BOOL bottomFirstAppear;
@end

@implementation MASTSAdvancedTopAndBottom

@synthesize bottomAdConfigController, bottomAdView, bottomFirstAppear;

- (void)dealloc
{
    self.bottomAdConfigController = nil;
    self.bottomAdView = nil;
    
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.bottomFirstAppear = YES;
        
        self.bottomAdConfigController = [[MASTSAdConfigController new] autorelease];
        self.bottomAdConfigController.delegate = self;
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
    
    frame = super.adConfigController.view.frame;
    frame.origin.y += frame.size.height;
    self.bottomAdConfigController.view.frame = frame;
    self.bottomAdConfigController.view.autoresizingMask = super.adConfigController.view.autoresizingMask;
    [self.view addSubview:self.bottomAdConfigController.view];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSInteger topSite = 19829;
    NSInteger topZone = 98466;
    NSInteger bottomSite = 19829;
    NSInteger bottomZone = 98465;
    
    super.adView.site = topSite;
    super.adView.zone = topZone;
    self.bottomAdView.site = bottomSite;
    self.bottomAdView.zone = bottomZone;
    
    super.adView.backgroundColor = [UIColor clearColor];
    self.bottomAdView.backgroundColor = [UIColor clearColor];
    
    super.adConfigController.site = topSite;
    super.adConfigController.zone = topZone;
    self.bottomAdConfigController.site = bottomSite;
    self.bottomAdConfigController.zone = bottomZone;
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
    [UIView animateWithDuration:.2 
                     animations:^
     {
         self.adConfigController.view.center = self.view.center;
         CGRect frame = super.adConfigController.view.frame;
         frame.origin.y += frame.size.height;
         self.bottomAdConfigController.view.frame = frame;
     }];

    [super.adView update];
    [self.bottomAdView update];
}

#pragma mark -

- (void)keyboardDidShow:(id)notification
{
    [super keyboardDidShow:notification];
    
    CGRect frame = super.adConfigController.view.frame;
    frame.origin.y -= frame.size.height;
    super.adConfigController.view.frame = frame;
    frame.origin.y += frame.size.height;
    self.bottomAdConfigController.view.frame = frame;
}

- (void)keyboardWillHide:(id)notification
{
    [super keyboardWillHide:notification];
    
    CGRect frame = super.adConfigController.view.frame;
    frame.origin.y += frame.size.height;
    self.bottomAdConfigController.view.frame = frame;
}

#pragma mark -

- (void)updateAdWithConfig:(MASTSAdConfigController *)configController
{
    if (configController == super.adConfigController)
    {
        [super updateAdWithConfig:configController];
        return;
    }
    
    NSInteger site = configController.site;
    NSInteger zone = configController.zone;
    
    self.bottomAdView.site = site;
    self.bottomAdView.zone = zone;
    
    [self.bottomAdView update];
}

@end
