//
//  AdView.h
//  AdMobileSDK
//
//  Created by Constantine Mureev on 2/22/11.
//
//  version: 2.9.0
//

/** Set #define to enable location services code or #undef to disable to exclude location detection from SDK.
 */
#undef INCLUDE_LOCATION_MANAGER


#import <UIKit/UIKit.h>

#ifdef INCLUDE_LOCATION_MANAGER
#import <CoreLocation/CoreLocation.h>
#endif


#import "AdDelegate.h"


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

/** You use the AdView class to embed advertisement content in your application. To do so, you simply create an AdView object and add it to a UIView. An instance of AdView (or simply, an ad) is a means for displaying advertisement information from ad publisher site. To choose ad publisher site set parameters in the ad initialization method initWithFrame:site:zone: or use the properties site and zone. Use the adServerUrl property to choose ad publisher server.
 
 Ad handles the rendering of any content in its area: HTML, Video, Gif animation or JavaScript. Ad also handles any interactions with that content. So you can link from the banner to ad publisher site. Use the internalOpenMode property to set open mode for ad publisher site. To control all intercations implement AdViewDelegate protocol.
 
 Ad always tries to load the content after creation. The time interval between load requests is managed using the property updateTimeInterval. Also you can update ad content immediately  using the update method. Use the isLoading property to find out if ad is in the process of loading.
 
 To configure ad visual appearance use the properties defaultImage, textColor or contentAlignment. To manage the ad animation use the property animateMode.
 
 Advanced ad customization is supported. So you can filter the ad content using the premium property. Use the properties minSize and maxSize to configure ad content size in server response. Also you can set the search parameters or any other parameters using the properties keywords and additionalParameters accordingly. 
 
 To debug ad behavior use the properties testMode and logMode.
 
 Set the delegate property to an object conforming to the AdViewDelegate protocol if you want to listen the processing of ad content.
 */
@interface AdView : UIView {
	BOOL	_observerSet;
	id		_adModel;
}


/** @name Initializing an AdView Object */


/** Initializes and returns an AdView object having the given frame, site and zone.
 
 @param frame A rectangle specifying the initial location and size of the ad view in its superview's coordinates.
 @param site A value that specifies the id of ad publisher site.
 @param zone A value that specifies the id of ad publisher zone.
 
 @return Returns an initialized AdView object or nil if the object could not be successfully initialized.
 */
- (id) initWithFrame:(CGRect)frame
				site:(NSInteger)site
				zone:(NSInteger)zone;


/** @name Configuring the AdView */


/** Id of the publisher site.
 
 Settings the value of this property determines the id of the publisher site, so switching between publisher sites is possible. The default value is copied from parameter site of ad initialization method.
 */
@property (assign) NSInteger			site;

/** Id of the publisher zone.
 
 Settings the value of this property determines the id of the publisher zone, so switching between publisher zones is possible. The default value is copied from parameter zone of ad initialization method.
 */
@property (assign) NSInteger			zone;

/** Publisher server url.
 
 The default value is http://ads.AdMobile.mobi/ad .*/
@property (retain) NSString*			adServerUrl;

/** Image for unloaded ad state.
 
 Settings the value of this property determines ad default image for unloaded state. In this state the content of ad is invisible and ad default image is displayed. Without connection to the internet default image also will be displayed.
 
 The default value is nil.
 */
@property (retain) UIImage*				defaultImage;

/** A Boolean value that determines whether ad animate mode is enabled.
 
 Setting the value of this property to YES enables ad animate mode and setting it to NO disables this mode.
 
 The default value is YES.
 */
@property BOOL							animateMode;

/** Close button.
 
 Set this value to customize close button appearance and behaviour.
 
 By default closed button set by SDK with hidden property YES.
 
 @warning *Note:* If you set set UIButton then you need implement close logic too.
 
 @warning *Note:* If you want simply enable default close button set hidden property to NO.
 */
@property (retain) UIButton*            closeButton;

/** A Boolean value that determines whether content alingment center vertically and horizontally.
 
 Setting the value of this property to YES enables auto warapping server reponse content in HTML table with aligment
 
 The default value is NO.
 
 @warning *Important:*  You need to disable animation if you specify your own.
 */
@property BOOL							contentAlignment;

/** A Boolean value that determines whether ad internal browser is enabled.
 
 Setting the value of this property to NO disables internal browser, so after linking from the banner the ad publisher site will be opened in Safari.
 
 To handle opening/closing internal browser use AdView delegate or viewWillAppear/viewWillDisappear methods of UIViewController.
 
 The default value is NO.
 */
@property BOOL							internalOpenMode;

/** A Boolean value that determines whether ad track is enabled.
 
If set to YES, the ad server will send a client side impression tracking pixel with each ad, regardless of if the campaign has this property set or not. Impressions will not be counting if this pixel does not render on the device.
 
 The default value is NO.
 */
@property BOOL							track;

/** Color of ad text links.
 
 The default value is nil.
 
 @warning *Note:* Alpha value ignored.
 */
@property (retain) UIColor*             textColor;

/** @name Loading the AdView Content */


/** A Boolean value that determines whether ad is in the process of loading. */
@property (readonly) BOOL				isLoading;

/** Update time interval, in seconds.
 
 The value of this property determines time interval between ads updating. This interval is counted after finish loading content, so the ad will start updating only after loading is finished and time interval is passed.
 
 Setting value in range from 0 to 5 will apply 5 seconds to prevent too fast ad updates.
 
 Setting to 0 will stop updates. All positive values enable updates.
 
 The default value is 120.
 */
@property NSTimeInterval				updateTimeInterval;

/** Starts to update the ad content immediately.
 
 Call this method if you want update the ad content immediately (for example, after setting site and zone or changing adServerUrl). If ad is in the process of loading it will be interrupted.
 */
- (void)update;

/** Size of the ad content to be shown.
 
 Use this property to get the actual size of the ad content. Property value updated after ad content downloaded.
 
 @warning *Note:* If size unavailable (Millennial, Greystripe, iVdopia and other 3rd party SDKs) property returns CGRectZero.
 */
@property (readonly) CGSize				contentSize;


/** @name Filtering the AdView Content*/


/** Ad premium filter.

    typedef enum {
        AdPremiumNonPremium = 0,
        AdPremiumPremium,
        AdPremiumBoth,
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
         AdTypeAll = 7,
     } AdType;
 
 Use this property to filter the content of ad by type.
 */
@property AdType                       type;

/** Keywords for search ads.
 
 Use this property to search ads. The values are delimited by commas.
 
 The default value is nil.
 */
@property (retain) NSString*			keywords;

/** Minimal size of the ad content to be shown.
 
 Use this property to set the minimal size of the ad content and server response will be close to this size.
 */
@property CGSize						minSize;

/** Maximal size of the ad content to be shown.
 
 Use this property to set the maximal size of the ad content and server response will be close to this size.
 */
@property CGSize						maxSize;

/** Custom request parameters.
 
 Use this property to add custom request parameters.
 
 The default value is nil.
 
 @warning *Note:* All keys and objects is need to be kind of NSString Class. For example:
    [NSDictionary dictionaryWithObject:@"value" forKey:@"key"]
 */
@property (retain) NSDictionary*        additionalParameters;

/** User location latitude value.
 
 Use this property to set latitude. The value @"" will stop coordinates auto-detection and coordinates  will not be sent to server. Any other values also will stop coordinates auto-detection but coordinates will be sent to server.
 
 The default value is auto-detected by locationManager and sent to server. 
 */

@property (retain) NSString*            latitude;

/** User location longitude value.
 
 Use this property to set longitude. The value @"" will stop coordinates auto-detection and coordinates  will not be sent to server. Any other values also will stop coordinates auto-detection but coordinates will be sent to server.
 
 The default value is auto-detected by locationManager and sent to server.
 */

@property (retain) NSString*            longitude;

/** Country of visitor. It overrides country detected by IP. It is ISO 3166 to be used for specifying country code.
 
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


/** @name Debug the AdView */


/** A Boolean value that determines whether ads test mode is enabled.
 Setting the value of this property to YES enables ads test mode and setting it to NO disables ads test mode.
 
 The default value is NO.*/
@property BOOL							testMode;

/** AdLogMode value that determines log level.
 
     typedef enum {
         AdLogModeNone = 0,
         AdLogModeErrorsOnly = 1,
         AdLogModeAll = 2,
     } AdLogMode;
 
 Setting the value of this property to AdLogModeNone disables ads logging. AdLogModeErrorsOnly - enables logging errors only. AdLogModeAll - enables logging errors and infos.
 
 The default value is AdLogModeErrorsOnly. */
@property AdLogMode                     logMode;


/** @name Setting the Delegate */


/** The receiver's delegate.
 
 The AdView is sent messages when content is processing. The delegate must adopt the AdViewDelegate protocol.
 The delegate is not retained.
 
 @warning *Important:* Before releasing an instance of AdView for which you have set a delegate, you must first set its delegate property to nil. This can be done, for example, in your dealloc method.
 
 @see AdViewDelegate Protocol Reference for the optional methods this delegate may implement.
 */
@property (assign) id <AdViewDelegate>	delegate;

@end
