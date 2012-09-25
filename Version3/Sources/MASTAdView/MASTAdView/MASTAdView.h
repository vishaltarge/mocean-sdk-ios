//
//  MASTAdView
//
//  Created on 9/21/12.
//  Copyright (c) 2011, 2012 Mocean Mobile. All rights reserved.
//

#import "MASTMoceanAdDescriptor.h"

// Required Frameworks
//
// These must be added to projects (via project's link build phase) that use the MASTAdView SDK.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import <MessageUI/MessageUI.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreGraphics/CoreGraphics.h>

//
// This is the only header required for integrating into projects that will use the MASTAdView SDK.
//

@class MASTAdView;

typedef enum
{
    // Ad is placed in application content.
    MASTAdViewPlacementTypeInline = 0, 
    
    // Ad is placed over and in the way of application content.
    // Generally used to place an ad between transtions in an application
    // and consumes the entire screen.
    MASTAdViewPlacementTypeInterstitial
    
} MASTAdViewPlacementType;

typedef enum
{
    MASTAdViewLogEventTypeDebug = 0,

    MASTAdViewLogEventTypeError = 1
    
} MASTAdViewLogEventType;


@protocol MASTAdViewDelegate <NSObject>

@optional

// Sent after an ad has been donloaded and displayed (or ready to display if downloaded off screen).
- (void)MASTAdViewDidRecieveAd:(MASTAdView*)adView;

// Sent when the ad view fails to download an ad.
- (void)MASTAdView:(MASTAdView*)adView didFailToReceiveAdWithError:(NSError*)error;

// Sent when the ad view is about to log an event.
// Return YES to log the event, NO to skip logging the vent.
// Application developers can log events as desired using this message
// and always return NO to prevent the MAST SDK from creating a log file.
- (BOOL)MASTAdView:(MASTAdView*)adView shouldLogEvent:(NSString*)event ofType:(MASTAdViewLogEventType)type;

// Sent when the close button is pressed by the user if showCloseButton:afterDelay was used to enable 
// the close button.  Will not be sent to close expanded richmedia ads in an expanded or resized state.
// The common expected use case is to close interstitial ads placed by the developer.
- (void)MASTAdViewCloseButtonPressed:(MASTAdView*)adView;

// Sent when the ad will navigate to a clicked link.
// Return YES to allow the SDK to open in it's internal broser or sent to iOS to open (ex: Safari).
// Return NO to open as desired.  Not implementing this method behaves as if it returns YES.
- (BOOL)MASTAdView:(MASTAdView*)adView shouldOpenURL:(NSURL*)url;

// Sent before and after the ad grows/expands to a full screen.
- (void)MASTAdViewWillExpand:(MASTAdView*)adView;
- (void)MASTAdViewDidExpand:(MASTAdView*)adView;

// Sent before and after the ad returns to it's original pre-expanded state.
- (void)MASTAdViewWillCollapse:(MASTAdView*)adView;
- (void)MASTAdViewDidCollapse:(MASTAdView*)adView;

// Sent before the ad opens a URL that invokes another application (ex: Safari or App Store).
- (void)MASTAdViewWillLeaveApplication:(MASTAdView*)adView;

// Implement and return YES to support the following features.
- (BOOL)MASTAdViewSupportsSMS:(MASTAdView*)adView;
- (BOOL)MASTAdViewSupportsPhone:(MASTAdView*)adView;
- (BOOL)MASTAdViewSupportsCalendar:(MASTAdView*)adView;
- (BOOL)MASTAdViewSupportsstorePicture:(MASTAdView*)adView;

// The ad server issued a request for the SDK to invoke a separate third party SDK to render the content.
- (void)MASTAdView:(MASTAdView*)adView didReceiveThirdPartyRequest:(NSDictionary*)properties withParams:(NSDictionary*)params;

// The loaded ad is requesting the application to play a video.
// Returning YES from this message will invoke the [UIApplication openURL] method with the video URL.
// Returning NO or not implementing this message results in the request being discarded.
// Application developers can use this method to invoke the modal player by capturing the URL, invoking
// the player and then returning NO.
- (BOOL)MASTAdView:(MASTAdView*)adView shouldPlayVideo:(NSString*)videoURL;

// The loaded ad is requesting for the application to save a new calendar event.
// Returing YES from this callback will add the event to the specified store.
// Returning NO or not implementing this callback results in the event being discarded.
// Application developers should implement this by invoking the EventKitUI controllers and implementing
// the controllers delegates to handle saving the event to allow the user to edit the event or cancel.
// If imppemented in this fasion, return NO (be sure to properly retain the event and eventStore as needed).
- (BOOL)MASTAdView:(MASTAdView*)adView shouldSaveCalendarEvent:(EKEvent*)event inEventStore:(EKEventStore*)eventStore;

// The loaded ad is requiesting for the application to save a photo to the device.
// Returning YES from this callback will add the photo to the camera roll.
// Returning NO or not implementing this callback results in the image being discarded.
// Application developers should implement this by prompting the user to save the image and then saving it
// directly and returning NO from this delegate method.
- (BOOL)MASTAdView:(MASTAdView*)adView shouldSavePhotoToCameraRoll:(UIImage*)image;

// Implement to return a custom close button.  This button will be used for
// richmedia/MRAID if the ad doesn't include one and for non-richmedia and
// if showCloseButton is called to enable the close button.
- (UIButton*)MASTAdViewCustomCloseButton:(MASTAdView*)adView;

@end


@interface MASTAdView : UIView

@property (nonatomic, readonly) NSString* version;

// These are available to customize text and image ad appearance
// if desired.  Do not change properties that would affect placement
// or behavior in their superview (the ad view).
@property (nonatomic, readonly) UILabel* labelView;
@property (nonatomic, readonly) UIImageView* imageView;
@property (nonatomic, readonly) UIView* expandView;
@property (nonatomic, readonly) UIView* resizeView;

// Set the site and zone to get the desired ad content.
// Vist www.mocean.com if you do not have an account.
@property (nonatomic, copy) NSString* site;
@property (nonatomic, copy) NSString* zone;

// Set the server and additional parameters as required.
// These are only needed for advanced usages.
@property (nonatomic, copy) NSString* server;
@property (nonatomic, readonly) NSMutableDictionary* serverParameters;

// Set to enable the use of the internal browser for opening clicked links.
@property (nonatomic, assign) BOOL useInternalBrowser;

// If set causes test param to be set on the server to obtain test campaigns.
// Should never be set to YES for production application releases.
@property (nonatomic, assign) BOOL testMode;

// Returns the type of ad.  If created with initInterstitial will be
// interstitial, else inline.  Interstitials should not be placed inline
// by adding to superviews. 
@property (nonatomic, readonly) MASTAdViewPlacementType placementType;

// Used to determine if location services are enabled.
@property (nonatomic, readonly) BOOL locationDetectionEnabled;

// Implement the delegate to get notification on ad processing.
@property (nonatomic, assign) id<MASTAdViewDelegate> delegate;

// Create a normal banner or other sized ad.
// Can be used for non-full screen interstitials but not recommended
// for MRAID2/richmedia ads intented to be interstitial.
- (id)initWithFrame:(CGRect)frame;

// Create a specific interstitial ad.
// Use showInterstitial to display ads created with this method.
// The returned view need not be added to any parent view.
- (id)initInterstitial;

// Issues an immediate ad update and cancles any pending ad update.
- (void)update;

// Issues an immediate ad update and cancels any pending ad update.
// Will automatically update ever interval seconds.
- (void)updateWithTimeInterval:(NSTimeInterval)interval;

// Stops any updating and update interval.
- (void)cancel;

// Shows and closes the interstitial view.
// Can only be used if the instance was initialized with initInterstitial.
- (void)showInterstitial;
- (void)closeInterstitial;

// Shows a close button after the specified delay (after the ad is rendered).
// Specify a delay value of 0 to show the button as soon as the ad is rendered.
- (void)showCloseButton:(BOOL)showCloseButton afterDelay:(NSTimeInterval)delay;

// Renders an ad directly without downloading it from the ad network.
// Cancles any previous update and update interval.
- (void)renderWithAdDescriptor:(MASTMoceanAdDescriptor*)adDescriptor;

// Used to set the lat and long server properties using the devices location
// services.  Using this method to enable provides the best battery performance
// for the device.
// YES to enable, NO to disable.
- (void)setLocationDetectionEnabled:(BOOL)enabled;

// Used to enable the devices location services to set the lat and long server
// properties.  Use to provide finer grain control over how the location is
// determined and frequency of updates.
- (void)setLocationDetectionEnabledWithPupose:(NSString*)purpose
                          significantUpdating:(BOOL)significantUpdating
                               distanceFilter:(CLLocationDistance)distanceFilter
                              desiredAccuracy:(CLLocationAccuracy)desiredAccuracy;

@end
