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

typedef enum {
    kFaceBook,
    kMoPub,
    kNone
} MediationNetwork;

//
// The enum denotes the Log levels for Adapters.
// The log level set to the bannerView will also be set to adapters, if the
// particular SDK supports log levels.
//
typedef enum {
    MASTLogNone = -1,
    MASTLogDebug=0,
    MASTLogInfo=1,
    MASTLogWarn=2,
    MASTLogError=3
} MASTLogMode;



static NSString* MAST_NATIVE_TEST_DEVICE_ID_KEY __attribute__((unused)) = @"%@_testDeviceIdKey";
typedef void (^CompletionHandler)();

/*!
 @class MASTNativeAd
 
 @abstract
 The MASTNativeAd represents ad metadata to allow you to construct custom ad views.
 */
@interface MASTNativeAd : NSObject


//setters
///---------------------------------------------------------------------------------------
/// @name Required configuration
///---------------------------------------------------------------------------------------

/** Specifies the zone for the ad network.
 */
@property (nonatomic, assign) NSInteger zone;



/** Specifies the URL of the ad server.
 */
@property (nonatomic, strong) NSString* adServerURL;

///---------------------------------------------------------------------------------------
/// @name Function for AdRetrival and tracking impression
///---------------------------------------------------------------------------------------

/*
 @method -update
 @discussion - Issues an update request to fetch new ads.
 */
-(void) update;

/*
 @method -handleAdNetworkDefault
 @discussion - Method is  to be called by publisher if any mediation network defaults ,
 to make a fresh adRequest and notify server of defaulting
 */
-(void) handleAdNetworkDefault;

/*
 @method -trackViewForInteractions:withViewController
 @param -
 view - Native Ad View where all native ad components are rendered
 viewController - Viewcontroller on which native ad is placed
 @discussion - Method to be called once native ad is sucessfully rendered for sending sucess metric url 
                and hence handling user clicks
 */
-(void)trackViewForInteractions:(UIView*)view withViewController:(UIViewController* )viewController;

/*
 @method -loadInImageView:withURL
 @param -
 imageView - Image View where image is to be rendered
 urlString - URL of image which is to be rendered
 @discussion - Method will asyncronously download and hence render image in imageView. 
                This method can be used for rendering icon and cover image
 */
-(void) loadInImageView:(UIImageView *)imageView withURL:(NSString *) urlString;

/*
 @method - destroy
 @discussion - Method will be used to destroy instance of native ad and hence free resources.
                This method is to be called only when native ad is supposed to be deallocated.
 */
-(void) destroy;


/*
 @method - setLogLevel:
 @param -
 logMode - log mode to be set as per enum MASTLogMode
 @discussion - Method will be used to set log level for Native Ad
 */
+(void) setLogLevel:(MASTLogMode)logMode;

/*
 @method - sendImpressionTrackers
 @discussion - Method will be used to send impression tracker metrics url. This is actually done automatically when trackViewForInteractions:withViewController method is called. This method will be used only when adapters are 
     not used and publisher wants to himself implement third party mediation */
-(void) sendImpressionTrackers;

/*
 @method - sendClickTracker
 @discussion - Method will be used to send click tracker metrics url. This is actually done automatically when trackViewForInteractions:withViewController method is called. This method will be used only when adapters are 
     not used and publisher wants to himself implement third party mediation */
-(void) sendClickTracker;

/*!
 @property
 @abstract Typed access to the id of the ad placement.
 */
@property (nonatomic, strong) NSString *nativeContent;


/*!
 @property
 @abstract Native ad request parameters
 */
@property (nonatomic,strong) __block NSMutableDictionary *adRequestParameters;

/*!
 @property
 @abstract Native ad response parameters
 */
@property(nonatomic,strong) NSDictionary *nativeAdResponseDictionary;

/*!
 @property
 @abstract the delegate
 */
@property (nonatomic, assign) id<MASTNativeAdDelegate> delegate;

// Use these properties only if you want to override the configuration made in UI
@property (nonatomic,assign) CGSize nativeAdIconSize;
@property (nonatomic,assign) CGSize nativeAdCoverImageSize;
@property (nonatomic,assign) CGSize nativeAdLogoImageSize;
@property (nonatomic,assign) CGFloat nativeAdTitleLength;
@property (nonatomic,assign) CGFloat nativeAdDescriptionLength;
@property (nonatomic,assign) CGFloat nativeAdCTALength;


///---------------------------------------------------------------------------------------
/// @name Response params , readonly params from response
///---------------------------------------------------------------------------------------

//getters
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

///---------------------------------------------------------------------------------------
/// @name Methods for using internal mediation
///---------------------------------------------------------------------------------------

/*!
 @property
 @abstract If 'YES' Internal mediation adapters are used to handle third party ad requests.
 */
@property (nonatomic, assign) BOOL useAdapter;

// For third party mediation ads
/*!
 @property
 @abstract third party feed name if mediation is used
 */
@property (nonatomic,strong, readonly) NSString* thirdpartyFeedName;

/*!
 @property
 @abstract third party feed id if mediation is used
 */
@property (nonatomic, assign,readonly) NSNumber *thirdpartyFeedId;

/*!
 @property
 @abstract third party feed properties if mediation is used
 */
@property (nonatomic, strong,readonly) NSDictionary *thirdpartyFeedProperties;

/*
 @method -initWithAdServer:andZone:
 @param -
 adServerUrl - Adserver url where request is to be made
 aZone - Zone id of ad placement
 @discussion - It initialises instance of nativeAd with adServer URL and zone.
 */
-(instancetype)initWithAdServer:(NSString *)adServerUrl andZone:(NSInteger )aZone;


///---------------------------------------------------------------------------------------
/// @name Enabling automatic retrival of location
///---------------------------------------------------------------------------------------



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

/*
 @method -addTestDeviceId:forNetwork
 @param -
 testDeviceId - Test device id for given Mediation  network
 network - Mediation network {kFaceBook,kMoPub}
 @discussion - It adds test device ad for respective Mediation networks which is passed to respective mediation networks if such networks wins
 */
-(void) addTestDeviceId:(NSString *)testDeviceId forNetwork:(MediationNetwork)network;

/*
 @method -removeTestDeviceIdForNetwork:
 @param -
 network - Mediation network {kFaceBook,kMoPub}
 @discussion - It removes test device ad for respective Mediation networks  */
-(void) removeTestDeviceIdForNetwork:(MediationNetwork)network;


/*
 @method -testDeviceIdForNetwork:
 @param -
 network - Mediation network {kFaceBook,kMoPub}
 @discussion - It returns test device ad for respective Mediation networks
 */
-(NSString *) testDeviceIdForNetwork:(MediationNetwork)network;


@end

