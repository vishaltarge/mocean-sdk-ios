// Copyright 2010 Rhythm NewMedia. All rights reserved.

#import <UIKit/UIKit.h>
#import "RhythmAd.h"

typedef enum {
    RhythmZoomButtonNone,
    RhythmZoomButtonScale,
    RhythmZoomButtonFullscreen
} RhythmZoomButtonStyle;

enum {RhythmNoAd = -1};

@protocol RhythmVideoAdDelegate;
@protocol RhythmVideoDelegate;
@protocol RhythmVideoDataSource;

@protocol RhythmVideoController

@property (nonatomic, assign) NSObject<RhythmVideoAdDelegate> *videoAdDelegate;
@property (nonatomic, assign) NSObject<RhythmVideoDelegate> *videoDelegate;
@property (nonatomic, assign) NSObject<RhythmVideoDataSource> *videoDataSource;

/*!
 View containing all movie elements (video playback, any overlays, etc)
 */
@property (nonatomic, readonly) UIView *view;

/*!
 View containing just the playback controls. This is an overlay on the
 video playback whose visibility is toggled when the user taps on the screen.
 */
@property (nonatomic, readonly) UIView *controlsView;

/*!
 This property determines if the SDK will control the visibility of the
 status bar during movie playback. This should be set before calling the
 play method, and has no effect if called after. The default is YES, 
 meaning the status bar will be hidden during playback, and appear when
 the video controls are showing.
 */
@property (nonatomic, assign) BOOL manageStatusBar;

/*!
 This property determines if the SDK will show a clip browser as part
 of the video controls. This should be set before calling the play method,
 and has no effect if called after. The default is YES.
 */
@property (nonatomic, assign) BOOL showClipBrowser;

/*!
 This property determines if the SDK will play video in "fullscreen" mode,
 meaning that the player will takeover the entire screen in the
 UIInterfaceOrientationLandscapeRight orientation. Use this to mimic
 pre-iPhone OS 3.2 movie player behavior; in this case you do not need
 to put this controller's view into your view heirarchy (but you still
 do need to call the play method). This should be set before calling the
 play method or accessing the player's view (in fact there should be no
 need to access the view if fullscreen is desired), and has no effect if
 called after. The default is NO. This property has no effect when the app
 is running on an iPhone OS version less than 3.2 (that movie playback is
 always fullscreen).
 */
@property (nonatomic, assign) BOOL fullscreen;

/*!
This property controls whether or not the video controller should follow
the devices physical orientation and rotate the player view accordingly.
If it's YES (the default value) then the video player view won't rotate.
This property takes effect only when the video player is in 'fullscreen' mode.
*/
@property (nonatomic, assign) BOOL locksOrientation;

/*!
This property specifies the orientation to lock when both 'fullscreen'
and 'locksOrientation' are YES. The default is UIInterfaceOrientationLandscapeRight.
*/
@property (nonatomic, assign) UIInterfaceOrientation orientationToLock;

/*!
 This property determies which button to put at the right side of controlsView.
 If the value is RhythmZoomButtonNone, no button will appear. If it's RhythmZoomButtonScale,
 there will the button that changes the mode between 'scale fill' and 'scale fit'.
 If it's RhythmZoomButtonFullscreen, there will the button that changes the fullscreen mode on and off.
 The default value is RhythmZoomButtonScale.
 */
@property (nonatomic, assign) RhythmZoomButtonStyle zoomButtonStyle;

/*!
 This property determines whether to present the done button when the video
 player is embedded. The default value is NO. If set to YES, the done button won't
 be displayed when the video player is in the embedded mode.
 In the fullscreen mode, this property does not take effect,
 and the done button will be displayed anyway.
 */
@property (nonatomic, assign) BOOL disableDoneButtonWhenEmbedded;

-(void)play;
-(void)pause;
-(void)stop;

@property (nonatomic, readonly) NSIndexPath *currentIndexPath;

/*!
 This property can be used to support resuming a video at a specific point.
 
 If this property is set before video playback is initiated, then
 the video will not include a preroll ad, and playback will begin
 at the specified time.
 
 If this property is set after video playback has started, the playhead
 will simply move as desired (without regard to any advertising).
 
 When this property is queried after video playback has begun, it will 
 contain the current position of playback within the current content
 *not including any ad video time*.
 
 Only works when running on devices with iPhone OS 3.2 or greater
 */
@property (nonatomic, assign) NSTimeInterval currentContentPlaybackTime;

/*!
 This property indicates whether or not the video player is playing a video ad.
 If it is YES, it means the player is either preloading the ad or playing it.
 It's NO otherwise.
 */
@property (nonatomic, readonly) BOOL playingAd;

@end


// ------------------------------------------------------------------
#pragma mark -

/*!
 This category provides convenience methods to make it easier to use 
 an NSIndexPath to represent a channel and content
 */
@interface NSIndexPath (RhythmVideoController)

+(NSIndexPath *)indexPathForContent:(NSUInteger)contentNum
                          inChannel:(NSUInteger)channelNum;

@property(nonatomic, readonly) NSUInteger channelNum;
@property(nonatomic, readonly) NSUInteger contentNum;

@end


// ------------------------------------------------------------------
#pragma mark -

/*!
 Entry point for Rhythm video ads.
 */
@interface RhythmVideoControllerFactory : NSObject

/*!
 Creates a video controller hooked up to a data source, used for playback
 of multiple contents and/or contents with additional metadata
 */
+(UIViewController<RhythmVideoController> *)newVideoControllerWithAdDelegate:(NSObject<RhythmVideoAdDelegate> *)adDelegate 
                                                               videoDelegate:(NSObject<RhythmVideoDelegate> *)videoDelegate 
                                                                  dataSource:(NSObject<RhythmVideoDataSource> *)dataSource;

/*!
 Returns a RhythmVideoController that will play the video at the specified
 URL.

 Returns nil if url is an empty string.

 Loading of the video begins when you call play, and playback begins as 
 soon as enough of the video has been loaded to play without buffering 
 interruptions.
 
 You should place the controller's view in your view hierarchy to be 
 able to see the video. You can wait until your videoDelegate receives
 the preloadComplete:forIndexPath:duration: callback if you want to 
 add the view only once video buffering is complete.
 
 The delegates are used to communicate video and ad related events back 
 to the application.
 */
+(UIViewController<RhythmVideoController> *)newVideoControllerWithAdDelegate:(NSObject<RhythmVideoAdDelegate> *)adDelegate 
                                                               videoDelegate:(NSObject<RhythmVideoDelegate> *)videoDelegate 
                                                                  contentURL:(NSString *)url;

/*!
 Returns a RhythmVideoController that will play the video at the specified
 URL, and display the specified title on the controls view.
 
 Returns nil if url is an empty string.
 */
+(UIViewController<RhythmVideoController> *)newVideoControllerWithAdDelegate:(NSObject<RhythmVideoAdDelegate> *)adDelegate 
                                                               videoDelegate:(NSObject<RhythmVideoDelegate> *)videoDelegate 
                                                                  contentURL:(NSString *)url
                                                                contentTitle:(NSString *)title;

/*!
 Returns a RhythmVideoController that will sequentially play the videos at the
 specified URLs. 
 
 The contentURLs parameters are a null-terminated list of URLs.
 
 Returns nil if no non-empty urls provided.
 */
+(UIViewController<RhythmVideoController> *)newVideoControllerWithAdDelegate:(NSObject<RhythmVideoAdDelegate> *)adDelegate 
                                                               videoDelegate:(NSObject<RhythmVideoDelegate> *)videoDelegate 
                                                                 contentURLs:(NSString *)firstUrl, ...;

/*!
 Returns a RhythmVideoController that will sequentially play the videos at the
 specified URLs, and display corresponding titles on the controls view.
 
 The contentURLsAndTitles parameters are a null-terminated list of alternating
 URLs and titles.
 
 Returns nil if no non-empty urls provided.
 */
+(UIViewController<RhythmVideoController> *)newVideoControllerWithAdDelegate:(NSObject<RhythmVideoAdDelegate> *)adDelegate 
                                                               videoDelegate:(NSObject<RhythmVideoDelegate> *)videoDelegate 
                                                        contentURLsAndTitles:(NSString *)firstUrl, ...;

/*!
 Returns a RhythmVideoController that will sequentially play the videos at the
 specified URLs. 
 
 Any zero-length URLs are ignored.
 
 Returns nil if no non-empty urls provided.
 */
+(UIViewController<RhythmVideoController> *)newVideoControllerWithAdDelegate:(NSObject<RhythmVideoAdDelegate> *)adDelegate 
                                                               videoDelegate:(NSObject<RhythmVideoDelegate> *)videoDelegate 
                                                          arrayOfContentURLs:(NSArray *)urls;

/*!
 Returns a RhythmVideoController that will sequentially play the videos at the
 specified URLs.
 
 URLs and titles are related based on having the same position in the two
 arrays. The array sizes need not be the same; any extra titles are ignored
 and any URL without a title won't have a title displayed.
 
 Any zero-length URLs are ignored.
 
 Returns nil if no non-empty urls provided.
 */
+(UIViewController<RhythmVideoController> *)newVideoControllerWithAdDelegate:(NSObject<RhythmVideoAdDelegate> *)adDelegate 
                                                               videoDelegate:(NSObject<RhythmVideoDelegate> *)videoDelegate 
                                                          arrayOfContentURLs:(NSArray *)urls
                                                        arrayOfContentTitles:(NSArray *)titles;

/*!
 Returns a RhythmVideoController that will play a single video ad, if one is 
 available. You must call the play method to initiate playback.
 
 If no ad is available, your RhythmVideoAdDelegate will receive the 
 noAdAvailable message (and your RhythmVideoDelegate will receive
 the playerShutdown: message like normal, at which point you can 
 release the RhythmVideoController).
 
 If an ad is available, your RhythmVideoDelegate will receive the
 preloadComplete:forIndexPath:duration: message once playback is 
 about to begin (and the playerShutdown: message once the ad is done).
 */
+(UIViewController<RhythmVideoController> *)newVideoAdControllerWithAdDelegate:(NSObject<RhythmVideoAdDelegate> *)adDelegate 
                                                                 videoDelegate:(NSObject<RhythmVideoDelegate> *)videoDelegate;


/*!
 Preemptively start network determination (wifi vs cellular)
 rather than waiting until the first video request.
 */
+(void)startNetworkDetection;

@end
