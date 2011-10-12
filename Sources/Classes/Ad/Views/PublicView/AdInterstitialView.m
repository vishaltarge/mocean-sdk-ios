//
//  AdInterstitialView.m
//  AdMobileSDK
//
//  Created by Constantine Mureev on 2/24/11.
//

#import "AdInterstitialView.h"
#import "AdView_Private.h"
#import "AdDescriptor.h"
#import "Reachability.h"

#import "NotificationCenter.h"

#import "AdWebView.h"

#define kCloseButtonText @"Close"

@interface AdInterstitialView ()

- (void)showCloseButton;
- (void)scheduledButtonAction;
- (void)buttonsAction:(id)sender;
- (void)closeInterstitial:(NSNotification*)notification;

@end


@implementation AdInterstitialView

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


- (void)dealloc {
    self.delegate = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Private


- (void)setDefaultValues {
    [super setDefaultValues];
    
    ((AdModel*)_adModel).isDisplayed = NO;
}

- (void)registerObserver {
    // start interstitial ad only if internet available    
    Reachability* reachability = [Reachability reachabilityForInternetConnection];
    if ([reachability currentReachabilityStatus] != NotReachable) {        
        [super registerObserver];
        [[NotificationCenter sharedInstance] addObserver:self selector:@selector(buttonsAction:) name:kInvalidParamsServerResponseNotification object:nil];
        [[NotificationCenter sharedInstance] addObserver:self selector:@selector(buttonsAction:) name:kFailAdDisplayNotification object:nil];
        [[NotificationCenter sharedInstance] addObserver:self selector:@selector(closeInterstitial:) name:kInterstitialAdCloseNotification object:nil];
    }
}

- (void)dislpayAd:(NSNotification*)notification {
	NSDictionary *info = [notification object];
	AdView* adView = [info objectForKey:@"adView"];
	
	if (adView == self) {
        [super dislpayAd:notification];
		
		// Close button code
		UIButton* btnClose = ((AdModel*)_adModel).closeButton;
		if (!btnClose) {
			btnClose = [UIButton buttonWithType:UIButtonTypeRoundedRect];
			
			btnClose.frame = CGRectMake(self.frame.size.width/2 - 50,
										self.frame.size.height/2 - 50,
										100,
										50);
			[btnClose setTitle:kCloseButtonText forState:UIControlStateNormal];
			[btnClose setTitle:kCloseButtonText forState:UIControlStateHighlighted];
			((AdModel*)_adModel).closeButton = btnClose;
		}
		[btnClose addTarget:self action:@selector(buttonsAction:) forControlEvents:UIControlEventTouchUpInside];
		
		btnClose.hidden = YES;
		
		[self addSubview:btnClose];
		if (((AdModel*)_adModel).showCloseButtonTime > 0 && !((AdModel*)_adModel).isDisplayed) {
			[NSTimer scheduledTimerWithTimeInterval:((AdModel*)_adModel).showCloseButtonTime
											 target:self 
										   selector:@selector(showCloseButton)
										   userInfo:nil 
											repeats:NO];
		}
		else {
			[self showCloseButton];
		}
		if (((AdModel*)_adModel).autocloseInterstitialTime > 0) {
			[NSTimer scheduledTimerWithTimeInterval:((AdModel*)_adModel).autocloseInterstitialTime
											 target:self 
										   selector:@selector(scheduledButtonAction) 
										   userInfo:nil 
											repeats:NO];
		}
        
        if (!((AdModel*)_adModel).isDisplayed) {
            ((AdModel*)_adModel).startDisplayDate = [NSDate date];
            ((AdModel*)_adModel).isDisplayed = YES;
        }
	}
}

- (void)showCloseButton {
	((AdModel*)_adModel).closeButton.hidden = NO;
}

- (void)scheduledButtonAction {
	[self performSelectorOnMainThread:@selector(buttonsAction:) withObject:self waitUntilDone:YES];
}

- (void)buttonsAction:(id)sender {
    if (self.superview && self.window) {
        [[NotificationCenter sharedInstance] postNotificationName:kInterstitialAdCloseNotification object:self];
        [self removeFromSuperview];
    }
}


#pragma mark -
#pragma mark Callback


//- (void) didClosedInterstitialAd:(id)sender usageTimeInterval:(NSTimeInterval)usageTimeInterval;
- (void)closeInterstitial:(NSNotification*)notification {
    AdView* adView = [notification object];
	
	if (adView == self) {
        id <AdInterstitialViewDelegate> delegate = [self adModel].delegate;
        
        if (delegate && [delegate respondsToSelector:@selector(didClosedInterstitialAd:usageTimeInterval:)]) {
            NSDate* _startDate = ((AdModel*)_adModel).startDisplayDate;
            NSTimeInterval timeInterval = -[_startDate timeIntervalSinceNow];
            [delegate didClosedInterstitialAd:self usageTimeInterval:timeInterval];
        }
    }
}


#pragma mark -
#pragma mark Propertys


// @property (assign) id <AdViewDelegate> delegate;
- (void)setDelegate:(id <AdInterstitialViewDelegate>)delegate {
	((AdModel*)_adModel).delegate = delegate;
}

- (id <AdInterstitialViewDelegate>)delegate {
	return ((AdModel*)_adModel).delegate;
}

//@property NSTimeInterval showCloseButtonTime;
- (void)setShowCloseButtonTime:(NSTimeInterval)timeInterval {
	((AdModel*)_adModel).showCloseButtonTime = timeInterval;
}

- (NSTimeInterval)showCloseButtonTime {
	return ((AdModel*)_adModel).showCloseButtonTime;
}

//@property NSTimeInterval autocloseInterstitialTime;
- (void)setAutocloseInterstitialTime:(NSTimeInterval)timeInterval {
	((AdModel*)_adModel).autocloseInterstitialTime = timeInterval;
}

- (NSTimeInterval)autocloseInterstitialTime {
	return ((AdModel*)_adModel).autocloseInterstitialTime;
}

//@property (retain) UIButton* closeButton;
- (void)setCloseButton:(UIButton*)closeButton {
	((AdModel*)_adModel).closeButton = closeButton;
}

- (UIButton*)closeButton {
	return ((AdModel*)_adModel).closeButton;
}



@end
