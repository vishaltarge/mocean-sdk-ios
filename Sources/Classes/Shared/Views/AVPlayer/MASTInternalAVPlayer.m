//
//  AVPlayer.m
//  AdMobileSDK
//
//  Created by Constantine Mureev on 3/3/11.
//

#import "MASTInternalAVPlayer.h"
#import "MASTNotificationCenter.h"
#import "MASTAdView.h"
#import "MASTUIViewAdditions.h"
#include <objc/runtime.h>


@interface MASTInternalAVPlayer ()

@property (assign, getter = isOpening) BOOL opening;
@property (assign, getter = isAudio) BOOL audio;
@property (assign, getter = isStatusBarHidden) BOOL statusBarHidden;

@property (assign, getter = isAutoplay) BOOL autoplay;
@property (assign, getter = isExitOnComplete) BOOL exitOnComplete;
@property (assign, getter = isInline) BOOL Inline;

@property (assign) UIStatusBarStyle oldStyle;
@property (retain) MPMoviePlayerViewController *avPlayer;
@property (retain) MPMoviePlayerController* avPlayerController;
@property (assign) UIViewController*    viewConreoller;
@property (assign) MASTAdView*    adView;

- (void)registerObserver;
- (void)playAudio:(NSNotification*)notification;
- (void)playVideo:(NSNotification*)notification;
- (void)moviePlayerLoadStateChanged:(NSNotification*)notification;
- (void)moviePlayBackDidFinish:(NSNotification*)notification;

- (void)playAudio:(NSURL*)audioURL autoPlay:(BOOL)autoplay showControls:(BOOL)showcontrols repeat:(BOOL)autorepeat playInline:(BOOL)Inline fullScreenMode:(BOOL)fullScreen autoExit:(BOOL)exit;
- (void)playVideo:(NSURL*)videoURL autoPlay:(BOOL)autoplay showControls:(BOOL)showcontrols repeat:(BOOL)autorepeat fullScreenMode:(BOOL)fullScreen autoExit:(BOOL)exit;

@end

@implementation MASTInternalAVPlayer

@synthesize opening, audio, statusBarHidden, autoplay, exitOnComplete, Inline, oldStyle, avPlayer, avPlayerController, viewConreoller, adView;

- (id)init {
    self = [super init];
    if (self) {
        self.opening = NO;
        
        [self registerObserver];
    }
    return self;
}

- (void)registerObserver {
	[[MASTNotificationCenter sharedInstance] addObserver:self selector:@selector(playAudio:) name:kPlayAudioNotification object:nil];
	[[MASTNotificationCenter sharedInstance] addObserver:self selector:@selector(playVideo:) name:kPlayVideoNotification object:nil];
}

+ (MASTInternalAVPlayer*)sharedInstance {
    static dispatch_once_t once;
    static MASTInternalAVPlayer* sharedInstance;
    dispatch_once(&once, ^ { sharedInstance = [self new]; });
    return sharedInstance;
}

- (void)playAudio:(NSNotification*)notification {
    if (!self.opening) {
        NSDictionary *info = [notification object];
        NSString* url = [info objectForKey:@"url"];
        NSDictionary* properties = [info objectForKey:@"properties"];
        
        if (url && properties) {
            self.opening = YES;
            self.adView = [info objectForKey:@"adView"];
            
            NSNumber* number_autoPlay = [properties objectForKey:@"autoPlay"];
            BOOL autoPlay = YES;
            if (number_autoPlay) {
                autoPlay = [number_autoPlay  boolValue];
            }
            
            NSNumber* number_showControls = [properties objectForKey:@"showControls"];
            BOOL showControls = YES;
            if (number_showControls) {
                showControls = [number_showControls  boolValue];
            }
            
            NSNumber* number_repeat = [properties objectForKey:@"repeat"];
            BOOL repeat = NO;
            if (number_repeat) {
                repeat = [number_repeat  boolValue];
            }
            
            NSNumber* number_playInline = [properties objectForKey:@"playInline"];
            BOOL playInline = NO;
            if (number_playInline) {
                playInline = [number_playInline  boolValue];
            }
            
            NSNumber* number_fullScreenMode = [properties objectForKey:@"fullScreenMode"];
            BOOL fullScreenMode = NO;
            if (number_fullScreenMode) {
                fullScreenMode = [number_fullScreenMode  boolValue];
            }
            
            NSNumber* number_autoExit = [properties objectForKey:@"autoExit"];
            BOOL autoExit = YES;
            if (number_autoExit) {
                autoExit = [number_autoExit  boolValue];
            }
            
            [self playAudio:[NSURL URLWithString:url] autoPlay:autoPlay showControls:showControls repeat:repeat playInline:playInline fullScreenMode:fullScreenMode autoExit:autoExit];
        }
    }
}

- (void)playVideo:(NSNotification*)notification {
    if (!self.opening) {
        NSDictionary *info = [notification object];
        NSString* url = [info objectForKey:@"url"];
        NSDictionary* properties = [info objectForKey:@"properties"];
        
        if (url && properties) {
            self.opening = YES;
            self.adView = [info objectForKey:@"adView"];
            
            NSNumber* number_autoPlay = [properties objectForKey:@"autoPlay"];
            BOOL autoPlay = YES;
            if (number_autoPlay) {
                autoPlay = [number_autoPlay  boolValue];
            }
            
            NSNumber* number_showControls = [properties objectForKey:@"showControls"];
            BOOL showControls = YES;
            if (number_showControls) {
                showControls = [number_showControls  boolValue];
            }
            
            NSNumber* number_repeat = [properties objectForKey:@"repeat"];
            BOOL repeat = NO;
            if (number_repeat) {
                repeat = [number_repeat  boolValue];
            }
            
            NSNumber* number_playInline = [properties objectForKey:@"playInline"];
            //BOOL playInline = NO;
            if (number_playInline) {
                //playInline = [number_playInline  boolValue];
            }
            
            NSNumber* number_fullScreenMode = [properties objectForKey:@"fullScreenMode"];
            BOOL fullScreenMode = NO;
            if (number_fullScreenMode) {
                fullScreenMode = [number_fullScreenMode  boolValue];
            }
            
            NSNumber* number_autoExit = [properties objectForKey:@"autoExit"];
            BOOL autoExit = YES;
            if (number_autoExit) {
                autoExit = [number_autoExit  boolValue];
            }
            
            [self playVideo:[NSURL URLWithString:url] autoPlay:autoPlay showControls:showControls repeat:repeat fullScreenMode:fullScreenMode autoExit:autoExit];
        }
    }

}

- (void)playAudio:(NSURL*)audioURL autoPlay:(BOOL)autoplayArg showControls:(BOOL)showcontrols repeat:(BOOL)autorepeat playInline:(BOOL)InlineArg fullScreenMode:(BOOL)fullScreen autoExit:(BOOL)autoExit {
    self.audio = YES;
	self.oldStyle = [UIApplication sharedApplication].statusBarStyle;

	self.avPlayer = [[[MPMoviePlayerViewController alloc] initWithContentURL:audioURL] autorelease];
	self.avPlayerController = avPlayer.moviePlayer;	

	self.avPlayerController.controlStyle = showcontrols ? MPMovieControlStyleFullscreen : MPMovieControlStyleNone;
	self.avPlayerController.repeatMode = autorepeat ? MPMovieRepeatModeOne : MPMovieRepeatModeNone;	
	self.avPlayerController.shouldAutoplay = autoplayArg;
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(moviePlayerLoadStateChanged:) 
												 name:MPMoviePlayerLoadStateDidChangeNotification 
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(moviePlayBackDidFinish:) 
												 name:MPMoviePlayerPlaybackDidFinishNotification 
											   object:nil];	
	[self.avPlayerController prepareToPlay];
    
	self.autoplay = autoplayArg;
	self.exitOnComplete = autoExit;
	self.Inline = InlineArg;
    
    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    if (vc) {
        self.viewConreoller = vc;
    } else {
        vc = [self.adView viewControllerForView];
        if (vc) {
            self.viewConreoller = vc;
        }
    }
    
    [self.viewConreoller presentModalViewController:self.avPlayer animated:YES];
}

- (void)playVideo:(NSURL*)videoURL autoPlay:(BOOL)autoplayArg showControls:(BOOL)showcontrols repeat:(BOOL)autorepeat fullScreenMode:(BOOL)fullScreen autoExit:(BOOL)autoExit {
    self.audio = NO;
	self.oldStyle = [UIApplication sharedApplication].statusBarStyle;
    
	self.avPlayer = [[[MPMoviePlayerViewController alloc] initWithContentURL:videoURL] autorelease];
	self.avPlayerController = avPlayer.moviePlayer;	
	self.avPlayerController.scalingMode = MPMovieScalingModeAspectFit;

	self.avPlayerController.controlStyle = showcontrols ? MPMovieControlStyleFullscreen : MPMovieControlStyleNone;
	self.avPlayerController.repeatMode = autorepeat ? MPMovieRepeatModeOne : MPMovieRepeatModeNone;	
	self.avPlayerController.shouldAutoplay = autoplayArg;
	
	self.statusBarHidden = [[UIApplication sharedApplication] isStatusBarHidden];
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(moviePlayerLoadStateChanged:) 
												 name:MPMoviePlayerLoadStateDidChangeNotification 
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(moviePlayBackDidFinish:) 
												 name:MPMoviePlayerPlaybackDidFinishNotification 
											   object:nil];
	[self.avPlayerController prepareToPlay];
	self.autoplay = autoplayArg;
	self.exitOnComplete = autoExit;
	self.Inline = NO;
    
    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    if (vc) {
        self.viewConreoller = vc;
    } else {
        vc = [self.adView viewControllerForView];
        if (vc) {
            self.viewConreoller = vc;
        }
    }
    
    [self.viewConreoller presentModalViewController:self.avPlayer animated:YES];
}

- (void)moviePlayerLoadStateChanged:(NSNotification*)notification {
	if ([self.avPlayerController loadState] != MPMovieLoadStateUnknown) {
		[[NSNotificationCenter 	defaultCenter] removeObserver:self 
														 name:MPMoviePlayerLoadStateDidChangeNotification 
													   object:nil];
		
        if (!self.isStatusBarHidden && !self.isAudio)  {
            [[UIApplication sharedApplication] setStatusBarHidden:YES];
        }
		
		if (self.autoplay) {
			// Play the movie
			[self.avPlayerController play];			
		}

        /*
		if (!self.isInline) {
			UIWindow* window = [[UIApplication sharedApplication] keyWindow];
			[window addSubview:ormmaPlayer.view];	
			[window bringSubviewToFront:ormmaPlayer.view];			
		}
         */
	} else {
        [self.viewConreoller dismissModalViewControllerAnimated:YES];
        [[MASTNotificationCenter sharedInstance] postNotificationName:@"Player received unknown error" object:nil];
	}
}

- (void)moviePlayBackDidFinish:(NSNotification*)notification {
    self.opening = NO;
    /*
	NSDictionary* userinfo = [notification userInfo];
	NSLog(@"%@",userinfo);
	NSNumber* status = [userinfo objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
	if ([status intValue] == MPMovieFinishReasonPlaybackError) 
	{
		
		[ormmaPlayer release];
		ormmaPlayer = nil;
        
        
        
        
        
        
		if(self.delegate)
		{
			[self.delegate playerCompleted];
		}	
        
        
        
        
        
		[[NSNotificationCenter defaultCenter] removeObserver:self];
	} else if ([status intValue] == MPMovieFinishReasonUserExited || (exitOnComplete && [status intValue] == MPMovieFinishReasonPlaybackEnded)) {
		[[NSNotificationCenter defaultCenter] removeObserver:self];
		
		[ormmaPlayer stop];
		if (!inlinePlayer) 
		{
			[ormmaPlayer.view removeFromSuperview];			
		}
		if (!statusBarAvailable) 
        {
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
            [[UIApplication sharedApplication] setStatusBarStyle:oldStyle];
        }
		ormmaPlayer.initialPlaybackTime = -1;
		[ormmaPlayer release];
		ormmaPlayer = nil;
        
        
        
        
		if(self.delegate)
		{
			[self.delegate playerCompleted];
		}
	}*/
}

- (void)dealloc {
    [super dealloc];
}

@end
