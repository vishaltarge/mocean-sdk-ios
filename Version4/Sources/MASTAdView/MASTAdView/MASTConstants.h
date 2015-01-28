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
//  MASTConstants.h
//  MASTAdView
//

//

#ifndef MASTAdView_MASTConstants_h
#define MASTAdView_MASTConstants_h


static NSString* MASTUserAgentHeader = @"User-Agent";

#endif

#ifndef MASTNativeAdView_MASTConstants_h
#define MASTNativeAdView_MASTConstants_h


static NSString* MASTNativeUserAgentHeader = @"User-Agent";
static NSString* MASTNativeAdTypeKey = @"type";
static NSString* MASTNativeAdKey_key = @"key";
static NSString* MASTNativeAdCountKey = @"count";
static NSString* MASTNativeSDKVersionKey = @"version";


static NSString* MASTNativeAdRequestMCCKey = @"mcc";
static NSString* MASTNativeAdRequestMNCKey = @"mnc";
static NSString* MASTNativeAdRequestNativeContentKey = @"native_content";
static NSString* MASTNativeAdRequestIconSizeX_Key = @"icon_size_x";
static NSString* MASTNativeAdRequestIconSizeY_Key = @"icon_size_y";
static NSString* MASTNativeAdRequestImageSizeX_Key = @"img_size_x";
static NSString* MASTNativeAdRequestImageSizeY_Key = @"img_size_y";
static NSString* MASTNativeAdRequestLogoSizeX_Key = @"logo_size_x";
static NSString* MASTNativeAdRequestLogoSizeY_Key = @"logo_size_y";
static NSString* MASTNativeAdRequestImageRatioKey = @"img_ratio";

static NSString* MASTNativeAdRequestCTALengthKey = @"cta_length";
static NSString* MASTNativeAdRequestDescriptionKey = @"description_length";
static NSString* MASTNativeAdRequestTitleKey = @"title_length";
static NSString* MASTNativeAdRequestTestKey = @"test";

static NSString* MASTNativeAdResponseAdSubTypeThirdPartyKey = @"mediation";
static NSString* MASTNativeAdResponseAdSubTypeNativeKey = @"native";
static NSString* MASTNativeAdRequestDirectDefaultKey = @"excreatives";
static NSString* MASTNativeAdRequestMediationDefaultNetworkIDKey = @"pubmatic_exfeeds";





static NSString* MASTNativeAdResponseAdsKey = @"ads";
static NSString* MASTNativeAdResponseAdTypeKey = @"type";
static NSString* MASTNativeAdResponseAdSubTypeKey = @"subtype";
static NSString* MASTNativeAdResponseAdCreativeIdKey = @"creativeid";
static NSString* MASTNativeAdResponseTitleKey = @"title";
static NSString* MASTNativeAdResponseDescriptionKey = @"desc";
static NSString* MASTNativeAdResponseIconImageKey = @"icon";
static NSString* MASTNativeAdResponseMainImageKey = @"img";
static NSString* MASTNativeAdResponseErrorKey = @"error";
static NSString* MASTNativeAdResponseAssetKey = @"assets";
static NSString* MASTNativeAdResponseAssetIdKey = @"id";
static NSString* MASTNativeAdResponseEntityKey = @"entity";
static NSString* MASTNativeAdResponseValueKey =@"value";
static NSString* MASTNativeAdResponseLinkKey =@"link";


static NSString* MASTNativeAdResponseURLKey = @"url";
static NSString* MASTNativeAdResponseLandingPageURLKey = @"clk";
static NSString* MASTNativeAdResponseCTAKey= @"cta";
static NSString* MASTNativeAdResponseTextKey = @"text";
static NSString* MASTNativeAdResponseRatingKey = @"rating";
static NSString* MASTNativeAdResponseMediationKey = @"mediation";
static NSString* MASTNativeAdResponseDirectKey = @"direct";
static NSString* MASTNativeAdResponseSourceKey = @"source";

static NSString* MASTNativeAdResponseFeedIdKey = @"feedid";
static NSString* MASTNativeAdResponseFeedNameKey = @"name";
static NSString* MASTNativeAdResponseFeedKey = @"mediation";
static NSString* MASTNativeAdResponseFeedDataKey= @"data";

static NSString* MASTNativeAdResponseImpressionTrackerKey = @"impressiontrackers";
static NSString* MASTNativeAdResponseClickTrackerKey = @"clicktrackers";

static NSString* MASTNativeAdFacebookAdapterClassName = @"MASTFacebookAdapter";
static NSString* MASTNativeAdMoPubAdapterClassName = @"MASTMoPubAdapter";
static NSString* MASTNativeAdResponseFacebookAdKey = @"FAN";
static NSString* MASTNativeAdResponseMoPubAdKey = @"MoPub";
static NSString* MASTNativeAdClickTrackingURLBackGroundQueue =@"operationCount";
static NSString* MASTNativeAdFacebookMediation =@"FaceBook";
static NSString* MASTNativeAdMoPubMediation =@"MoPub";

#endif

