//
//  MASTSSimpleInterstitial.m
//  MASTSamples
//
//  Created by Jason Dickert on 4/17/12.
//  Copyright (c) 2012 mOcean Mobile. All rights reserved.
//

#import "MASTSSimpleInterstitial.h"

@interface MASTSSimpleInterstitial ()

@end

@implementation MASTSSimpleInterstitial

- (void)loadView
{
    [super loadView];

    super.adView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | 
        UIViewAutoresizingFlexibleHeight;
 
    super.adView.frame = super.view.bounds;
    super.adView.backgroundColor = [UIColor whiteColor];
    //super.adView.autocloseInterstitialTime = 15;
    //super.adView.showCloseButtonTime = 5;
    
    [super.view bringSubviewToFront:super.adView];
    
    super.adView.delegate = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSInteger site = 19829;
    NSInteger zone = 88269;
    
    self.adView.site = [NSString stringWithFormat:@"%d", site];
    self.adView.zone = [NSString stringWithFormat:@"%d", zone];
    
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
}

#pragma mark -

- (void)didFailToReceiveAd:(id)sender withError:(NSError *)error
{
    [self.navigationController setNavigationBarHidden:NO];
    self.adView.hidden = YES;
}

- (void)didClosedAd:(id)sender usageTimeInterval:(NSTimeInterval)usageTimeInterval
{
    [self.navigationController setNavigationBarHidden:NO];
    self.adView.hidden = YES;
}

@end
