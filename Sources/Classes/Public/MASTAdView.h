//
//  MASTAdView.h
//  AdMobileSDK
//
//  Created by Constantine Mureev on 2/22/11.
//
//  version: 2.10.0
//

/** Set #define to enable location services code or #undef to disable to exclude location detection from SDK.
 */

//#undef INCLUDE_LOCATION_MANAGER
#define INCLUDE_LOCATION_MANAGER

#import <UIKit/UIKit.h>

#ifdef INCLUDE_LOCATION_MANAGER
#import <CoreLocation/CoreLocation.h>
#endif

#import "MASTAdDelegate.h"


typedef enum {
	AdPremiumNonPremium = 0,
	AdPremiumPremium,
	AdPremiumBoth,
} AdPremium;

typedef enum {
	AdTypeTextOnly = 1,
	AdTypeImagesOnly = 2,
	AdTypeImagesAndText = 3,
	AdTypeRichmedia = 4,
	AdTypeRichmediaAndText = 5,
	AdTypeRichmediaAndImages = 6,
	AdTypeAll = 7,
} AdType;

typedef enum {
	AdLogModeNone = 0,
	AdLogModeErrorsOnly = 1,
	AdLogModeAll = 2,
} AdLogMode;

/** You use the MASTAdView class to embed advertisement content in your application. To do so, you simply create the MASTAdView object and add it to a UIView. An instance of MASTAdView(or simply, an ad) is a mean for displaying advertisement information from ad publisher site. To choose ad publisher site, set parameters in the ad initialization method initWithFrame:site:zone: or use the properties site and zone. Use the adServerUrl property to choose alternative ad publisher server.
 
 The Ad handles the rendering of any content in its area: Text ads, Images, Richmedia. Ad also handles any interactions with that content. So you can link from the banner to ad publisher site. Use the internalOpenMode property to set open mode for ad publisher site. To control all interactions, implement MASTAdViewDelegate protocol.
 
 Ad always tries to load the content after creation. The time interval between load requests is managed using the property updateTimeInterval. Also you can update ad content immediately using the update method. Use the isLoading property to find out if the ad is in the process of loading or not, or implement callback.
 To configure ad visual appearance use the properties defaultImage, autoCollapse, showPreviousAdOnError, textColor or contentAlignment. To manage the ad animation, use the property isAdChangeAnimated.
 
 Advanced ad customization is supported. So you can filter the ad content using the premium property. Use the properties minSize and maxSize to configure ad content size in server response. Also you can set the search parameters or any other parameters using the properties keywords and additionalParameters accordingly.
 
 To debug ad behavior use the properties testMode and logMode.
 
 Set the delegate property to an object conforming to the MASTAdViewDelegate protocol if you want to listen the processing of ad content.
 
 For the filtration of the content, SDK determines User-Agent automatically.if you  wish to  filter the content as an additional option, watch the section Filtering the MASTAdView Content.
 */

@interface MASTAdView : UIView {
	BOOL	_observerSet;
	id		_adModel;
}


/** @name Initializing an MASTAdView Object */


/** Initializes and returns an MASTAdView object having the given frame, site and zone.
 
 @param frame A rectangle specifies the initial location and size of the ad view in its superview’s coordinates.
 @param site A value that specifies the id of ad publisher site.
 @param zone A value that specifies the id of ad publisher zone.
 
 @return Returns an initialized MASTAdView object or nil if the object could not be successfully initialized.
 */
- (id) initWithFrame:(CGRect)frame
				site:(NSInteger)site
				zone:(NSInteger)zone;

/** @name Configuring the MASTAdView */


/** Id of the publisher site.
 
 Value setting of this property determines the id of the publisher site, so switching between publisher sites is possible. The default value is copied from parameter site of ad initialization method.
 */
@property (assign) NSInteger			site;

/** Id of the publisher zone.
 
 Set the value of this property determines the id of the publisher zone, so switching between publisher zones is possible. The default value is copied from parameter zone of ad initialization method.
 */
@property (assign) NSInteger			zone;

/** Size of the ad content must be shown.
 
 Use this property to get the actual size of the ad content. Property value updated after ad content downloaded.
 
 @warning *Note:* If size unavailable property returns CGRectZero.
 */
@property (readonly) CGSize				contentSize;

/** Image for unloaded ad state.
 
 Set the value of this property, that determines the ad default image for the unloaded state. In this state the content of the ad is invisible and ad default image is displayed. Without connection to the internet default image will be displayed.
 
 The default value is nil.
 */
@property (retain) UIImage*				defaultImage;

/** A Boolean value that determines whether to hide ad in case error depending on other properties
 
 Use this property to hide ad in case of error.
 
 The default value is YES.*/
@property BOOL                          autoCollapse;

/** A Boolean value that determines whether to show previous ad in case of error depending on other properties
 
 Use this property to show previous ad in case of error.
 
 The default value is YES.*/
@property BOOL                          showPreviousAdOnError;

/** Close button.
 
 Set this value to customize close button appearance and behaviour.
 
 By default closed button set by SDK with hidden property YES.
 
 @warning *Note:* If you set UIButton then you need implement close logic too.
 
 @warning *Note:* If you want simply enable default close button set hidden property to NO.
 */
@property (retain) UIButton*            closeButton;

/** Show close button delay time interval, in seconds.
 
 Setting to -1 will show close button immediately.
 
 The default value is -1.
 */
@property NSTimeInterval                showCloseButtonTime;

/** Auto close interstitial time interval, in seconds.
 
 Setting to -1 will disable auto closing interstitial.
 
 The default value is -1.
 */
@property NSTimeInterval                autocloseInterstitialTime;

/** A Boolean value that determines whether ad animate mode is enabled.
 
 Set the value of this property to YES, enable ad animate mode and set it to NO disables this mode.
 
 The default value is NO.
 */
@property BOOL							isAdChangeAnimated;

/** Update time interval, in seconds.
 
 The value of this property determines time interval between ads updating. This interval is counted after finish loading content, so the ad will start updating only after loading is finished and time interval is passed.
 
 Setting value in range from 0 to 5 will apply 5 seconds to prevent too fast ad updates.
 
 Setting to 0 will stop updates. All positive values enable updates.
 
 The default value is 120.
 */
@property NSTimeInterval				updateTimeInterval;

/** Publisher server url.
 
 The default value is http://ads.AdMobile.mobi/ad .*/
@property (retain) NSString*			adServerUrl;

/** Maximum server response time.
 
 Specify timeout of ad call. This tells the ad server the maximum time you are willing to wait for an ad response.
 
 The default value is 1000ms (milleseconds).
 
 The max value is 3000ms (milleseconds).
 */
@property (assign) NSInteger            adCallTimeout;

/** A Boolean value that determines whether content alignment is centered vertically and horizontally.
 
 Set the value of this property to YES, that enables auto wrapping server response content in HTML table with alignment.
 
 The default value is NO.
 
 @warning *Important:*  You need to disable animation if you specify your own.
 */
@property BOOL							contentAlignment;

/** Minimal size of the ad content can be shown.
 
 Use this property to set the minimal size of the ad content and server response will be close to this size.
 */
@property CGSize						minSize;

/** Maximal size of the ad content can be shown.
 
 Use this property to set the maximal size of the ad content and server response will be close to this size.
 */
@property CGSize						maxSize;

/** A Boolean value that determines whether ad track is enabled.
 
 If set to YES, the ad server will send a client side impression tracking pixel with each ad, regardless of if the campaign has this property set or not. Impressions will not be counting if this pixel does not render on the device.
 
 The default value is NO.
 */
@property BOOL							track;

/** A Boolean value that determines whether an ad internal browser is enabled.
 
 Set the value of this property to NO disables internal browser, so after linking from the banner the ad publisher site will be opened in Safari.
 
 To handle opening/closing internal browser use MASTAdView delegate or viewWillAppear/viewWillDisappear methods of UIViewController.
 
 The default value is NO.
 */
@property BOOL							internalOpenMode;

/** Color of ad text links.
 
 The default value is nil.
 
 @warning *Note:* Alpha value ignored.
 */
@property (retain) UIColor*             textColor;

/** @name Loading the MASTAdView Content */

/** A Boolean value that determines whether ad is in the process of loading. */
@property (readonly) BOOL				isLoading;

/** Starts to update the ad content immediately.
 
 Call this method if you want update the ad content immediately (for example, after setting site and zone or changing adServerUrl). If ad is in the process of loading it will be interrupted.
 */
- (void)update;

/**
 Use this method, if you want to close the ad quickly and clear all resource.
 */
- (void)stopEverythingAndNotfiyDelegateOnCleanup;

/** @name Filtering the MASTAdView Content*/


/** Ad premium filter.

    typedef enum {
        AdPremiumNonPremium = 0,
        AdPremiumPremium,
        AdPremiumBoth
    } AdPremium;
 
 Use this property to filter the content of ad by premium status.
 
 The default value is AdPremiumNonPremium.
 */
@property AdPremium                     premium;


/** Ad type filter.
 
     typedef enum {
         AdTypeTextOnly = 1,
         AdTypeImagesOnly = 2,
         AdTypeImagesAndText = 3,
         AdTypeRichmedia = 4,
         AdTypeRichmediaAndText = 5,
         AdTypeRichmediaAndImages = 6,
         AdTypeAll = 7
     } AdType;
 
 Use this property to filter the content of ad by type.
 */
@property AdType                       type;

/** Keywords for search ads.
 
 Use this property to search ads. The values are delimited by commas.
 
 The default value is nil.
 */
@property (retain) NSString*			keywords;

/** Custom request parameters.
 
 Use this property to add custom request parameters.
 
 The default value is nil.
 
 @warning *Note:* All keys and objects is need to be kind of NSString Class. For example:
    [NSDictionary dictionaryWithObject:@"value" forKey:@"key"]
 */
@property (retain) NSDictionary*        additionalParameters;

/** The country of visitor. It overrides country detected by IP. It is ISO 3166 to be used for specifying country code.
 
 The default value is nil.
 */

@property (retain) NSString*            country;

/** Region of visitor. ISO 3166-2 is used for United States and Canada and FIBS 10-4 is used for other countries.
 
 The default value is nil.
 */

@property (retain) NSString*            region;

/** City of the device user (with state). For US only.
 
 The default value is nil.
 */
@property (retain) NSString*            city;

/** Area code of a user. For US only.
 
 The default value is nil.
 */
@property (retain) NSString*            area;

/** Metro code of a user. For US only.
 
 The default value is nil.
 */
@property (retain) NSString*            metro;

/** User location latitude value.
 
 Use this property to set latitude. The value @“” will stop coordinates of auto-detection and coordinates will not be sent to the server. Any other values also will stop the coordinates of auto-detection but coordinates will be sent to the server.
 
 The default value is auto-detected by locationManager and sent to server. 
 */

@property (retain) NSString*            latitude;

/** User location longitude value.
 
 Use this property to set longitude. The value @“” will stop the coordinates of the auto-detection and these coordinates will not be sent to the server. Any other values also will stop the coordinates of auto-detection but these coordinates will be sent to server.
 
 The default value is auto-detected by locationManager and sent to server.
 */

@property (retain) NSString*            longitude;

/** Zip/Postal code of user (note: parameter is all caps). For US only.
 
 The default value is nil.
 */
@property (retain) NSString*            zip;

/** User carrier.
 
 The default value is nil.
 */
@property (retain) NSString*            carrier;


/** @name Install Notification */


/** Id of the advertiser for install notification.
 
 @warning *Note:* Install notification enabled only if advertiserId and groupCode are specified.
 */
@property (assign) NSInteger			advertiserId;

/** Group code for install notification.
 
 @warning *Note:* Install notification enabled only if advertiserId and groupCode are specified.
 */
@property (retain) NSString*			groupCode;


/** @name Debug the MASTAdView */


/** A Boolean value that determines whether ads test mode is enabled.
 Setting the value of this property to YES enables ads test mode and setting it to NO disables ads test mode.
 
 The default value is NO.*/
@property BOOL							testMode;

/** AdLogMode value that determines log level.
 
     typedef enum {
         AdLogModeNone = 0,
         AdLogModeErrorsOnly = 1,
         AdLogModeAll = 2
     } AdLogMode;
 
 Setting the value of this property to AdLogModeNone disables ads logging. AdLogModeErrorsOnly - enables logging errors only. AdLogModeAll - enables logging errors and info.
 
 The default value is AdLogModeErrorsOnly. */
@property AdLogMode                     logMode;

/** @name Setting the Delegate */


/** The receiver's delegate.
 
 The MASTAdView is sent messages when content is processing. The delegate must adopt the MASTAdViewDelegate protocol.
 The delegate is not retained.
 
 @warning *Important:* Before releasing an instance of MASTAdView for which you have set a delegate, you must first set its delegate property to nil. This can be done, for example, in your dealloc method.
 
 @see MASTAdViewDelegate Protocol Reference for the optional methods this delegate may implement.
 */
@property (assign) id <MASTAdViewDelegate>	delegate;

@end
