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
//  MASTNativeAdDelegate.h
//  MASTAdView
//
//  Created  on 31/07/14.

//

#import <Foundation/Foundation.h>

@class MASTNativeAd;

@protocol MASTNativeAdDelegate <NSObject>

@optional
/** Sent after an ad has been downloaded and rendered.
 
 @param nativeAd The MASTNativeAd instance sending the message.
 */
- (void)MASTAdViewDidRecieveAd:(MASTNativeAd *)nativeAd;


/** Sent if an error was encountered while downloading or rendering an ad.
 
 @param nativeAd The MASTNativeAd instance sending the message.
 @param error The error encountered while attempting to receive or render the ad.
 */
- (void)MASTAdView:(MASTNativeAd*)nativeAd didFailToReceiveAdWithError:(NSError*)error;

/** Sent when the ad server receives a third party ad request from the ad network.
 
 This can be implemented to invoke a third party ad SDK to render the requested content.  The nativeAd
 does no further processing of the third party request.
 
 @param nativeAd The MASTNativeAd instance sending the message.
 @param properties Properties of the request.
 @param params Params for the third party SDK.
 */
- (void)MASTAdView:(MASTNativeAd*)nativeAd didReceiveThirdPartyRequest:(NSDictionary*)properties withParams:(NSDictionary*)params;

/*!
 @method
 
 @abstract
 Sent after an ad has been clicked by the person.
 
 @param nativeAd An MASTNativeAd object sending the message.
 */
- (void)nativeAdDidClick:(MASTNativeAd *)nativeAd;


@end



