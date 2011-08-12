//  Copyright 2010 Rhythm NewMedia. All rights reserved.

typedef enum {
    RhythmBumperFade,
    RhythmBumperSlideLeft,
    RhythmBumperSlideRight,
    RhythmBumperSlideUp,
    RhythmBumperSlideDown
} RhythmBumperAnimationType;

@protocol RhythmVideoController;

@protocol RhythmVideoDelegate<NSObject>

@optional

#pragma mark -
#pragma mark general player callbacks

/*!
 Called when enough of the video has been loaded to begin
 playback.
 */
-(void)preloadComplete:(NSObject<RhythmVideoController> *)videoController 
          forIndexPath:(NSIndexPath *)indexPath
              duration:(NSTimeInterval)duration;

/*!
 Sent when a request to the server failed to return.
 If the requested content URL is hosted by Rhythm, then
 it will not play. If the content URL is not hosted by
 Rhythm, it will still play, but will not have any ads.
 */
-(void)didNotReceiveServerResponse:(NSObject<RhythmVideoController> *)videoController
                      forIndexPath:(NSIndexPath *)indexPath 
                             error:(NSError *)error;

/*!
 Sent when a movie cannot be played
 */
-(void)cannotPlayMovie:(NSObject<RhythmVideoController> *)videoController
          forIndexPath:(NSIndexPath *)indexPath;

/*!
 Called when the video player has been completely shutdown.
 */
-(void)playerShutdown:(NSObject<RhythmVideoController> *)videoController;

/*!
 Color with which to fill the screen during transitions between videos
 and bumpers. Defaults to black.
 */
-(UIColor *)backgroundColor;

// ---------------------------------------------------------------------------
#pragma mark -
#pragma mark playback callbacks

-(void)controller:(NSObject<RhythmVideoController> *)videoController
    playbackStartedForIndexPath:(NSIndexPath *)indexPath;

-(void)controller:(NSObject<RhythmVideoController> *)videoController
    playbackResumedForIndexPath:(NSIndexPath *)indexPath;

-(void)controller:(NSObject<RhythmVideoController> *)videoController
    playbackPausedForIndexPath:(NSIndexPath *)indexPath;

-(void)controller:(NSObject<RhythmVideoController> *)videoController
    playbackStoppedForIndexPath:(NSIndexPath *)indexPath;

/*!
 Called when the user clicks the "previous" video control button.
 */
-(void)prevButtonClicked:(NSObject<RhythmVideoController> *)videoController
            forIndexPath:(NSIndexPath *)indexPath;

/*!
 Called when the user clicks the "play/pause" video control button.
 */
-(void)playPauseButtonClicked:(NSObject<RhythmVideoController> *)videoController
                 forIndexPath:(NSIndexPath *)indexPath;

/*!
 Called when the user clicks the "next" video control button.
 */
-(void)nextButtonClicked:(NSObject<RhythmVideoController> *)videoController
            forIndexPath:(NSIndexPath *)indexPath;

/*!
 Called when the user click the "done" video control button.
 */
-(void)doneButtonClicked:(NSObject<RhythmVideoController> *)videoController
            forIndexPath:(NSIndexPath *)indexPath;

/*!
 Called right after the fullscreen mode is changed. videoController.fullscreen indicates the new mode.
 */
-(void)fullscreenModeChanged:(NSObject<RhythmVideoController> *)videoController;

// ---------------------------------------------------------------------------
#pragma mark -
#pragma mark bumpers

/*!
 Called just before the bumper view will be displayed to the user.

 This is called only if bumperViewForContentIndex: for this contentIndex has
 been implemented and returned non-nil.
 */
-(void)bumperWillAppear:(UIView *)bumperView forIndexPath:(NSIndexPath *)indexPath;

/*!
 Called just after the bumper was displayed to the user.

 This is called only if bumperViewForContentIndex: for this contentIndex has
 been implemented and returned non-nil.
 */
-(void)bumperDidAppear:(UIView *)bumperView forIndexPath:(NSIndexPath *)indexPath;

/*!
 Called just before the bumper view will be removed from view.

 This is called only if bumperViewForContentIndex: for this contentIndex has
 been implemented and returned non-nil.
*/
-(void)bumperWillDisappear:(UIView *)bumperView forIndexPath:(NSIndexPath *)indexPath;

/*!
 Called just after the bumper view was removed from view.

 This is called only if bumperViewForContentIndex: for this contentIndex has
 been implemented and returned non-nil.
*/
-(void)bumperDidDisappear:(UIView *)bumperView forIndexPath:(NSIndexPath *)indexPath;

/*!
 The view to display when the Rhythm player is active
 (i.e. the play method has been called), but video
 is in the process of buffering from the server.
 If not set, the Rhythm SDK will show the standard
 media player "loading" screen.
 */
-(UIView *)bumperViewForIndexPath:(NSIndexPath *)indexPath;

/*!
 Number of seconds that the bumper should be displayed before the next video
 begins its preloading. You can implement this to keep your bumper on the
 screen for some minimum duration of time.
 
 Default behavior if this is not implemented (or returns a non-positive number)
 is to show the bumper only while the next video is preloading (which can take
 varying amounts of time depending on the video length and network conditions).
 
 This is called only if bumperViewForContentIndex: for this contentIndex has
 been implemented and returned non-nil.
 */
-(NSTimeInterval)bumperViewDurationForIndexPath:(NSIndexPath *)indexPath;

/*!
 Animation style when showing a bumper. By default, bumpers will fade in.
 
 This is called only if bumperViewForContentIndex: for this contentIndex has
 been implemented and returned non-nil.
 */
-(RhythmBumperAnimationType)bumperViewShowAnimationTypeForIndexPath:(NSIndexPath *)indexPath;

/*!
 Animation style when hiding a bumper. By default, bumpers will fade out.
 
 This is called only if bumperViewForContentIndex: for this contentIndex has
 been implemented and returned non-nil.
 */
-(RhythmBumperAnimationType)bumperViewHideAnimationTypeForIndexPath:(NSIndexPath *)indexPath;


// ---------------------------------------------------------------------------
#pragma mark -
#pragma mark clip browser callbacks

-(void)controller:(NSObject<RhythmVideoController> *)videoController
   viewWillDisplayInClipBrowser:(UIView *)view;

-(void)controller:(NSObject<RhythmVideoController> *)videoController
  clipBrowserThumbnailTappedAtIndexPath:(NSIndexPath *)indexPath;

@end
