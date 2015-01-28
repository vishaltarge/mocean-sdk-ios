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
//  MASTSErrorImage.m
//  Samples
//
//  Created on 1/14/13.

//

#import "MASTSErrorImage.h"

@interface MASTSErrorImage ()

@end

@implementation MASTSErrorImage

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    super.adView.delegate = self;
}

#pragma mark - MASTAdViewDelegate

- (void)MASTAdViewDidRecieveAd:(MASTAdView*)adView
{
    // Nothing to do if the ad was previously failed with an error below since the
    // ad view will remove it's own internal image view if a text or rich media is
    // or replace the image when a new add is fetched ok.
}

- (void)MASTAdView:(MASTAdView*)adView didFailToReceiveAdWithError:(NSError*)error
{
    // Making use of the image view here...
    
    UIImage* errorImage = [UIImage imageNamed:@"errorImage"];
    
    // The MASTAdView documentation says not to place the container views anywhere that may
    // affect their placement but placing it (while not changing ANY other superview related
    // changes) is fine.
    adView.imageView.image = errorImage;
    [adView addSubview:adView.imageView];
}

@end
