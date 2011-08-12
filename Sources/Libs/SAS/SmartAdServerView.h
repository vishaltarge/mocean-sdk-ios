//
//  SmartAdServerView.h
//  SmartAdServer
//
//  Created by Paul-Anatole CLAUDOT on 20/09/10.
//  Copyright 2010 HAPLOID. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AdView.h"

#ifdef INCLUDE_LOCATION_MANAGER
#import <CoreLocation/CoreLocation.h>
#endif
#import <UIKit/UIKit.h>
#import "SmartAdServerDelegate.h"

#define SASV_DEFAULT_DURATION						10
#define SASV_MAX_EXPAND_HEIGHT						600
#define SASV_ENDTRANSITION_DURATION					0.5
#define SAS_SDK_VERSION	 @"2.1.1"



#pragma mark TYPE DEF


typedef enum {
	SmartAdServerViewFormatIntersticielStart,			//	320x460	Full screen ad for a screen with statusbar without navBar either tabBar and Default.png during the downloadind delay
	SmartAdServerViewFormatIntersticiel,				//	320x460	Full screen ad for a screen with statusbar without navBar either tabBar
	SmartAdServerViewFormatIntersticielNavBar,			//	320x416	Full screen ad for a screen with statusbar with navBar and without tabBar
	SmartAdServerViewFormatIntersticielTabBar,			//	320x411	Full screen ad for a screen with statusbar without navBar and with tabBar
	SmartAdServerViewFormatIntersticielNavBarTabBar,	//	320x367	Full screen ad for a screen with statusbar with navBar and tabBar
	SmartAdServerViewFormatBanner,						//	320x50/20	Banner ad. This type of ad will not

	
	
	// iPad
	SmartAdServerViewFormatIntersticieliPadStart,			//	768x1024	Full screen ad for a screen with statusbar without navBar either tabBar and Default.png during the downloadind delay
	SmartAdServerViewFormatIntersticieliPad,				//	768x1024	Full screen ad for a screen with statusbar without navBar either tabBar
	SmartAdServerViewFormatIntersticielNavBariPad,			//	768x960	Full screen ad for a screen with statusbar with navBar and without tabBar
	SmartAdServerViewFormatIntersticielTabBariPad,			//	768x955	Full screen ad for a screen with statusbar without navBar and with tabBar
	SmartAdServerViewFormatIntersticielNavBarTabBariPad,	//	768x911	Full screen ad for a screen with statusbar with navBar and tabBar
	SmartAdServerViewFormatBanneriPad,						//	768x90/20	Banner ad. This type of ad will not
} SmartAdServerViewFormat;


// Transition types when an instersticiel disappears
typedef enum {
	UISASViewAnimationTransitionNone,
	UISASViewAnimationTransitionFadeOut,
	UISASViewAnimationTransitionPush,
	UISASViewAnimationTransitionReveal,
	UISASViewAnimationTransitionFlipFromLeft,
	UISASViewAnimationTransitionFlipFromRight,
	UISASViewAnimationTransitionCurlUp,
	UISASViewAnimationTransitionCurlDown,
} UISASViewAnimationTransition;


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark PROTOCOL
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@protocol SASAdDownloaderDelegate

- (void)SASAdDownloaderDelegateDidFinish:(SmartAdServerAd *)ad;
- (void)SASAdDownloaderDelegateDidFailedWithError:(NSError *)er;

@end

@protocol SASAdDownloaderImageDelegate

- (void)SASAdDownloaderImageDelegateDidFinish:(UIImage *)img;
- (void)SASAdDownloaderImageDelegateDidFailedWithError:(NSError *)er;

@end

@protocol SASAdDownloaderImageLandscapeDelegate

- (void)SASAdDownloaderImageLandscapeDelegateDidFinish:(UIImage *)img;
- (void)SASAdDownloaderImageLandscapeDelegateDidFailedWithError:(NSError *)er;

@end


@class SASApi;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark INTERFACE
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface SmartAdServerView : UIView <SASAdDownloaderDelegate, UIWebViewDelegate, SASAdDownloaderImageDelegate, SASAdDownloaderImageLandscapeDelegate> {
	UIViewController <SmartAdServerViewDelegate> *delegate;
	SmartAdServerViewFormat format;
	NSString *formatId;
	NSString *pageId;
	NSString *master;
	NSString *target;
	SmartAdServerAd *ad;
	SmartAdServerAd *downloadingAd;
	UISASViewAnimationTransition endTransition;
	
	CGFloat heightDelta;
	BOOL isExpanded;
	float duration;
	UIImageView *gradientImageView;
	UIImageView *expandGradient;
	UILabel *adLabel;
	UIButton *triggerButton;
	UIButton *adButton;
	UIButton *skipButton;
	UIWebView *webView;
	UIActivityIndicatorView *loadingAI;
	
	
	NSTimer *durationTimer;
	BOOL failed;
	BOOL abonned;
	BOOL isLandscapeDownload;

}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark PROPERTY
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@property UISASViewAnimationTransition endTransition;
@property (nonatomic, readonly) SmartAdServerViewFormat format;
@property (nonatomic, readonly) NSString *pageId;
@property (nonatomic, readonly) NSString *master;
@property (nonatomic, readonly) NSString *target;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark FUNCIONS
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

+ (void)setSiteId:(NSString *)siteId;
#ifdef INCLUDE_LOCATION_MANAGER
+ (void)setCoordinate:(CLLocationCoordinate2D)coordinate;
#endif

- (id)initWithSASViewFormat:(SmartAdServerViewFormat)format 
			   withFormatId:(NSString *)formatId 
				 withPageId:(NSString *)pageId 
				 withMaster:(NSString *)master 
				 withTarget:(NSString *)target;

- (id)initWithSASViewFormat:(SmartAdServerViewFormat)format 
			   withFormatId:(NSString *)formatId 
				 withPageId:(NSString *)pageId 
				 withTarget:(NSString *)target;

- (void)dissmissMe;
- (void)switchToMode:(BOOL)expand;
- (void)deviceRotate:(id)obj;
- (void)setDelegate:(id)del;

@end
