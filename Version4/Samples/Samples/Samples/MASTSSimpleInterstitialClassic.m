/*
 
 * PubMatic Inc. ("PubMatic") CONFIDENTIAL
 
 * Unpublished Copyright (c) 2006-2014 PubMatic, All Rights Reserved.
 
 *
 
 * NOTICE:  All information contained herein is, and remains the property of PubMatic. The intellectual and technical concepts contained
 
 * herein are proprietary to PubMatic and may be covered by U.S. and Foreign Patents, patents in process, and are protected by trade secret or copyright law.
 
 * Dissemination of this information or reproduction of this material is strictly forbidden unless prior written permission is obtained
 
 * from PubMatic.  Access to the source code contained herein is hereby forbidden to anyone except current PubMatic employees, managers or contractors who have executed
 
 * Confidentiality and Non-disclosure agreements explicitly covering such access.
 
 *
 
 * The copyright notice above does not evidence any actual or intended publication or disclosure  of  this source code, which includes
 
 * information that is confidential and/or proprietary, and is a trade secret, of  PubMatic.   ANY REPRODUCTION, MODIFICATION, DISTRIBUTION, PUBLIC  PERFORMANCE,
 
 * OR PUBLIC DISPLAY OF OR THROUGH USE  OF THIS  SOURCE CODE  WITHOUT  THE EXPRESS WRITTEN CONSENT OF PubMatic IS STRICTLY PROHIBITED, AND IN VIOLATION OF APPLICABLE
 
 * LAWS AND INTERNATIONAL TREATIES.  THE RECEIPT OR POSSESSION OF  THIS SOURCE CODE AND/OR RELATED INFORMATION DOES NOT CONVEY OR IMPLY ANY RIGHTS
 
 * TO REPRODUCE, DISCLOSE OR DISTRIBUTE ITS CONTENTS, OR TO MANUFACTURE, USE, OR SELL ANYTHING THAT IT  MAY DESCRIBE, IN WHOLE OR IN PART.
 
 */

//
//  MASTSSimpleInterstitialClassic.m
//  MASTSamples
//
//  Created on 4/17/12.

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
    
    NSInteger zone = 88269;
    
    self.adView.zone = zone;
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

- (void)configPrompt:(MASTSAdConfigPrompt *)prompt refreshWithZone:(NSInteger)zone
{
    [self.navigationController setNavigationBarHidden:YES];
    
    [super configPrompt:prompt refreshWithZone:zone];
    
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
