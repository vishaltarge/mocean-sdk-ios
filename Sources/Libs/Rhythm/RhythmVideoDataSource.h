//  Copyright 2010 Rhythm NewMedia. All rights reserved.

enum {RhythmLongformChannel = -10};

@class RhythmClipBrowserConfiguration;

@protocol RhythmVideoController;

@protocol RhythmVideoDataSource<NSObject>

@required

-(NSInteger)videoController:(NSObject<RhythmVideoController> *)videoController
   numberOfContentsInChannel:(NSInteger)channelNum;

-(NSString *)videoController:(NSObject<RhythmVideoController> *)videoController
    URLForContentAtIndexPath:(NSIndexPath *)indexPath;

@optional

/*!
 Defaults to 1
 */
-(NSInteger)numberOfChannelsInVideoController:(NSObject<RhythmVideoController> *)videoController;

/*!
 Defaults to 0
 */
-(NSInteger)startingChannelNumberInVideoController:(NSObject<RhythmVideoController> *)videoController;

/*!
 Defaults to 0
 */
-(NSInteger)startingContentNumberInVideoController:(NSObject<RhythmVideoController> *)videoController;

// ---------------------------------------------------------------------------
#pragma mark -
#pragma mark clip browser

extern NSString* const kRhythmClipBrowserViewUpdated;

/*!
 Implement this and change any default values if desired
 */
-(void)configureClipBrowser:(RhythmClipBrowserConfiguration *)config;

/*!
 Defaults to "Channel <index>"
 */
-(NSString *)videoController:(NSObject<RhythmVideoController> *)videoController
               nameOfChannel:(NSInteger)channelNum;

/*!
 Defaults to nil (no title displayed)
 */
-(NSString *)videoController:(NSObject<RhythmVideoController> *)videoController
  titleForContentAtIndexPath:(NSIndexPath *)indexPath;

/*!
 Defaults to nil (meaning use the view returned by defaultThumbnail:)
 */
-(UIView *)videoController:(NSObject<RhythmVideoController> *)videoController
  thumbnailForContentAtIndexPath:(NSIndexPath *)indexPath;

/*!
 This is used if videoController:thumbnailForContentAtIndexPath: is not implemented
 or returns nil for a requested indexPath. If this also returns nil (the default),
 then an empty rectangle is displayed in place of the thumbnail.
 */
-(UIView *)defaultThumbnail:(NSObject<RhythmVideoController> *)videoController;

/*!
 This is the view to show in the clip browser info detail card
 when the user taps the "i" button. Defaults to nil, meaning the
 detail card will not be available.
 */
-(UIView *)videoController:(NSObject<RhythmVideoController> *)videoController
  detailViewForContentAtIndexPath:(NSIndexPath *)indexPath;

@end



// ---------------------------------------------------------------------------
// ---------------------------------------------------------------------------
// ---------------------------------------------------------------------------
#pragma mark -

@interface RhythmClipBrowserConfiguration : NSObject {
    UIColor *fadeColor;
    CGFloat fadeAlpha;
    CGSize thumbnailSize;
    int currentTitleFontSize;
    UIColor *currentTitleTextColor;
    int currentTitleHeight;
    BOOL showInfoButton;
    BOOL showReflections;
    
    CGSize detailCardSize;
    
    int channelListTextHeight;
    NSString *channelListFontName;
    UIColor *channelListFontColor;
    int channelListFontSize;
    UIColor *channelListHighlightFontColor;
    int channelListHighlightFontSize;
}

@property(nonatomic, retain) UIColor *fadeColor;
@property(nonatomic, assign) CGFloat fadeAlpha;
@property(nonatomic, assign) CGSize thumbnailSize;
@property(nonatomic, assign) int currentTitleFontSize;
@property(nonatomic, retain) UIColor *currentTitleTextColor;
@property(nonatomic, assign) int currentTitleHeight;
@property(nonatomic, assign) BOOL showInfoButton;
@property(nonatomic, assign) BOOL showReflections;

@property(nonatomic, assign) CGSize detailCardSize;

@property(nonatomic, assign) int channelListTextHeight;
@property(nonatomic, retain) NSString *channelListFontName;
@property(nonatomic, retain) UIColor *channelListFontColor;
@property(nonatomic, assign) int channelListFontSize;
@property(nonatomic, retain) UIColor *channelListHighlightFontColor;
@property(nonatomic, assign) int channelListHighlightFontSize;

@end
