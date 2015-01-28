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
//  MASTResponseParser.m
//  MASTAdView
//
//  Created by Shrinivas Prabhu on 19/11/14.
//  Copyright (c) 2014 Mocean Mobile. All rights reserved.
//

#import "MASTResponseParser.h"
#import "MASTConstants.h"

@interface MASTResponseParser()

+(MASTNativeAdResponse *) parseDirectNativeAd:(NSDictionary*) responseDictionary;
+(MASTNativeAdResponse *) parseThirdPartyNativeAd:(NSDictionary*) responseDictionary;
+(MASTMediationResponse *) parseDirectMediationAd:(NSDictionary*) responseDictionary;
+(MASTMediationResponse *) parseThirdPartyMediationAd:(NSDictionary*) responseDictionary;
+(MASTErrorResponse *) parseError:(NSDictionary*) responseDictionary;

@end

@implementation MASTResponseParser


+(MASTResponse *) parseNativeAd:(NSDictionary*) responseDictionary
{
    NSArray *ads_array = [responseDictionary objectForKey:MASTNativeAdResponseAdsKey];
    NSDictionary *ad_dictionary = [ads_array objectAtIndex:0];
    
    if ([[ad_dictionary allKeys] containsObject:MASTNativeAdResponseAssetKey]) {
        
        return [self parseDirectNativeAd:ad_dictionary];
    }
    else if ([[ad_dictionary allKeys] containsObject:MASTNativeAdResponseMediationKey])
    {
        return [self parseThirdPartyMediationAd:ad_dictionary];
    }
    else if ([[ad_dictionary allKeys] containsObject:MASTNativeAdResponseErrorKey])
    {
        return [self parseError:ad_dictionary];
    }
    
    // Ideally control should never reach here, will reach here only if response is invalid
    NSLog(@"Invalid response encountered !!!!");
    return  nil;
    
}


+(MASTNativeAdResponse *) parseDirectNativeAd:(NSDictionary*) responseDictionary;
{
    
    
    MASTNativeAdResponse *nativeResponse = [MASTNativeAdResponse new];
    
    nativeResponse.landingPageURL = [NSURL URLWithString:[[responseDictionary objectForKey:MASTNativeAdResponseLinkKey] objectForKey:MASTNativeAdResponseURLKey]];
    nativeResponse.creativeId = [responseDictionary valueForKey:MASTNativeAdResponseAdCreativeIdKey];
    nativeResponse.subtype=[responseDictionary objectForKey:MASTNativeAdResponseAdSubTypeKey];
    nativeResponse.impressionTrackerArray = [responseDictionary objectForKey:MASTNativeAdResponseImpressionTrackerKey];
    
    if ([[[responseDictionary objectForKey:MASTNativeAdResponseLinkKey] allKeys] containsObject:MASTNativeAdResponseClickTrackerKey])
    {
        nativeResponse.clickTrackerArray = [[responseDictionary objectForKey:MASTNativeAdResponseLinkKey] objectForKey:MASTNativeAdResponseClickTrackerKey];
    }
    
    NSArray *assetArray = [responseDictionary objectForKey:MASTNativeAdResponseAssetKey];
    
    for (NSDictionary *asset in assetArray) {
        int assetId=[[asset valueForKey:MASTNativeAdResponseAssetIdKey] intValue];
        
        if(assetId != 0)
        {
            switch (assetId) {
                case kMASTNativeAssetIconImageId:
                    nativeResponse.nativeAd.iconImageURL=[[asset objectForKey:MASTNativeAdResponseEntityKey] objectForKey:MASTNativeAdResponseURLKey];
                    continue;

                case kMASTNativeAssetMainImageId:
                    nativeResponse.nativeAd.coverImageURL=[[asset objectForKey:MASTNativeAdResponseEntityKey] objectForKey:MASTNativeAdResponseURLKey];
                    continue;
                    
                case kMASTNativeAssetLogoImageId:
                    nativeResponse.nativeAd.logoImageURL=[[asset objectForKey:MASTNativeAdResponseEntityKey] objectForKey:MASTNativeAdResponseURLKey];
                    continue;
                    
                case kMASTNativeAssetTitleId:
                    nativeResponse.nativeAd.title=[[asset objectForKey:MASTNativeAdResponseEntityKey] objectForKey:MASTNativeAdResponseTextKey];
                    continue;
                    
                case kMASTNativeAssetDescriptionId:
                    nativeResponse.nativeAd.adDescription=[[asset objectForKey:MASTNativeAdResponseEntityKey] objectForKey:MASTNativeAdResponseValueKey];
                    continue;
                    
                case kMASTNativeAssetRatingId:
                    nativeResponse.nativeAd.rating=[[[asset objectForKey:MASTNativeAdResponseEntityKey] objectForKey:MASTNativeAdResponseValueKey] integerValue];
                    continue;
                    

                default:
                    continue;
            }
        }
        
        
    }
    return nativeResponse;
    
}

+(MASTNativeAdResponse *) parseThirdPartyNativeAd:(NSDictionary*) responseDictionary
{
    return [self parseDirectNativeAd:responseDictionary];
}


+(MASTMediationResponse *) parseThirdPartyMediationAd:(NSDictionary*) responseDictionary
{
    
    MASTMediationResponse *mediationResponse = [MASTMediationResponse new];
    
    mediationResponse.creativeId = [responseDictionary valueForKey:MASTNativeAdResponseAdCreativeIdKey];
    
    // Currently harcoding the value to avoid any conflict between two mediation responses(i.e source= direct and mediation)
    //mediationResponse.subtype=[responseDictionary objectForKey:@"subtype"];
    mediationResponse.subtype=MASTNativeAdResponseMediationKey;
    if ([[[responseDictionary objectForKey:MASTNativeAdResponseMediationKey] allKeys] containsObject:MASTNativeAdResponseAssetIdKey])
    {
        mediationResponse.mediationId = [[responseDictionary objectForKey:MASTNativeAdResponseMediationKey] objectForKey:MASTNativeAdResponseAssetIdKey];
    }

    mediationResponse.impressionTrackerArray = [responseDictionary objectForKey:MASTNativeAdResponseImpressionTrackerKey];
    mediationResponse.clickTrackerArray = [responseDictionary objectForKey:MASTNativeAdResponseClickTrackerKey];
    mediationResponse.mediationFeedName=[[responseDictionary objectForKey:MASTNativeAdResponseMediationKey] objectForKey:MASTNativeAdResponseFeedNameKey];
    mediationResponse.mediationSource=[[responseDictionary objectForKey:MASTNativeAdResponseMediationKey] objectForKey:MASTNativeAdResponseSourceKey];
    mediationResponse.mediationFeedId=[responseDictionary objectForKey:MASTNativeAdResponseFeedIdKey];
    mediationResponse.mediationDataDictionary=[[responseDictionary objectForKey:MASTNativeAdResponseMediationKey] objectForKey:MASTNativeAdResponseFeedDataKey];
    
    return mediationResponse;
}

+(MASTMediationResponse *) parseDirectMediationAd:(NSDictionary*) responseDictionary
{
    return [self parseThirdPartyMediationAd:responseDictionary];
}

+(MASTErrorResponse *) parseError:(NSDictionary*) responseDictionary
{
    MASTErrorResponse *errorResponse = [MASTErrorResponse new];
    
    errorResponse.errorMessage = [responseDictionary objectForKey:MASTNativeAdResponseErrorKey];
    
    return errorResponse;
    
}

@end