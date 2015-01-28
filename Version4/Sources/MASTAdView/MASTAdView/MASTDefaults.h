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
//  MASTDefaults.h
//  MASTAdView
//

//

#ifndef MASTAdView_MASTDefaults_h
#define MASTAdView_MASTDefaults_h

// Note: __attribute__((unused)) suppresses unused warnings since the
// compiler doesn't actually find the usages elsewhere.


//
// Should only be changed by Mocean development team releasing source.
//
static NSString* MAST_DEFAULT_VERSION __attribute__((unused)) = @"3.3";


//
// The default ad server URL.
//
static NSString* MAST_DEFAULT_AD_SERVER_URL __attribute__((unused)) = @"http://ads.mocean.mobi/ad";


//
// Timeout for various network requests.
//
static NSTimeInterval MAST_DEFAULT_NETWORK_TIMEOUT __attribute__((unused)) = 5;


//
// How much content is allowed after parsing out click url and image
// or text content before falling through and rendering as html vs.
// native rendering.
//
static NSTimeInterval MAST_DESCRIPTOR_THIRD_PARTY_VALIDATOR_LENGTH __attribute__((unused)) = 20;

//
// The default native adtype
//
static NSString* MAST_DEFAULT_NATIVE_AD_TYPE __attribute__((unused)) = @"8";


//
// The default native ad key
//
static NSString* MAST_DEFAULT_NATIVE_AD_KEY __attribute__((unused)) = @"8";


//
// Default adcount to be requested from SDK is 0
//
static NSString* MAST_DEFAULT_NATIVE_AD_COUNT __attribute__((unused)) = @"0";


//
// Default injection HTML for rich media ads.
//
// IMPORTANT:
//  This string is a format specifier and uses %@ for parameters.
//  The first parameter represens the ad content.
//  DO NOT change the order or inclusion of these parameters.
//
static NSString* MAST_RICHMEDIA_FORMAT __attribute__((unused)) = @"<html><head><meta name=\"viewport\" content=\"user-scalable=0;\"/><style>*:not(input){-webkit-touch-callout:none;-webkit-user-select:none;-webkit-text-size-adjust:none;}body{margin:0;padding:0;}</style></head><body>%@</body></html>";


#endif
