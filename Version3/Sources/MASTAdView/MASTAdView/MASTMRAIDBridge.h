//
//  MASTAdView
//
/*
 * PubMatic Inc. (“PubMatic”) CONFIDENTIAL
 * Unpublished Copyright (c) 2006-2014 PubMatic, All Rights Reserved.
 *
 * NOTICE:  All information contained herein is, and remains the property of PubMatic. The intellectual and technical concepts contained
 * herein are proprietary to PubMatic and may be covered by U.S. and Foreign Patents, patents in process, and are protected by trade secret or copyright law.
 * Dissemination of this information or reproduction of this material is strictly forbidden unless prior written permission is obtained
 * from PubMatic.  Access to the source code contained herein is hereby forbidden to anyone except current PubMatic employees, managers or contractors who have executed
 * Confidentiality and Non-disclosure agreements explicitly covering such access.
 *
 * The copyright notice above does not evidence any actual or intended publication or disclosure  of  this source code, which includes
 * information that is confidential and/or proprietary, and is a trade secret, of  PubMatic.   ANY REPRODUCTION, MODIFICATION, DISTRIBUTION, PUBLIC  PERFORMANCE,
 * OR PUBLIC DISPLAY OF OR THROUGH USE  OF THIS  SOURCE CODE  WITHOUT  THE EXPRESS WRITTEN CONSENT OF PubMatic IS STRICTLY PROHIBITED, AND IN VIOLATION OF APPLICABLE
 * LAWS AND INTERNATIONAL TREATIES.  THE RECEIPT OR POSSESSION OF  THIS SOURCE CODE AND/OR RELATED INFORMATION DOES NOT CONVEY OR IMPLY ANY RIGHTS
 * TO REPRODUCE, DISCLOSE OR DISTRIBUTE ITS CONTENTS, OR TO MANUFACTURE, USE, OR SELL ANYTHING THAT IT  MAY DESCRIBE, IN WHOLE OR IN PART.
 */
//

#import <UIKit/UIKit.h>
#import "MASTMRAIDExpandProperties.h"
#import "MASTMRAIDResizeProperties.h"
#import "MASTMRAIDOrientationProperties.h"


@class MASTMRAIDBridge;

typedef enum
{
    MASTMRAIDBridgeStateLoading = 0,
    MASTMRAIDBridgeStateDefault,
    MASTMRAIDBridgeStateExpanded,
    MASTMRAIDBridgeStateResized,
    MASTMRAIDBridgeStateHidden
}MASTMRAIDBridgeState;

typedef enum
{
    MASTMRAIDBridgePlacementTypeInline = 0,
    MASTMRAIDBridgePlacementTypeInterstitial,
}MASTMRAIDBridgePlacementType;

typedef enum
{
    MASTMRAIDBridgeSupportsSMS = 0,
    MASTMRAIDBridgeSupportsTel,
    MASTMRAIDBridgeSupportsCalendar,
    MASTMRAIDBridgeSupportsStorePicture,
    MASTMRAIDBridgeSupportsInlineVideo
}MASTMRAIDBridgeSupports;


@protocol MASTMRAIDBridgeDelegate <NSObject>
@required

- (void)mraidBridgeInit:(MASTMRAIDBridge*)bridge;

- (void)mraidBridgeClose:(MASTMRAIDBridge*)bridge;

- (void)mraidBridge:(MASTMRAIDBridge*)bridge openURL:(NSString*)url;

- (void)mraidBridgeUpdateCurrentPosition:(MASTMRAIDBridge*)bridge;

- (void)mraidBridgeUpdatedExpandProperties:(MASTMRAIDBridge*)bridge;

- (void)mraidBridge:(MASTMRAIDBridge*)bridge expandWithURL:(NSString*)url;

- (void)mraidBridgeUpdatedOrientationProperties:(MASTMRAIDBridge *)bridge;

- (void)mraidBridgeUpdatedResizeProperties:(MASTMRAIDBridge *)bridge;

- (void)mraidBridgeResize:(MASTMRAIDBridge*)bridge;

- (void)mraidBridge:(MASTMRAIDBridge*)bridge playVideo:(NSString*)url;

- (void)mraidBridge:(MASTMRAIDBridge*)bridge createCalenderEvent:(NSString*)event;

- (void)mraidBridge:(MASTMRAIDBridge*)bridge storePicture:(NSString*)url;

@end


@interface MASTMRAIDBridge : NSObject

@property (nonatomic, assign) id<MASTMRAIDBridgeDelegate> delegate;

@property (nonatomic, assign) BOOL needsInit;

@property (nonatomic, readonly) MASTMRAIDBridgeState state;
@property (nonatomic, readonly) MASTMRAIDExpandProperties* expandProperties;
@property (nonatomic, readonly) MASTMRAIDResizeProperties* resizeProperties;
@property (nonatomic, readonly) MASTMRAIDOrientationProperties* orientationProperties;


- (void)sendErrorMessage:(NSString*)message forAction:(NSString*)action forWebView:(UIWebView*)webView;
- (void)setSupported:(BOOL)supported forFeature:(MASTMRAIDBridgeSupports)feature forWebView:(UIWebView*)webView;
- (void)setState:(MASTMRAIDBridgeState)state forWebView:(UIWebView*)webView;
- (void)sendReadyForWebView:(UIWebView*)webView;
- (void)setViewable:(BOOL)viewable forWebView:(UIWebView*)webView;
- (void)setScreenSize:(CGSize)screenSize forWebView:(UIWebView*)webView;
- (void)setMaxSize:(CGSize)maxSize forWebView:(UIWebView*)webView;
- (void)setCurrentPosition:(CGRect)currentPosition forWebView:(UIWebView*)webView;
- (void)setDefaultPosition:(CGRect)defaultPosition forWebView:(UIWebView*)webView;
- (void)setPlacementType:(MASTMRAIDBridgePlacementType)placementType forWebView:(UIWebView*)webView;
- (void)setExpandProperties:(MASTMRAIDExpandProperties*)expandProperties forWebView:(UIWebView*)webView;
- (void)setResizeProperties:(MASTMRAIDResizeProperties*)resizeProperties forWebView:(UIWebView*)webView;
- (void)setOrientationProperties:(MASTMRAIDOrientationProperties*)orientationProperties forWebView:(UIWebView*)webView;
- (void)sendPictureAdded:(BOOL)success forWebView:(UIWebView*)webView;


// Call when UIWebView (MRAID container) loads a request.
// Returns TRUE if the request was for MRAID, false if it's some other request.
- (BOOL)parseRequest:(NSURLRequest*)request;

@end
