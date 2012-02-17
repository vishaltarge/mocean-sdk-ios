//
//  MASTAdViewDelegate.h
//  AdMobileSDK
//
//  Created by Constantine Mureev on 2/24/11.
//
//  version: 2.10.0
//

/** The MASTAdViewDelegate protocol defines methods that a delegate of a MASTAdView object can optionally implement to receive notifications from ad. */
@protocol MASTAdViewDelegate <NSObject>
@optional

/** Sent before an ad view will begin loading ad content.
 
 @param sender The ad view that is about to load ad content.
 */
- (void)willReceiveAd:(id)sender;

/** Sent after an ad view finished loading ad content.
 
 @param sender The ad view has finished loading.
 */
- (void)didReceiveAd:(id)sender;

/** Sent if SDK received client side third party campaign.
 
 Generally, this method called if the SDK can’t display ads due to reliance on a third party. For example: AdMob, Rhythm or SmartAdServer
 
 @warning *Important:* The SDK will never display ads which trigger this method! They are used to call the third party SDKs in your app.
 
 @param sender The ad view that receive 3rd party ad content.
 @param content The dictionary of strings (key/values) for third party. You can start processing this content from @“type” key for determining ads type.
 */
- (void)didReceiveThirdPartyRequest:(id)sender content:(NSDictionary*)content;

/** Sent if an ad view failed to load ad content.
 
 The same method can be invoked if the server does not currently advertising.
 
 @param sender The ad view that failed to load ad content.
 @param error The error that occurred during loading.
 */
- (void)didFailToReceiveAd:(id)sender withError:(NSError*)error;

/** Sent before an ad view will start to display internal browser.
 
 @warning *Important:* This method called after adShouldOpen:withUrl: returns YES or not implemented.
 
 @warning *Important:* This method is not called on opening ads in Safari (internalOpenMode set to NO). To handle this behaviour implement UIApplicationDelegate protocol
 
 @param sender The ad view that is about to display internal browser.
 */
- (void)adWillStartFullScreen:(id)sender;

/** Sent after an ad view finished displaying internal browser.
 
 @param sender The ad view has finished displaying internal browser.
 */
- (void)adDidEndFullScreen:(id)sender;

/** Sent before an ad view will start to open URL.
 
 Implement this method with return NO value if you want to control opening ads by your self.
 
 This method is optional. If you do not implement this method, the SDK accept YES as return value.
 
 @warning *Important:* This method may not calling on 3rd party SDKs (Millennial, Greystripe, iVdopia, ...)
 
 @param sender The ad view that is about to open URL.
 @param url The URL that should be opened in internal or external browser.
 @return Returns YES to allow SDK open browser otherwise returns NO.
 */
- (BOOL)adShouldOpen:(id)sender withUrl:(NSURL*)url;

/** Sent after an ad view closed and tracks the usage time of ad interstitial view.
 
 @param sender The ad view was closed.
 @param usageTimeInterval The usage time interval of ad view. */
- (void)didClosedAd:(id)sender usageTimeInterval:(NSTimeInterval)usageTimeInterval;

/** Sent after an ad process ORMMA command.
 
 @warning *Important:* Implement this method only if you want add additional logic for event. By default SDK alreadey emplements all methods and your code could conflict with SDK
 
 @param sender The ad view that is about to process ORMMA event.
 @param event The string with name of the event.
 @param parameters The Dictionary with parameters from event.
 */
- (void)ormmaProcess:(id)sender event:(NSString*)event parameters:(NSDictionary*)parameters;

@end