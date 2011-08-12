//
//  GreystripeAdaptor.m
//  AdMobileSDK
//
//  Created by Constantine Mureev on 4/6/11.
//

#import "GreystripeAdaptor.h"


@implementation GreystripeAdaptor


- (void) showWithAppID:(NSString*)appId {
#ifdef INCLUDE_GREYSTRIPE
    _firstDealloc = YES;
    _loaded = NO;
    [GreystripeSharedAdaptor sharedInstance].delegate = self;
    adView = [[GreystripeSharedAdaptor sharedInstance] adViewWithAppId:appId frame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    if (adView) {
        if ([adView superview]) {
            [adView removeFromSuperview];
        }
        [self addSubview:adView];
    }
#endif
}

// hook
- (void)release {
#ifdef INCLUDE_GREYSTRIPE
    int rc = [self retainCount];
    if (rc == 1 && _firstDealloc) {
        _firstDealloc = NO;
        [GreystripeSharedAdaptor sharedInstance].delegate = nil;
        [self performSelector:@selector(release) withObject:nil afterDelay:1];
    }
    else {
        [super release];
    }
#endif
}

- (void)dealloc {
#ifdef INCLUDE_GREYSTRIPE
    [GreystripeSharedAdaptor sharedInstance].delegate = nil;
	[adView release];
#endif
    [super dealloc];
}

- (void)update {
#ifdef INCLUDE_GREYSTRIPE
    if (_loaded) {
        [adView refresh];
    }
#endif
}

#ifdef INCLUDE_GREYSTRIPE

#pragma mark 
#pragma mark Greystripe delegate


- (void)greystripeAdReadyForSlotNamed:(NSString *)a_name {
    _loaded = YES;
    if (self.superview && _firstDealloc) {
        NSMutableDictionary* senfInfo = [NSMutableDictionary dictionary];
        [senfInfo setObject:self.superview forKey:@"adView"];
        [senfInfo setObject:self forKey:@"subView"];
        [[NotificationCenter sharedInstance] postNotificationName:kReadyAdDisplayNotification object:senfInfo];
    }
}

- (void)greystripeFullScreenDisplayWillOpen {
    if (self.superview && _firstDealloc) {
        // track url        
        [[NotificationCenter sharedInstance] postNotificationName:kTrackUrlNotification object:self.superview];
        
        // send callback
        NSMutableDictionary* sendInfo = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:self.superview, nil]
                                                                           forKeys:[NSArray arrayWithObjects:@"adView", nil]];
        
        [[NotificationCenter sharedInstance] postNotificationName:kOpenInternalBrowserNotification object:sendInfo];
    }
}

- (void)greystripeFullScreenDisplayWillClose {
    if (self.superview && _firstDealloc) {
        [[NotificationCenter sharedInstance] postNotificationName:kCloseInternalBrowserNotification object:self.superview];
    }
}

#endif

@end