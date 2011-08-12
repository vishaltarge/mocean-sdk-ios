//  Copyright 2010 Rhythm NewMedia. All rights reserved.

#import <CoreLocation/CoreLocation.h>

@protocol RhythmVideoController;

#pragma mark -

/*!
 Defines the mechanism by which the Rhythm Video SDK communicates
 back to your app for ad-specific activities.
 */
@protocol RhythmVideoAdDelegate<NSObject>

#pragma mark -
#pragma mark required

@required

/*!
 A string uniquely identifying the application - provided by Rhythm
 */
-(NSString *)appId;

#pragma mark -
#pragma mark optional

@optional

/*!
 Sent when no video ad is currently available for a request.
 For an ad-only request, the controller will immediately 
 shutdown. For a request with content, the content will
 begin buffering and playback.
 */
-(void)noAdAvailable:(NSObject<RhythmVideoController> *)videoController;

/*!
 Case 1
 ------
 If your app already has location data and you would like to provide it
 to the ad server, you should
 - implement this method and return YES
 - implement locationForAdView: and return the user's location
 
 Case 2
 ------
 If your app does not have location data but you would like the Rhythm
 SDK to determine it and provide it to the ad server, you should:
 - implement this method and return YES
 - do not implement locationForAdView:
 
 Some notes concerning location:
 - the first ad request for which the Rhythm SDK will be asked
 to determine location information may not actually include location
 data, since it takes some time to retrieve that data from the OS
 - if the user has turned off location services for their device, the
 Rhythm SDK will not attempt to determine location data
 
 Case 3
 ------
 If you do not want to provide location data to the ad server, you
 should not implement this method (or you could have it return NO).
 */
-(BOOL)locationEnabled;

/*!
 If locationEnabled (above) is not implemented or returns NO, 
 this will not be called.
 
 If locationEnabled is implemented and returns YES, this 
 will be called. You can:
 - implement this and return location data if you already have it
 - implement this and return nil if the user's location is unknown
 - do not implement this if you want the Rhythm SDK to determine 
 ths user's location
 */
-(CLLocation *)location;

/*!
 Comma-separated targeting parameters
 */
-(NSString *)targeting;

// Common targeting parameters
-(NSString *)postalCode; // zip code
-(NSString *)areaCode; // phone area code
-(NSDate *)dateOfBirth; // user's date of birth
-(NSString *)gender; // "male" or "female"

/*!
 If implemented and returns YES, the Rhythm SDK will call 
 presentLandingPageForURL:, and the app is responsible for presenting
 its own custom landing page for the given URL.
 
 If not implemented or returns NO, the Rhythm SDK will present the built-in
 landing page view.
 */
-(BOOL)useCustomLandingPage;

/*!
 Called when the ad is touched, only if useCustomLandingPage is implemented 
 and returns YES. When this is called, the app should process the url and 
 present the landing page
 */
-(void)presentLandingPageForURL:(NSURL *)landingPageURL;

/*!
 Notification methods in regards to the landing page presentation
 These methods will be called only when the built-in landing page is used.
 If the parameter animated is YES then it means the view will be presented
 in an animated fashion with the standard time interval used by the 
 iPhone UI framework.
 */
-(void)willPresentLandingPageForIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated;
-(void)didPresentLandingPageForIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated;
-(void)willDismissLandingPageForIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated;
-(void)didDismissLandingPageForIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated;

#pragma mark -
#pragma mark testing only

/*!
 If implemented and returns YES, ads from Rhythm's test ad server
 will be displayed. Don't submit your app with this turned on!
 */
-(BOOL)testMode;

/*!
 If implemented and returns non-nil, this is the URL string that will be
 used for ad click events. You can use this to test various click-through
 types, regardless of the click-through of the actual ad.
 This is only used if testMode is implemented and returns YES.
 */
-(NSString *)clickURLForTestMode;

@end
