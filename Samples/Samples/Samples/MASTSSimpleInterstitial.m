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
}

@end
