//
//  MASTSSimpleInterstitialClassic.m
//  MASTSamples
//
//  Created by Jason Dickert on 4/17/12.
//  Copyright (c) 2012 mOcean Mobile. All rights reserved.
//

#import "MASTSSimpleInterstitialClassic.h"

@interface MASTSSimpleInterstitialClassic ()

@end

@implementation MASTSSimpleInterstitialClassic

- (void)loadView
{
    [super loadView];

    super.adView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | 
        UIViewAutoresizingFlexibleHeight;
 
    super.adView.frame = super.view.bounds;
    super.adView.backgroundColor = [UIColor whiteColor];

    [super.view bringSubviewToFront:super.adView];
    [self.adView showCloseButton:YES afterDelay:5];
    
    super.adView.delegate = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSInteger site = 19829;
    NSInteger zone = 88269;
    
    self.adView.site = site;
    self.adView.zone = zone;
    
    super.adConfigController.site = site;
    super.adConfigController.zone = zone;
 
    super.adConfigController.buttonTitle = @"Show";
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
    
    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

#pragma mark -

- (void)updateAdWithConfig:(MASTSAdConfigController *)configController
{
    [self.navigationController setNavigationBarHidden:YES];
    
    [super updateAdWithConfig:configController];
    
    self.adView.hidden = NO;
    [super.view bringSubviewToFront:super.adView];
    [self.adView showCloseButton:YES afterDelay:5];
}

#pragma mark -

- (void)MASTAdView:(MASTAdView *)adView didFailToReceiveAdWithError:(NSError *)error
{
    [self.navigationController setNavigationBarHidden:NO];
    self.adView.hidden = YES;
}

- (void)MASTAdViewCloseButtonPressed:(MASTAdView *)adView
{
    [self.navigationController setNavigationBarHidden:NO];
    self.adView.hidden = YES;
}

@end
