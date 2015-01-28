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
//  MASTNativeAd.h
//  MASTAdView
//
//  Created  on 03/07/14.

//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "MASTBaseAdapter.h"
#import "MASTNativeAdDelegate.h"
#import "MASTNativeAdapterDelegate.h"



@interface MASTNativeAd : NSObject

///---------------------------------------------------------------------------------------
/// @name Required configuration
///---------------------------------------------------------------------------------------

/** Specifies the zone for the ad network.
 */
@property (nonatomic, assign) NSInteger zone;


///---------------------------------------------------------------------------------------
/// @name Optional configuration
///---------------------------------------------------------------------------------------

// Set the server and additional parameters as required.
// These are only needed for advanced usages.

/** Specifies the URL of the ad server.
 */
@property (nonatomic, strong) NSString* adServerURL;
@property (nonatomic, strong) NSString *nativeContent;

@property (nonatomic,strong) NSMutableDictionary *nativeAdProperties;

@property(nonatomic,strong,readonly) MASTNativeAdAttributes *adAttributes;
@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSString *adType;
@property (nonatomic, strong, readonly) NSString *adSubType;
@property (nonatomic, strong, readonly) NSString *creativeid;
@property (nonatomic, strong, readonly) NSString *adDescription;
@property (nonatomic, strong, readonly) NSString *callToAction;
@property (nonatomic, strong, readonly) NSString *iconImageURL;
@property (nonatomic, strong, readonly) NSString *coverImageURL;
@property (nonatomic, strong, readonly) NSError *error;
@property (nonatomic, assign, readonly) NSInteger rating;
@property (nonatomic, assign) BOOL useAdapter;

// For third party mediation ads
@property (nonatomic,strong, readonly) NSString* thirdpartyFeedName;
@property (nonatomic, assign,readonly) NSNumber *thirdpartyFeedId;
@property (nonatomic, strong,readonly) NSDictionary *thirdpartyFeedProperties;

@property (nonatomic, strong) id<MASTNativeAdDelegate> delegate;
@property (nonatomic, strong) UIViewController* parentViewController;
@property (nonatomic, strong) UIView* clickableView;

// Use these properties only if you want to override the configuration made in UI
@property (nonatomic,assign) CGSize nativeAdIconSize;
@property (nonatomic,assign) CGSize nativeAdCoverImageSize;
@property (nonatomic,assign) CGFloat nativeAdTitleLength;
@property (nonatomic,assign) CGFloat nativeAdDescriptionLength;
@property (nonatomic,assign) CGFloat nativeAdCTALength;



/** Used to enable or disable location detection.
 
 Enabling location detection makes use of the devices location services to
 set the lat and long server properties that get sent with each ad request.
 
 Note that it could take time to acquire the location so an immediate update
 call after location detection enablement may not include the location in the
 ad network request.
 
 A call to reset will stop location detection.
 
 When enabling location detection with this method the most power efficient
 options are used based on the devices capabilities.  To specify more control
 over location options enable with setLocationDetectionEnabledWithPurpose:...
 
 @param enabled `YES` to enable location detection with defaults, `NO` to disable location detection.
 */
- (void)setLocationDetectionEnabled:(BOOL)enabled;


/** Used to enable location detection with control over how the location is acquired.
 
 @see [CLLocationManager](http://developer.apple.com/library/ios/#documentation/CoreLocation/Reference/CLLocationManager_Class/CLLocationManager/CLLocationManager.html) for reference on the purpose, distanceFilter and desiredAccuracy parameters.
 
 @warning It is possible to configure location detection to use significant power and reduce
 battery life of the device.  For most applications where location detection is desired use
 setLocationDetectionEnabled: for optimal battery life based on the device's capabilities.
 
@param significantUpdating If set to `YES` uses the startMonitoringSignificantLocationChanges
 if available on the device.  If not available then this parameter is ignored.  When available
 and set to `YES` this parameter causes the distanceFilter and desiredAccuracy parameters to
 be ignored.  If set to `NO` then startUpdatingLocation is used and the distanceFilter and
 desiredAccuracy parameters are applied.
 @param distanceFilter Amount of distance used to trigger updates.
 @param desiredAccuracy Acuracy needed for updates.
 */
- (void)setLocationDetectionEnabledWithSignificantUpdating:(BOOL)significantUpdating
                                            distanceFilter:(CLLocationDistance)distanceFilter
                                           desiredAccuracy:(CLLocationAccuracy)desiredAccuracy;

///---------------------------------------------------------------------------------------
/// @name Test content, logging and debugging
///---------------------------------------------------------------------------------------


/** Instructs the ad server to return test ads for the configured zone.
 
 @warning This should never be set to `YES` for application releases.
 */
@property (nonatomic, assign) BOOL test;


-(void) update;
-(void) sendDefaultAdRequest;
-(void) sendTrackerFromView:(UIView *) view;
-(void) sendClickTracker;

-(void)loadCoverImageInView:(UIImageView *)imageView;
-(void)loadIconImageInView:(UIImageView *)imageView;



@end

