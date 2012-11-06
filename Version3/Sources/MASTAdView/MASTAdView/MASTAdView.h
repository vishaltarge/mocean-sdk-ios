//
//  MASTAdView
//
//  Created on 9/21/12.
//  Copyright (c) 2011, 2012 Mocean Mobile. All rights reserved.
//
//
//
// This is the only header required for integrating into projects that will use the MASTAdView SDK.
//
//

/// *Required Frameworks*
///
/// These must be added to projects (via project's link build phase) that use the MASTAdView SDK.
///
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
#import <MessageUI/MessageUI.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <ImageIO/ImageIO.h>


// This header is provided for support and debugging of locally generated ads.
#import "MASTMoceanAdDescriptor.h"


@class MASTAdView;


/** Ad placement type.
 */
typedef enum
{
    /// Ad is placed in application content.
    MASTAdViewPlacementTypeInline = 0, 
    
    /// Ad is placed over and in the way of application content.
    /// Generally used to place an ad between transtions in an application
    /// and consumes the entire screen.
    MASTAdViewPlacementTypeInterstitial
    
} MASTAdViewPlacementType;


/** Event log types.
 */
typedef enum
{
    MASTAdViewLogEventTypeError = 0,
    MASTAdViewLogEventTypeDebug = 1
} MASTAdViewLogEventType;


/** Protocal for interaction with the MASTAdView.
 
 The entire protocol is optional.  Some messages override default behavior and some are required
 to get full support for MRAID 2 ad content (saving calendar entries or pictures).
 
 All messages are guaranteed to occur on the main thread.  If any long running tasks are needed
 in reponse to any of the sent messages then they should be executed in a background thread to
 prevent and UI delays for the user.
 */
@protocol MASTAdViewDelegate <NSObject>
@optional

/** Sent after an ad has been downloaded and rendered.
 */
- (void)MASTAdViewDidRecieveAd:(MASTAdView*)adView;


/** Sent if an error was encoutered while donloading or rendering an ad.
 */
- (void)MASTAdView:(MASTAdView*)adView didFailToReceiveAdWithError:(NSError*)error;


/** Sent when the ad will navigate to a clicked link.
 
 Not implementing this method behaves as if `YES` was returned.
 
 @return `YES` Allow the SDK to open the link with UIApplication's openURL: or the internal browser.
 @return `NO` Ignore the request
 */
- (BOOL)MASTAdView:(MASTAdView*)adView shouldOpenURL:(NSURL*)url;


/** Sent when the close button is pressed by the user.
 
 This only occurs for the close button enabled with setCloseButton:afterDelay: or in the case of a
 interstitial richmedia ad that closes itself.  It will not be sent for richmedia close buttons that 
 collapse expanded or resized ads.
 
 The common use case is for interstitial ads so the developer will know when to call closeInterstitial.
 */
- (void)MASTAdViewCloseButtonPressed:(MASTAdView*)adView;


/** Implement to return a custom close button.  
 
 This button will be used for richmedia ads if the richmedia ad does not indicate it has its own
 custom close button.  It is also used if showCloseButton:afterDelay: enables the close button.

 @warning Do not return the same UIButton instance to different adView instances.
 
 @warning Developers should take care of adding action handlers to the button as it will 
 be reused and may persist beyond the handlers lifetime.
 
 @return UIButton instance.
 */
- (UIButton*)MASTAdViewCustomCloseButton:(MASTAdView*)adView;


/** Sent before the ad content is expanded in response to a richmedia expand event.
 
 The ad view itself is not expanded, instead a new window is displayed with the
 expanded ad content.
 */
- (void)MASTAdViewWillExpand:(MASTAdView*)adView;


/** Sent after the ad content is expanded in response to a richmedia expand event.
 
 The ad view itself is not expanded, instead a new window is displayed with the
 expanded ad content.
 */
- (void)MASTAdViewDidExpand:(MASTAdView*)adView;


/** Sent before the ad content is resized in response to a richmedia resize event.
 
 The ad view itself is not resized, instead a new window is displayed with the
 resized ad content.
 
  @param frame The frame relative to the window where the resized content is displayed.
 */
- (void)MASTAdView:(MASTAdView *)adView willResizeToFrame:(CGRect)frame;


/** Sent after the ad content is resized in response to a richmedia resize event.
 
 The ad view itself is not resized, instead a new window is displayed with the
 resized ad content.
 
 @param frame The frame relative to the window where the resized content is displayed.
 */
- (void)MASTAdView:(MASTAdView *)adView didResizeToFrame:(CGRect)frame;


/** Sent before ad content is collaped if expanded or resized.
 */
- (void)MASTAdViewWillCollapse:(MASTAdView*)adView;


/** Sent after ad content is collaped if expanded or resized.
 */
- (void)MASTAdViewDidCollapse:(MASTAdView*)adView;


/** Sent before the ad opens a URL that invokes another application (ex: Safari or App Store).
 */
- (void)MASTAdViewWillLeaveApplication:(MASTAdView*)adView;


/** Sent when the ad view is about to log an event.
 
 Logging in the SDK is done with NSLog().  Implement and return `NO` to log to application specific
 log files.
 
 @param event The log event to log.
 @param type The event type.
 @return `YES` Log the event to NSLog().
 @return `NO` Omit logging the event to NSLog().
 */
- (BOOL)MASTAdView:(MASTAdView*)adView shouldLogEvent:(NSString*)event ofType:(MASTAdViewLogEventType)type;


/** Sent to allow developers to override SMS support.
 
 If the device supports SMS this message will be sent to allow the developer to override support.
 The default behavior is to allow SMS usage.
 
 This message is not sent of the device does not support SMS.
 
 @return `NO` Informs richmedia ads that SMS is not supported.
 @return `YES` Informs richmedia ads that SMS is supported.
 */
- (BOOL)MASTAdViewSupportsSMS:(MASTAdView*)adView;


/** Sent to allow developers to override phone support.
 
 If the device supports phone dialling this message will be sent to allow the developer to override support.
 The default behavior is to allow phone dialing.
 
 This message is not sent of the device does not support phone dialing.
 
 @return `NO` Informs richmedia ads that phone calls is not supported.
 @return `YES` Informs richmedia ads that phone calls is supported.
 */
- (BOOL)MASTAdViewSupportsPhone:(MASTAdView*)adView;


/** Sent to allow developers to override calendar support.
 
 Implement to indicate if calendar events can be created.
 The default behavior is to NOT allow calendar access.
 
 @see MASTAdView:shouldSaveCalendarEvent:inEventStore:
 
 @return `NO` Informs richmedia ads that calendar access is not supported.
 @return `YES` Informs richmedia ads that calendar access is supported.
 */
- (BOOL)MASTAdViewSupportsCalendar:(MASTAdView*)adView;


/** Sent to allow developers to override picture storing support.
 
 Implement to indicate if storing pictures is supported. The default behavior is to NOT allow storing
 of pictures.
 
 @see MASTAdView:shouldSavePhotoToCameraRoll:
 
 @return `NO` Informs richmedia ads that storing pictures is not supported.
 @return `YES` Informs richmedia ads that storing pictures is supported.
 */
- (BOOL)MASTAdViewSupportsStorePicture:(MASTAdView*)adView;


/** Sent when the ad server receives a third party ad request from the ad network.
 
 This can be implemented to invoke a third party ad SDK to render the requested content.  The adView 
 does no further processing of the third party request.
 
 @param properties Properties of the request.
 @param params Params for the third party SDK.
 */
- (void)MASTAdView:(MASTAdView*)adView didReceiveThirdPartyRequest:(NSDictionary*)properties withParams:(NSDictionary*)params;


/** Sent when an ad desires to play a video in an external player.
 
 The default is to open the URL and play the video.
 
 Developers can use an application player and return NO to play the video directly.
 
 @return `NO` Do not open the URL and play the video.
 @return `YES` Invoke UIApplication openURL: to play the video.
 */
- (BOOL)MASTAdView:(MASTAdView*)adView shouldPlayVideo:(NSString*)videoURL;


/** Sent when a richmedia ad attempts to create a new calendar entry.
 
 Application developers can implement the dialog directly if desired by capturing the event
 and eventStore and returning `nil`.  If not implemented the SDK will ignore the request.
 
 @return A view controller instance that will be the base of presenting the event edit view
 controller to allow the user to edit and save or cancel the calendar event.
 */
- (UIViewController*)MASTAdView:(MASTAdView*)adView shouldSaveCalendarEvent:(EKEvent*)event inEventStore:(EKEventStore*)eventStore;


/** Sent when a richmedia ad attempts to save a picture to the camera roll.
 
 Application developers should implement this by prompting the user to save the image and then saving
 it directly and returning NO from this delegate method.  If not implemented the image will NOT be
 saved to the camera roll.
 
 Note: iOS 6 added privacy options for applications saving to the camera roll.  The user will be
 prompted by iOS on the first attempt at accessing the camera roll.  If the user selects No then
 pictures will not be saved to the camera roll even if this method is implemented and returns `YES`.
 
 @return `NO` Do not save the image to the camera roll.
 @return `YES` Attempt to save the image to the camera roll.
 */
- (BOOL)MASTAdView:(MASTAdView*)adView shouldSavePhotoToCameraRoll:(UIImage*)image;


/** Sent after the SDK process a richmedia event.
 
 Applications can use this to react to various events if necessary but the SDK will have
 already processed them as necessary (expanded in result of an expand request).
 
 @warning *Note:* Developers should not attempt to implement the specified event.  The SDK will
 have already processed the event with the SDK implementation.
 
 See the IAB MRAID 2 specification on the event types.
 */
- (void)MASTAdView:(MASTAdView *)adView didProcessRichmediaRequest:(NSURLRequest*)event;

@end


/** Renders text, image and richmedia ads.
 */
@interface MASTAdView : UIView


 /** Returns the MASTAdView SDK's version.
 */
+ (NSString*)version;


///---------------------------------------------------------------------------------------
/// @name Initialization
///---------------------------------------------------------------------------------------

/** Initilizes an inline instance of the ad view.
 
 The view can be added to other views as with any other UIView object.  The frame is
 used to determine the size of the ad in the requested to the ad server.  If not known
 at initialization time, ensure that the view's frame is set prior to calling update.
 */
- (id)initWithFrame:(CGRect)frame;


/** Initializes an interstital instance of the ad view.
 
 The view is NOT intended to be used inline with other content or added to
 other views.  Instead use the interstitial methods to show and close the
 full screen view.
 
 @see showInterstitial
 @see showInterstitialWithDuration:
 @see closeInterstitial
 */
- (id)initInterstitial;


/** Returns the placement type for the instance.
 
 This is set based on how the instance was initialized.
 
 @see initWithFrame:
 @see initInterstitial
 */
@property (nonatomic, readonly) MASTAdViewPlacementType placementType;


///---------------------------------------------------------------------------------------
/// @name Required configuration
///---------------------------------------------------------------------------------------

/** Specifies the site for the ad network.
 */
@property (nonatomic, copy) NSString* site;

/** Specifies the zone for the ad network.
 */
@property (nonatomic, copy) NSString* zone;


///---------------------------------------------------------------------------------------
/// @name Optional configuration
///---------------------------------------------------------------------------------------

// Set the server and additional parameters as required.
// These are only needed for advanced usages.

/** Specifies the URL of the ad server.
 */
@property (nonatomic, copy) NSString* adServerURL;


/** Allows setting extra server parameters.
 
 The SDK will set various parameters based on configuration and other options.
 
 For more information see http://developer.moceanmobile.com/Mocean_Ad_Request_API.
 
 @warning *Note:* All parameter key and values must be NSString instances.
 */
@property (nonatomic, readonly) NSMutableDictionary* adRequestParameters;


/** Set to enable the use of the internal browser for opening ad content.  Defaults to `NO`.
 */
@property (nonatomic, assign) BOOL useInternalBrowser;


/** Sets the MASTAdViewDelegate delegate receiever for the ad view.
 
 @warning Proper reference management practices should be observed when using delegates.
 @warning Ensure that the delegate is set to nil prior to releasing the ad view's instance.
 */
@property (nonatomic, assign) id<MASTAdViewDelegate> delegate;


///---------------------------------------------------------------------------------------
/// @name Updating and resetting ad content
///---------------------------------------------------------------------------------------

/** Issues an immediate ad update and cancles any existing ad update.
 */
- (void)update;


/** Issues an immediate ad update and cancels any pending ad update.
 Will automatically update every interval seconds.
 */
- (void)updateWithTimeInterval:(NSTimeInterval)interval;


/** Restates the instance to its default state.
 
 -Stops updates and cancels the update interval.
 -Stops location detection.
 -Collapses any expanded or resized richmedia ads.
 -Closes interstitial.
 -Closes internal ad browser.
 
 Should be sent before releasing the instance if another object may be retaining it 
 such as a superview or list.  This allows the application to suspend ad updating 
 and interaction activities to allow other application activitis to occur.  After
 responding to other activities update or updateWithTimeInterval: can be sent again
 to resume ad updates.
 
 @warning Does not reset the delegate.
 */
- (void)reset;


///---------------------------------------------------------------------------------------
/// @name Controlling interstitial presentation
///---------------------------------------------------------------------------------------

/** Shows and closes the interstitial view.

 Can only be used if the instance was initialized with initInterstitial.
 */
- (void)showInterstitial;


/** Shows the interstitial and automatically closes after the specified duration.
 
 Can only be used if the instance was initialized with initInterstitial.
 */
- (void)showInterstitialWithDuration:(NSTimeInterval)duration;


/** Closes the interstitial.
 
 */
- (void)closeInterstitial;


///---------------------------------------------------------------------------------------
/// @name Close button support
///---------------------------------------------------------------------------------------

/** Shows a close button after the specified delay after the ad is rendered.
 
 This can be used for both inline/banner/custom and interstitial ads.  For most cases
 this should not be required since banner ads don't usually have a need for a close 
 button and richmedia ads that expand or resize will offer their own close button.
 
 This SHOULD be used for interstitial ads that are known to not be richmedia as they
 will not have a built in close button.
 
 The setting applies for all subsequent updates.  The button can be customized using the 
 MASTAdViewCustomCloseButton: delegate method.
 
 @parameter showCloseButton Set to `YES` to display the close button after rendering ads.
 @parameter afterDelay The time to delay showing the close button after rendering the ad.  A
 value of 0 will show the button immediately.
 */
- (void)showCloseButton:(BOOL)showCloseButton afterDelay:(NSTimeInterval)delay;


///---------------------------------------------------------------------------------------
/// @name Location detection support
///---------------------------------------------------------------------------------------

/** Returns the enablement status of location detection.
 
 May return `NO` even if one of the setLocationDetectionEnabled methods was used
 to enable it.  This can happen if the device doesn't support location enablement
 or if the user has denied location permissions to the application.  Note however
 that this property should not be used to determine either of those cases for the
 application.
 */
@property (nonatomic, readonly) BOOL locationDetectionEnabled;


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
 */
- (void)setLocationDetectionEnabled:(BOOL)enabled;


/** Used to enable location detection with control on over how the location is determined.

 @param significantUpdating If set to `YES` uses the startMonitoringSignificantLocationChanges 
 if available on the device.  If not available then this parameter is ignored.  When available
 and set to `YES` this parameter causes the distanceFilter and desiredAccuracy parameters to 
 be ignored.  If set to `NO` then startUpdatingLocation is used and the distanceFilter and 
 desiredAccuracy parameters are applied.
 
 A call to reset will stop location detection.
 
 @see CLLocationManager for reference on the purpose, distanceFilter and desiredAccuracy parameters.
 
 @warning It is possible to configure location detection to use significant power and reduce
 battery life of the device.  For most applications where location detection is desired use 
 setLocationDetectionEnabled: for optimal battery life based on the devices capabilities.
 */
- (void)setLocationDetectionEnabledWithPupose:(NSString*)purpose
                          significantUpdating:(BOOL)significantUpdating
                               distanceFilter:(CLLocationDistance)distanceFilter
                              desiredAccuracy:(CLLocationAccuracy)desiredAccuracy;


///---------------------------------------------------------------------------------------
/// @name Ad containers
///---------------------------------------------------------------------------------------

// These are available to customize text and image ad appearance
// if desired.  Do not change properties that would affect placement
// or behavior in their superview (the ad view).

/** Text ad container.
 
 This can be accessed to modify how text is rendered such as font size, color, background color, etc...
 
 @warning Do not attempt to move or affect the relationship of the view within its superview.
 */
@property (nonatomic, readonly) UILabel* labelView;

/** Image ad container.
 
 This can be accessed to modify how the image is handled.
 
 @warning Do not attempt to move or affect the relationship of the view within its superview.
 */
@property (nonatomic, readonly) UIImageView* imageView;

/** Richmedia expand view container.
 
 This view is the container used to hold the view to be expanded.  For richmedia ads that request
 an expand this will contain the UIWebView.  This doesn't include richmedia ads that expand with
 another creative (two part expand).
 
 @warning Do not attempt to move or affect the relationship of the view within its superview.
 */
@property (nonatomic, readonly) UIView* expandView;

/** Richmedia resize view container.
 
 This view is the container used to render resized richmedia ad it requests to resize.
 
 @warning Do not attempt to move or affect the relationship of the view within its superview.
 */
@property (nonatomic, readonly) UIView* resizeView;


///---------------------------------------------------------------------------------------
/// @name Test content, logging and debugging
///---------------------------------------------------------------------------------------


/** Instructs the ad server to return test ads for the configured site/zone.
 
 @warning *Note:* This should never be set to `YES` for application releases.
 */
@property (nonatomic, assign) BOOL test;


/** Specifies the log level.  All logging is via NSLog().
 
 @see MASTAdView:shouldLogEvent:ofType:
 */
@property (nonatomic, assign) MASTAdViewLogEventType logLevel;


/** Renders an ad directly without downloading it from the ad network.
 
 An update in progress due to update or updateWithTimeInterval: will override any
 ad set with this method.  Call reset prior to calling this if update was used
 to download an ad from the ad network.
 
 @warning *Note:*: This not intended to be used in application releases.
 */
- (void)renderWithAdDescriptor:(MASTMoceanAdDescriptor*)adDescriptor;


@end
