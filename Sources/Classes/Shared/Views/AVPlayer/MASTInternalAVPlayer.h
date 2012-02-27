//
//  MASTInternalAVPlayer.h
//


#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface MASTInternalAVPlayer : NSObject

+ (MASTInternalAVPlayer*)sharedInstance;
- (void)playAudio:(NSNotification*)notification;
- (void)playVideo:(NSNotification*)notification;

@end
