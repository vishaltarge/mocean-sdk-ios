//
//  AppAds.h
//  VDOAds
//
//  Created by Srikanth Kakani on 5/10/10.
//  Copyright 2010 Vdopia Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#define STANDARD_IPHONE_BANNER @"320X48"
#define STANDARD_IPAD_BANNER_1 @"728X90"
#define STANDARD_IPAD_BANNER_2 @"768X90"
#define RECTANGLE_BANNER @"300X250"
#define MINI_VDO_BANNER @"320X75"

@class VDOAdObjectController, VDOAdObject;

typedef enum 
{
	top = 0,
	bottom = 1,
}vdoBannerLocation;

typedef enum 
{
	preapp = 0,
	inapp = 1,
	bannerAd = 2,
}vdoAdType;

typedef enum
{
	vdoAPISucces = 0,
	vdoAPIAdLoading = 1,	
	vdoAPIIncorrectTimeOut = 2,
}vdoApiStatus;

@protocol VDOAdsDelegate
@optional
		//Either displayedBanner or noBanner will be called at any given time. Both will not be called
- (void) displayedBanner:(VDOAdObject*)object;
- (void) noBanner:(VDOAdObject*)object;
//Either playedInApp or noInApp will be called at any given time. Both will not be called
- (void) playedInApp:(VDOAdObject*)object;
- (void) playedPreApp:(VDOAdObject*)object;
- (void) noInApp:(VDOAdObject*)object;
- (void) noPreApp:(VDOAdObject*)object;

- (void) bannerTapStarted:(VDOAdObject*)object;
- (void) bannerTapEnded:(VDOAdObject*)object;
- (void) interstitialWillShow:(VDOAdObject*)object;
- (void) interstitialDidDismiss:(VDOAdObject*)object;

@end

// This class manages the load and display of an ad. There can be multiple instances of this object 
// and the parameter "type" specifies the adFormat associated with it
@interface VDOAdObject : NSObject { 
	UIView *adObject;
	int type;
	VDOAdObjectController *vdoAdController;
	// Delete
	NSString *reason;
}

@property (readonly) UIView *adObject;
@property (readonly) int type;
@property (readonly) VDOAdObjectController *vdoAdController;
@property (assign, readwrite) NSString *reason;

-(vdoApiStatus) loadAd:(float)timeout;
-(void) displayAd;
-(vdoApiStatus) loadAndDisplayAd:(UIImage*)splashscreen : (float) timeout;
-(BOOL) isReady;
-(void) closeAd;

@end

@interface VDOAds : NSObject { 
	id<VDOAdsDelegate> delegate;
}

@property (readwrite,assign) id<VDOAdsDelegate> delegate;

// This class manages the overall session of the Ads. There should be a single instance of this object per application
- (void)openWithAppKey:(NSString*)applicationKey useLocation:(BOOL)use;
- (VDOAdObject*) requestBannerOfSize:(NSString *) bannerSize : (int)location;
- (VDOAdObject*) requestPreApp;
- (VDOAdObject*) requestInApp;

- (void)close;

+ (int)isEdgeNetwork;

@end
