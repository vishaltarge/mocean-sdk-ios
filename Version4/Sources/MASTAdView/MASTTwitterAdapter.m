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
//  MASTTwitterAdapter.m
//  MASTAdView
//
//  Created  on 10/09/14.

//

#import "MASTTwitterAdapter.h"
#import "MPNativeAdRequest.h"

@implementation MASTTwitterAdapter
@synthesize mopub_nativeAd=_mopub_nativeAd;


- (void)loadAd
{
    NSString *twitter_placementId = [self.adapterDictionary objectForKey:@"adid"];
   MPNativeAdRequest *adRequest1 = [MPNativeAdRequest requestWithAdUnitIdentifier:twitter_placementId];
    
    [adRequest1 startWithCompletionHandler:^(MPNativeAdRequest *request, MPNativeAd *response, NSError *error) {
        if (error) {
            NSLog(@"================> %@", error);
            if ([self.delegate respondsToSelector:@selector(adapterDidFailToFetchAdWithAdapter:withError:)]) {
                
                [self.delegate adapterDidFailToFetchAdWithAdapter:self withError:error];
                
            }
            
        } else {
            
            self.mopub_nativeAd = response;
           
            NSLog(@"Received Twitter Native Ad %@",[response.properties description]);
            
            self.adAttributes = [[MASTNativeAdAttributes alloc] init];
            self.adAttributes.iconImageURL = [response.properties objectForKey:@"iconimage"];
            self.adAttributes.coverImageURL = [response.properties objectForKey:@"mainimage"];
            self.adAttributes.title = [response.properties objectForKey:@"title"];
            self.adAttributes.callToAction = [response.properties objectForKey:@"ctatext"];
            self.adAttributes.adDescription =[response.properties objectForKey:@"text"];
            self.adAttributes.rating = [response.starRating integerValue];
            
            if ([self.delegate respondsToSelector:@selector(adapterDidReceiveAdWithAdapter:)]) {
                
                [self.delegate adapterDidReceiveAdWithAdapter:self];
                
            }

            
            
        }
    
    }];

    
    
    
    
}

- (void) setLogLevel:(PUBAdapterLogMode)logMode
{
}

-(void) sendTracker
{
    [self.mopub_nativeAd trackImpression];
}

-(void) sendClickTracker
{
    [self.mopub_nativeAd trackClick];
}


- (void)destroy
{
   
    _mopub_nativeAd = nil;
    
    
    [super destroy];
    
}

- (void)dealloc
{
    [self destroy];
}


@end
