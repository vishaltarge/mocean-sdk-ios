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
//  MASTFacebookAdapter.m
//  MASTAdView
//
//  Created  on 25/08/14.

//

#import "MASTFacebookAdapter.h"
#import "MASTNativeAdAttributes.h"
#import "MASTNativeAd.h"

@implementation MASTFacebookAdapter
@synthesize fb_nativeAd=_fb_nativeAd;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _fb_nativeAd=nil;
        self.adAttributes = nil;
    }
    return self;
}


- (void)loadAd
{
    NSLog(@"Facebook adapter loaded");
    NSString *fb_placementId = [self.adapterDictionary objectForKey:@"adid"];
    [FBAdSettings addTestDevice:[self.nativeAd testDeviceIdForNetwork:kFaceBook]];
    self.fb_nativeAd = [[FBNativeAd alloc] initWithPlacementID:fb_placementId];
    self.fb_nativeAd.delegate = self;
    [self.fb_nativeAd loadAd];
    
}

- (void) setLogLevel:(MASTAdapterLogMode)logMode
{
}

-(void) trackViewForInteractions:(UIView *)view withViewController:(UIViewController *)viewCotroller
{
    [self.fb_nativeAd  registerViewForInteraction:view withViewController:viewCotroller];
}

-(void) sendClickTracker
{
//    [self.fb_nativeAd ]
}

#pragma mark - FBNativeAdDelegate implementation
- (void)nativeAdDidLoad:(FBNativeAd *)fb_nativeAd
{
    NSLog(@"Facebook Adapter Received Ad sucessfully");
    
    self.adAttributes = [[MASTNativeAdAttributes alloc] init];
    self.adAttributes.iconImageURL = [fb_nativeAd.icon.url description];
    self.adAttributes.coverImageURL = [fb_nativeAd.coverImage.url description];
    self.adAttributes.title = fb_nativeAd.title;
    self.adAttributes.callToAction = fb_nativeAd.callToAction;
    self.adAttributes.adDescription =fb_nativeAd.body;
    self.adAttributes.rating = fb_nativeAd.starRating.value;
    
    if ([self.delegate respondsToSelector:@selector(adapterDidReceiveAdWithAdapter:)]) {
        
        [self.delegate adapterDidReceiveAdWithAdapter:self];
        
    }
    
    }

- (void)nativeAd:(FBNativeAd *)nativeAd didFailWithError:(NSError *)error
{
    NSLog(@" FB Ad failed to load with error: %@", error);
    
    if ([self.delegate respondsToSelector:@selector(adapterDidFailToFetchAdWithAdapter:withError:)]) {
        
        [self.delegate adapterDidFailToFetchAdWithAdapter:self withError:error];
        
    }
}

- (void)nativeAdDidClick:(FBNativeAd *)nativeAd
{
    [self.delegate adapterWithAdClickedWithAdapter:self];

}

- (void)nativeAdDidFinishHandlingClick:(FBNativeAd *)nativeAd
{
}

- (void)destroy
{
    
    [_fb_nativeAd unregisterView];
    _fb_nativeAd = nil;
    
    [super destroy];
}

- (void)dealloc
{
    [self destroy];
}


@end
