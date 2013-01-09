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
    
    CGRect frame = super.adView.frame;
    frame.size.width = 320;
    super.adView.frame = frame;
    super.adView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
    // As with the BOTTOM sample, setup the frame for the bottom view.
    CGRect adjustedFrame = [[UIScreen mainScreen] bounds];
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]))
        adjustedFrame = CGRectMake(adjustedFrame.origin.x, adjustedFrame.origin.y,
                                   adjustedFrame.size.height, adjustedFrame.size.width);
    
    adjustedFrame.size.height -= [[UIApplication sharedApplication] statusBarFrame].size.height;
    
    frame = super.adView.frame;
    frame.origin.y = CGRectGetMaxY(adjustedFrame) - frame.size.height;
    
    // Setup (or possibly resetup) the BOTTOM ad view (super covers the adView)
    [self.bottomAdView reset];
    [self.bottomAdView removeFromSuperview];
    
    self.bottomAdView = [[[MASTAdView alloc] initWithFrame:frame] autorelease];
    self.bottomAdView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | 
        UIViewAutoresizingFlexibleTopMargin;
    self.bottomAdView.backgroundColor = self.adView.backgroundColor;
    [self.view addSubview:self.bottomAdView];
    
    super.adConfigController.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    
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

#pragma mark -

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
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
