//  Copyright 2009 Rhythm NewMedia. All rights reserved.

#import <UIKit/UIKit.h>

typedef enum {
    kBadge,           /* 100 x 50  */ 
    kBanner,          /* 320 x 50  */ 
    kMediumRectangle, /* 300 x 250 */
    kLeaderboard,     /* 728 x 90                  (iPad only) */ 
    kWideSkyscraper,  /* 160 x 600                 (iPad only) */
    kFullPageGlossy,  /* 768 x 1024 or 1024 x 768  (orientation dependent, iPad only) */
    kInterstitial,    /* 320 x 400 or 480 x 250 for iPhone (orientation dependent), 512 x 512 for iPad */
} RhythmAdUnit;

#pragma mark -

@protocol RhythmAdDelegate;

// ------------------------------------------------------------------
#pragma mark -

/*!
 A single Rhythm banner display ad.
 */
@protocol RhythmAd

/*!
 Causes this RhythmAd to be refreshed with a new ad.
 The delegate is called upon success or failure.
 */
-(void)requestNewAd;

/*!
 This can be used to cancel an ad request in progress.
 You should definitely call this method in the case where
 your ad delegate is being deallocated while an ad
 request is still in progress (otherwise the ad object
 will attempt to send messages to a delegate that no
 longer exists).
 */
-(void)cancel;

/*!
 This can be used if you need to attach any custom/extrinsic
 data to the ad.
 */
-(void)addUserInfoObject:(id)obj forKey:(id<NSCopying>)key;

/*!
 This can be used to retrieve custom/extrinsic data previously associated
 with the ad via addUserInfoObject:forKey:
 */
-(id)userInfoObjectForKey:(id<NSCopying>)key;

/*!
 The type of ad in the ad view
 */
@property (nonatomic, readonly) RhythmAdUnit adUnit;

/*!
 Set upon ad receipt, indicates for how long the ad would like to remain
 onscreen. This is used for ads that have a duration component (i.e.
 are playing a video, or include some animation). The value will be
 zero for ads not specifically requesting any time-to-live.
 */
@property (nonatomic, readonly) NSTimeInterval desiredTTL;

/*!
 This can be used to track the pinned status of the ad. 
 */
@property (nonatomic, readonly, getter=isPinned) BOOL pinned;

@end

// ------------------------------------------------------------------
#pragma mark -

/*!
 A single Rhythm interstitial display ad.
 */
@protocol RhythmInterstitialAd<RhythmAd>

/*!
 The ad title is shown in the toolbar upon takeover, or it is
 available for your app to use if you are integrating this
 interstitial with your view hierarchy.
 */
-(NSString *)title;

/*!
 Causes this interstitial to appear, covering the entire screen.
 */
-(void)showAsTakeover;

@end

// ------------------------------------------------------------------
#pragma mark -

/*!
 Entry point for creating Rhythm display ads.
 */
@interface RhythmAdFactory : NSObject

#pragma mark banner ads

/*!
 Requests an ad asynchronously, and immediately returns a view in which
 the ad will be displayed. The delegate is called upon success or failure.

 The size of the returned view is 320x50 pixels.
 */
+(UIView<RhythmAd> *)bannerAdViewWithDelegate:(NSObject<RhythmAdDelegate> *)delegate;

/*!
 If called with initiateRequest=YES, this has the same behavior as the
 bannerAdViewWithDelegate: method above.

 If called with initiateRequest=NO, this method will immediately return a
 view, but an ad request will not be initiated (until you call requestNewAd).
 You can use this approach to set up placeholder views within your application
 without actually fetching ads from the server.

 The size of the returned view is 320x50 pixels.
 */
+(UIView<RhythmAd> *)bannerAdViewWithDelegate:(NSObject<RhythmAdDelegate> *)delegate
                              initiateRequest:(BOOL)initiateRequest;

#pragma mark interstitial ads

/*!
 Requests an ad asynchronously, and immediately returns a view in which
 the ad will be displayed. The delegate is called upon success or failure.

 The orientation of the ad is determined by the application's current 
 status bar orientation (not the device orientation - meaning if the 
 user is holding the device in landscape but your app is coded to remain
 in portrait, the returned ad will be portrait).
 
 The size of the returned view is as described in the 
 interstitialAdViewWithDelegate:forInterfaceOrientation: method.
 
 If the interstitial is to be used as an ALU (displayed during app launch),
 you should implement the targetingForAdView: delegate method and 
 return the string "applaunch".
 */
+(UIView<RhythmInterstitialAd> *)interstitialAdViewWithDelegate:(NSObject<RhythmAdDelegate> *)delegate;

/*!
 Requests an ad asynchronously, and immediately returns a view in which
 the ad will be displayed. The delegate is called upon success or failure.
 
 The size of the returned view depends on the orientation parameter:
 UIInterfaceOrientationPortrait and UIInterfaceOrientationPortraitUpsideDown
 yield a 320x400 pixel view, UIInterfaceOrientationLandscapeLeft and
 UIInterfaceOrientationLandscapeRight yield a 480x250 pixel view.
 */
+(UIView<RhythmInterstitialAd> *)interstitialAdViewWithDelegate:(NSObject<RhythmAdDelegate> *)delegate 
                                        forInterfaceOrientation:(UIInterfaceOrientation)orientation;

/*!
 Same behavior as in the bannerAdViewWithDelegate:initiateRequest: method, 
 with returned view sizes as described in the 
 interstitialAdViewWithDelegate:forInterfaceOrientation: method.
 */
+(UIView<RhythmInterstitialAd> *)interstitialAdViewWithDelegate:(NSObject<RhythmAdDelegate> *)delegate 
                                        forInterfaceOrientation:(UIInterfaceOrientation)orientation
                                                initiateRequest:(BOOL)initiateRequest;

#pragma mark additional display ad units

/*!
 Requests an ad asynchronously, and immediately returns a view in which
 the ad will be displayed. The delegate is called upon success or failure.
 
 The size of the returned view will depend on the ad type.
 
 Please note that if this is called while running on a non-iPad device
 with an iPad-only ad type, this will immediately return nil and no delegate
 callbacks will be invoked.
 */
+(UIView<RhythmAd> *)displayAdViewWithDelegate:(NSObject<RhythmAdDelegate> *)delegate
                                        adUnit:(RhythmAdUnit)adUnit;

/*!
 If called with initiateRequest=YES, this has the same behavior as the
 displayAdViewWithDelegate:adUnit: method above.
 
 If called with initiateRequest=NO, this method will immediately return a
 view, but an ad request will not be initiated (until you call requestNewAd).
 You can use this approach to set up placeholder views within your application
 without actually fetching ads from the server.
 
 The size of the returned view will depend on the ad type.
 
 Please note that if this is called while running on a non-iPad device
 with an iPad-only ad type, this will immediately return nil and no delegate
 callbacks will be invoked.
 */
+(UIView<RhythmAd> *)displayAdViewWithDelegate:(NSObject<RhythmAdDelegate> *)delegate
                                        adUnit:(RhythmAdUnit)adUnit
                               initiateRequest:(BOOL)initiateRequest;

@end
