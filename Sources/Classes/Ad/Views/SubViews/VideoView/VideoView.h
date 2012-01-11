//
//  VideoView.h
//  AdMobileSDK
//
//  Created by Constantine Mureev on 3/28/11.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

#import "TouchableViewController.h"
#import "NotificationCenter.h"


@interface VideoView : UIView <TouchableViewDelegate> {
	NSURLRequest					*_request;
	NSString						*_videoUrl;
	TouchableViewController			*_touchableViewController;
	MPMoviePlayerController			*_player;
	
	BOOL							_videoPlaying;
}

@property (readonly) NSString* videoUrl;

- (void)showWithUrl:(NSString*)videoUrl request:(NSURLRequest *)request;
- (void)updateRequest:(NSURLRequest*)request;

- (void) play;
- (void) pause;

@end
