//
//  MASTSAdvancedAnimation.m
//  AdMobileSamples
//
/*
 * PubMatic Inc. (“PubMatic”) CONFIDENTIAL
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

#import "MASTSAdvancedAnimation.h"

@interface MASTSAdvancedAnimation ()

@end

@implementation MASTSAdvancedAnimation

- (void)loadView
{
    [super loadView];
    
    super.adView.delegate = self;
    
    // Take the simple configuration frame (top banner) and move it off screen
    // until an ad is displayed then move/animate it on screen.
    CGRect frame = self.adView.frame;
    frame.origin.y -= frame.size.height;
    self.adView.frame = frame;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSInteger zone = 88269;
    
    super.adView.zone = zone;
}

#pragma mark - animations

- (void)animateHideAd
{
    CGRect frame = self.adView.frame;
    frame.origin.y = 0 - frame.size.height;
    self.adView.frame = frame;
}

- (void)animateShowAd
{
    [UIView animateWithDuration:.5
                     animations:^
     {
         CGRect frame = self.adView.frame;
         frame.origin.y = 0;
         self.adView.frame = frame;
     }];
}

#pragma mark - MASTAdViewDelegate

- (void)MASTAdViewDidRecieveAd:(MASTAdView *)adView
{
    NSLog(@"MASTAdViewDidRecieveAd:");

    [self performSelectorOnMainThread:@selector(animateShowAd) withObject:nil waitUntilDone:NO];
}

- (void)MASTAdView:(MASTAdView *)adView didFailToReceiveAdWithError:(NSError *)error
{
    NSLog(@"MASTAdView:didFailToReceiveAdWithError:");
    
    [self performSelectorOnMainThread:@selector(animateHideAd) withObject:nil waitUntilDone:NO];
}

#pragma mark -

- (void)configPrompt:(MASTSAdConfigPrompt*)prompt refreshWithZone:(NSInteger)zone
{
    [self animateHideAd];
    [super configPrompt:prompt refreshWithZone:zone];
}

@end
