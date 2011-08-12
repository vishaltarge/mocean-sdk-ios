//
//  AppAds.h
//  VDOAds
//
//  Created by Srikanth Kakani on 5/10/10.
//  Copyright 2010 Vdopia Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#define STANDARD_IPHONE_BANNER @"320X48"
#define STANDARD_IPAD_BANNER @"728X90"
#define RECTANGLE_BANNER @"300X250"

@protocol VDOAdsDelegate
	@optional
	//Either playedVDOAd or noVDOAd will be called at any given time. Both will not be called
		- (void) playedVDOAd;
		- (void) noVDOAd;
		//Either displayedBanner or noBanner will be called at any given time. Both will not be called
		- (void) displayedBanner;
		- (void) noBanner;
		- (void) bannerTapStarted;
		- (void) bannerTapEnded;
		//Either playedInApp or noInApp will be called at any given time. Both will not be called
		- (void) playedInApp;
		- (void) playedPreApp;
		- (void) noInApp;
		- (void) noPreApp;
@end

@interface VDOAds : NSObject {
	UIView *adObject;
	id<VDOAdsDelegate> delegate;
}

@property (readwrite,assign) id<VDOAdsDelegate> delegate;
@property (readonly) UIView * adObject;
// initialization and un-initialization functions which create/destroy the PurpleConnect shared object
- (void)openWithAppKey:(NSString*)applicationKey useLocation:(BOOL)use withFrame:(CGRect) frame;
- (void)openWithAppKey:(NSString*)applicationKey useLocation:(BOOL)use withFrame:(CGRect) frame startWithBanners: (BOOL) start;
- (void)openWithAppKey:(NSString*)applicationKey useLocation:(BOOL)use withFrame:(CGRect) frame startWithBanners: (BOOL) start startWithPreApp: (BOOL) preAppStart;
- (void)pauseBanners;
- (void)resumeBanners;
- (void)playVDOAd;
- (void)playInApp;
- (void)playPreApp;
- (BOOL)isPreAppAvailable;
- (BOOL)isInAppAvailable;
- (BOOL)isBannerAvailable;
- (void)rotateBanner;
- (UIView*)getBannerOfSize:(NSString*)bannerSize; // Request a new banner

//The message must be shorter than 33 characters in order to look good
//iVdopia will not check the length of the string, however the look of the advertisement
// in your application will be effected if the guideline is not followed
- (void)playVDOAd:(NSString*) message;
- (void)close;

+ (int)isEdgeNetwork;

@end
