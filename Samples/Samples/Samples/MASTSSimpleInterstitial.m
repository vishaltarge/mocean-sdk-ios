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

    // For interstitial, make it the full size of the
    // parent and setup some interstitial properties.
    
    self.adView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | 
        UIViewAutoresizingFlexibleHeight;
    
    super.adView.frame = super.view.bounds;
    super.adView.backgroundColor = [UIColor whiteColor];
    super.adView.autocloseInterstitialTime = 15;
    super.adView.showCloseButtonTime = 5;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSInteger site = 19829;
    NSInteger zone = 88269;
    
    super.adView.site = site;
    super.adView.zone = zone;
    
    super.adConfigController.site = site;
    super.adConfigController.zone = zone;
 
    super.adConfigController.buttonTitle = @"Show";
    
    // Show the ad view over the config controller.
    [super.view bringSubviewToFront:super.adView];
}

@end
