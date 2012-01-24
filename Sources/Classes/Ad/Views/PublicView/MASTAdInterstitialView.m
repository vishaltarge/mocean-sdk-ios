//
//  AdInterstitialView.m
//  AdMobileSDK
//
//  Created by Constantine Mureev on 2/24/11.
//

#import "MASTAdInterstitialView.h"
#import "MASTAdView_Private.h"
#import "MASTAdDescriptor.h"
#import "MASTReachability.h"

#import "MASTNotificationCenter.h"

#import "MASTAdWebView.h"

#define kCloseButtonText @"Close"

@interface MASTAdInterstitialView ()

- (void)showCloseButton;
- (void)scheduledButtonAction;
- (void)buttonsAction:(id)sender;
- (void)closeInterstitial:(NSNotification*)notification;
- (void)stopEverythingAndNotfiyDelegateOnCleanup;

@end


@implementation MASTAdInterstitialView

@dynamic delegate, showCloseButtonTime, autocloseInterstitialTime, closeButton;

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
        // Initialization code.
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
			   site:(NSInteger)site
			   zone:(NSInteger)zone {
	self = [super initWithFrame:frame site:site zone:zone];
    if (self) {
    }
    return self;
}

- (void)stopEverythingAndNotfiyDelegateOnCleanup {
    [super stopEverythingAndNotfiyDelegateOnCleanup];
    
    [self scheduledButtonAction];
}

- (void)dealloc {
    self.delegate = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Private


- (void)setDefaultValues {
    [super setDefaultValues];
}

- (void)registerObserver {
    // start interstitial ad only if internet available      
    [super registerObserver];
    [[MASTNotificationCenter sharedInstance] addObserver:self selector:@selector(buttonsAction:) name:kInvalidParamsServerResponseNotification object:nil];
    [[MASTNotificationCenter sharedInstance] addObserver:self selector:@selector(buttonsAction:) name:kEmptyServerResponseNotification object:nil];
    [[MASTNotificationCenter sharedInstance] addObserver:self selector:@selector(buttonsAction:) name:kFailAdDisplayNotification object:nil];
    [[MASTNotificationCenter sharedInstance] addObserver:self selector:@selector(buttonsAction:) name:kFailAdDownloadNotification object:nil];
    [[MASTNotificationCenter sharedInstance] addObserver:self selector:@selector(closeInterstitial:) name:kInterstitialAdCloseNotification object:nil];
}

- (void)dislpayAd:(NSNotification*)notification {
	NSDictionary *info = [notification object];
	MASTAdView* adView = [info objectForKey:@"adView"];
	UIView* subView = [info objectForKey:@"subView"];
    NSString* contentWidth = [info objectForKey:@"contentWidth"];
    NSString* contentHeight = [info objectForKey:@"contentHeight"];
	
	if (adView == self) {
        MASTAdModel* model = [self adModel];
        UIView* currentAdView = model.currentAdView;
        if (subView != currentAdView) {            
            UIView *oldView = currentAdView;
            [self adModel].snapshotRAWData = nil;
            
            model.currentAdView = subView;
            subView.hidden = NO;
            
            // update content size if possible
            if (contentHeight && contentWidth) {
                model.contentSize = CGSizeMake([contentWidth floatValue], [contentHeight floatValue]);
            } else {
                model.contentSize = CGSizeZero;
            }
            
            // switch animation
            if (model.animateMode && currentAdView && subView) {
                CGRect prevAdFrame = subView.frame;
                CGRect startAdFrame = CGRectMake(prevAdFrame.origin.x-prevAdFrame.size.width, prevAdFrame.origin.y, prevAdFrame.size.width, prevAdFrame.size.height);
                subView.frame = startAdFrame;
                subView.alpha = 0.3;
                
                [UIView animateWithDuration:0.2 animations:^{
                    subView.frame = prevAdFrame;
                    CGRect newFrameForOldImage = CGRectMake(prevAdFrame.origin.x+prevAdFrame.size.width, prevAdFrame.origin.y, prevAdFrame.size.width, prevAdFrame.size.height);
                    currentAdView.frame = newFrameForOldImage;
                    subView.alpha = 1.0;
                    currentAdView.alpha = 0.3;
                } completion:^(BOOL finished) {
                    [oldView removeFromSuperview];
                }];
            } else if (oldView) {
                [oldView removeFromSuperview];
            }
            
            // Close button code
            if (!self.closeButton) {
                [self prepareResources];
                
                self.closeButton.frame = CGRectMake(self.frame.size.width - self.closeButton.frame.size.width - 11, 11, self.closeButton.frame.size.width, self.closeButton.frame.size.height);
                self.closeButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
                
                self.closeButton.hidden = YES;
                
                [self addSubview:self.closeButton];
                if (((MASTAdModel*)_adModel).showCloseButtonTime > 0 && !((MASTAdModel*)_adModel).isDisplayed) {
                    [NSTimer scheduledTimerWithTimeInterval:((MASTAdModel*)_adModel).showCloseButtonTime
                                                     target:self 
                                                   selector:@selector(showCloseButton)
                                                   userInfo:nil 
                                                    repeats:NO];
                }
                else {
                    [self showCloseButton];
                }
                if (((MASTAdModel*)_adModel).autocloseInterstitialTime > 0) {
                    [NSTimer scheduledTimerWithTimeInterval:((MASTAdModel*)_adModel).autocloseInterstitialTime
                                                     target:self 
                                                   selector:@selector(scheduledButtonAction) 
                                                   userInfo:nil 
                                                    repeats:NO];
                }
            } else if (self.closeButton) {
                [self bringSubviewToFront:self.closeButton];
            }
            
            if (!((MASTAdModel*)_adModel).isDisplayed) {
                ((MASTAdModel*)_adModel).startDisplayDate = [NSDate date];
                ((MASTAdModel*)_adModel).isDisplayed = YES;
            }
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [[MASTNotificationCenter sharedInstance] postNotificationName:kAdDisplayedNotification object:self];
            });
        }
	}
}

- (void)showCloseButton {
	self.closeButton.hidden = NO;
}

- (void)scheduledButtonAction {
	[self performSelectorOnMainThread:@selector(buttonsAction:) withObject:self waitUntilDone:YES];
}

- (void)buttonsAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClosedAd:usageTimeInterval:)]) {
        NSDate* _startDate = ((MASTAdModel*)_adModel).startDisplayDate;
        NSTimeInterval timeInterval = -[_startDate timeIntervalSinceNow];
        [self.delegate didClosedAd:self usageTimeInterval:timeInterval];
    } else {
        if (self.superview && self.window) {
            if ([sender isKindOfClass:[NSNotification class]]) {
                NSNotification* notification = sender;
                if ([notification object] == self) {
                    [[MASTNotificationCenter sharedInstance] postNotificationName:kInterstitialAdCloseNotification object:self];
                    self.hidden = YES;
                } else if ([[notification object] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary* info = [notification object];
                    MASTAdView* adView = [info objectForKey:@"adView"];
                    if (adView == self) {
                        [[MASTNotificationCenter sharedInstance] postNotificationName:kInterstitialAdCloseNotification object:self];
                        self.hidden = YES;
                    }
                }
            } else {
                [[MASTNotificationCenter sharedInstance] postNotificationName:kInterstitialAdCloseNotification object:self];
                self.hidden = YES;
            }
        }
    }
}


#pragma mark -
#pragma mark Callback


//- (void) didClosedInterstitialAd:(id)sender usageTimeInterval:(NSTimeInterval)usageTimeInterval;
- (void)closeInterstitial:(NSNotification*)notification {
    MASTAdView* adView = [notification object];
	
	if (adView == self) {
        id <MASTAdViewDelegate> delegate = [self adModel].delegate;
        
        if (delegate && [delegate respondsToSelector:@selector(didClosedAd:usageTimeInterval:)]) {
            NSDate* _startDate = ((MASTAdModel*)_adModel).startDisplayDate;
            NSTimeInterval timeInterval = -[_startDate timeIntervalSinceNow];
            [delegate didClosedAd:self usageTimeInterval:timeInterval];
        }
    }
}


#pragma mark -
#pragma mark Propertys


// @property (assign) id <AdViewDelegate> delegate;
- (void)setDelegate:(id <MASTAdViewDelegate>)delegate {
	((MASTAdModel*)_adModel).delegate = delegate;
}

- (id <MASTAdViewDelegate>)delegate {
	return ((MASTAdModel*)_adModel).delegate;
}

//@property NSTimeInterval showCloseButtonTime;
- (void)setShowCloseButtonTime:(NSTimeInterval)timeInterval {
	((MASTAdModel*)_adModel).showCloseButtonTime = timeInterval;
}

- (NSTimeInterval)showCloseButtonTime {
	return ((MASTAdModel*)_adModel).showCloseButtonTime;
}

//@property NSTimeInterval autocloseInterstitialTime;
- (void)setAutocloseInterstitialTime:(NSTimeInterval)timeInterval {
	((MASTAdModel*)_adModel).autocloseInterstitialTime = timeInterval;
}

- (NSTimeInterval)autocloseInterstitialTime {
	return ((MASTAdModel*)_adModel).autocloseInterstitialTime;
}



@end
