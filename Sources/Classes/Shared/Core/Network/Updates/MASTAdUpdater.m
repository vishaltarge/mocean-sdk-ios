//
//  AdUpdater.m
//  AdMobileSDK
//
//  Created by Constantine Mureev on 3/9/11.
//

#import "MASTAdUpdater.h"

#import "MASTNotificationCenter.h"
#import "MASTNotificationCenterAdditions.h"
#import "MASTAdView.h"

@interface MASTAdUpdater (PrivateMethods)

- (void)sendUpdate:(NSTimer*)timer;
- (void)startTimerOnMainThread;

- (void)start:(NSNotification*)notification;
- (void)stop:(NSNotification*)notification;
- (void)updateNow:(NSNotification*)notification;

- (void)updateTimeInterval:(NSNotification*)notification;
- (void)startTimer:(NSNotification*)notification;

- (void)viewVisible:(NSNotification*)notification;
- (void)viewInvisible:(NSNotification*)notification;

@end


@implementation MASTAdUpdater

@synthesize updateTimer, updateTimeInterval;
@synthesize adView = _adView;

- (id)init {
	self = [super init];
	if (self) {
		_updateStarted = NO;
        _viewVisible = NO;
        _valid = YES;
		
		[[MASTNotificationCenter sharedInstance] addObserver:self selector:@selector(start:) name:kAdStartUpdateNotification object:nil];
		[[MASTNotificationCenter sharedInstance] addObserver:self selector:@selector(stop:) name:kAdStopUpdateNotification object:nil];
		[[MASTNotificationCenter sharedInstance] addObserver:self selector:@selector(updateNow:) name:kAdUpdateNowNotification object:nil];
		[[MASTNotificationCenter sharedInstance] addObserver:self selector:@selector(updateTimeInterval:) name:kAdChangeUpdateTimeIntervalNotification object:nil];
		[[MASTNotificationCenter sharedInstance] addObserver:self selector:@selector(viewVisible:) name:kAdViewBecomeVisibleNotification object:nil];
		[[MASTNotificationCenter sharedInstance] addObserver:self selector:@selector(viewInvisible:) name:kAdViewBecomeInvisibleNotification object:nil];
        
        [[MASTNotificationCenter sharedInstance] addObserver:self selector:@selector(startTimer:) name:kFinishAdDownloadNotification object:nil];
        [[MASTNotificationCenter sharedInstance] addObserver:self selector:@selector(startTimer:) name:kFailAdDownloadNotification object:nil];
        //[[NotificationCenter sharedInstance] addObserver:self selector:@selector(startTimer:) name:kCancelAdDownloadNotification object:nil];
        
        kFinishAdDownloadNotification;
        kFailAdDownloadNotification;
        kCancelAdDownloadNotification;
	}
	
	return self;
}

- (void)dealloc {
	[super dealloc];
}

- (void)start:(NSNotification*)notification {
	MASTAdView* adViewNotify = [notification object];
    if (adViewNotify == self.adView) {
        @synchronized(self) {
            // update timeInterval
            MASTAdModel* adModel = [adViewNotify adModel];
            self.updateTimeInterval = adModel.updateTimeInterval;
            
            if (!_updateStarted) {
                _updateStarted = YES;
                
                [self performSelectorOnMainThread:@selector(startTimerOnMainThread) withObject:nil waitUntilDone:NO];
            }
        }
    }
}

- (void)stop:(NSNotification*)notification {
	MASTAdView* adViewNotify = [notification object];
    if (adViewNotify == self.adView) {
        @synchronized(self) {
            if (_updateStarted) {
                _updateStarted = NO;
                
                // stop timer
                if (self.updateTimer && [self.updateTimer respondsToSelector:@selector(isValid)] && [self.updateTimer isValid]) {
                    [self.updateTimer invalidate];
                    self.updateTimer = nil;
                }
            }
        }
    }
}

- (void)updateNow:(NSNotification*)notification {
	MASTAdView* adViewNotify = [notification object];
    if (adViewNotify == self.adView) {
        @synchronized(self) {
            // try stop timer
            if (self.updateTimer && [self.updateTimer respondsToSelector:@selector(isValid)] && [self.updateTimer isValid]) {
                [self.updateTimer invalidate];
                self.updateTimer = nil;
            }
            
            [[MASTNotificationCenter sharedInstance] postNotificationName:kAdCancelUpdateNotification object:self.adView];
            [[MASTNotificationCenter sharedInstance] postNotificationName:kStartAdDownloadNotification object:self.adView];
        }
    }
}


- (void)updateTimeInterval:(NSNotification*)notification {
	MASTAdView* adViewNotify = [notification object];
    if (adViewNotify == self.adView) {
        @synchronized(self) {
            // update timeInterval
            MASTAdModel* adModel = [adViewNotify adModel];

            self.updateTimeInterval = adModel.updateTimeInterval;
            
            if (!_updateStarted) {
                NSNotification* startNotification = [NSNotification notificationWithName:kAdStartUpdateNotification object:self.adView];
                [self start:startNotification];
            }
            else if (_viewVisible) {                
                // stop timer
                if (self.updateTimer && [self.updateTimer respondsToSelector:@selector(isValid)] && [self.updateTimer isValid]) {
                    [self.updateTimer invalidate];
                    self.updateTimer = nil;
                }
                
                // start timer
                self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:self.updateTimeInterval
                                                                    target:self
                                                                  selector:@selector(sendUpdate:)
                                                                  userInfo:nil
                                                                   repeats:NO];
            }
        }
    }
}

- (void)startTimer:(NSNotification*)notification {
    NSDictionary *info = [notification object];
	MASTAdView* adViewNotify = [info objectForKey:@"adView"];
    if (adViewNotify == self.adView && self.updateTimeInterval > 0) {
        @synchronized(self) {
            // update timeInterval
            MASTAdModel* adModel = [adViewNotify adModel];
            self.updateTimeInterval = adModel.updateTimeInterval;
            
            if (_updateStarted && _viewVisible) {
                [self performSelectorOnMainThread:@selector(startTimerOnMainThread) withObject:nil waitUntilDone:NO];
            }
        }
    }
}

- (void)sendUpdate:(NSTimer*)timer {
	@synchronized(self) {
        if (_valid) {
            MASTAdModel* adModel = [self.adView adModel];
            if ( adModel.latitude == nil && adModel.longitude == nil )
            {
#ifdef INCLUDE_LOCATION_MANAGER
                if ([LocationManager sharedInstance].currentLocationCoordinate.longitude == 0 &&
                     [LocationManager sharedInstance].currentLocationCoordinate.latitude == 0)
                {
                    [[LocationManager sharedInstance] startUpdatingLocation];                    
                }
#endif
            }
            [[MASTNotificationCenter sharedInstance] postNotificationName:kStartAdDownloadNotification object:self.adView];
        }
	}
}

- (void)startTimerOnMainThread {
    if (_viewVisible) {                
        // stop timer
        if (self.updateTimer && [self.updateTimer respondsToSelector:@selector(isValid)] && [self.updateTimer isValid]) {
            [self.updateTimer invalidate];
            self.updateTimer = nil;
        }
        
        // start timer
        self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:self.updateTimeInterval
                                                            target:self
                                                          selector:@selector(sendUpdate:)
                                                          userInfo:nil
                                                           repeats:NO];
    }
}

- (void)invalidate {
    @synchronized(self) {
        _valid = NO;
        [[MASTNotificationCenter sharedInstance] removeObserver:self];
        NSNotification* stopNotification = [NSNotification notificationWithName:kAdStopUpdateNotification object:self.adView];
        [self stop:stopNotification];
	}
}

- (void)viewVisible:(NSNotification*)notification {
	MASTAdView* adViewNotify = [notification object];
    if (adViewNotify == self.adView) {
		@synchronized(self) {
            _viewVisible = YES;
            
            if (_updateStarted) {
                [self performSelectorOnMainThread:@selector(startTimerOnMainThread) withObject:nil waitUntilDone:NO];
            }
        }
	}
}

- (void)viewInvisible:(NSNotification*)notification {
	MASTAdView* adViewNotify = [notification object];
    if (adViewNotify == self.adView) {
		@synchronized(self) {
            _viewVisible = NO;
            
            if (_updateStarted) {
                // stop timer
                if (self.updateTimer && [self.updateTimer respondsToSelector:@selector(isValid)] && [self.updateTimer isValid]) {
                    [self.updateTimer invalidate];
                    self.updateTimer = nil;
                }
            }
        }
	}
}



@end
