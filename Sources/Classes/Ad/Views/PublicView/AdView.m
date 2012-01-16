//
//  AdView.m
//  AdMobileSDK
//
//  Created by Constantine Mureev on 2/22/11.
//

#import "AdView.h"
#import "AdView_Private.h"
#import "AdDescriptor.h"
#import "UIViewAdditions.h"
#import "Utils.h"
#import "QSStrings.h"

#import "NotificationCenter.h"
#import "LocationManager.h"

#import "AdWebView.h"
#import "VideoView.h"

#import "LocationManager.h"

@implementation AdView

@synthesize closeButton;
@dynamic adModel, uid;

@dynamic delegate, isLoading, testMode, logMode, animateMode, contentAlignment, track, updateTimeInterval,
defaultImage, site, zone, premium, type, keywords, minSize, maxSize, contentSize, textColor, additionalParameters,
adServerUrl, advertiserId, groupCode, country, region, city, area, metro, zip, carrier, latitude, longitude;


- (id)init {
	return nil;
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		_adModel = [AdModel new];
		((AdModel*)_adModel).adView = self;
		((AdModel*)_adModel).frame = frame;
		_observerSet = NO;
		
        [self registerObserver];
        [self setDefaultValues];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
			   site:(NSInteger)site
			   zone:(NSInteger)zone {
    
    self = [super initWithFrame:frame];
    if (self) {
		_adModel = [AdModel new];
		((AdModel*)_adModel).adView = self;
		((AdModel*)_adModel).frame = frame;
		_observerSet = NO;
		
		[self setSite:site];
		[self setZone:zone];
		
        [self registerObserver];
        [self setDefaultValues];
    }
    return self;
}

- (oneway void)release {
	if ([self retainCount] == 3 && _observerSet) {
        _observerSet = NO;
        [[NotificationCenter sharedInstance] postNotificationName:kUnregisterAdNotification object:self];
        [self removeObserver:self forKeyPath:@"frame"];
        [self removeObserver:self forKeyPath:@"hidden"];
        [[NotificationCenter sharedInstance] removeObserver:self];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [super release];
    }
    else if ([self retainCount] == 1 && ![NSThread isMainThread]) {
        [super performSelectorOnMainThread:@selector(release) withObject:nil waitUntilDone:NO];
    }
    else {
        [super release];
    }
}

- (void)dealloc {    
    // disable logging
    [self setLogMode:AdLogModeNone];
    self.closeButton = nil;
    
    ((AdModel*)_adModel).adView = nil;
    self.delegate = nil;
    RELEASE_SAFELY(_adModel);
    
    [super dealloc];
}


#pragma mark -
#pragma mark Public

- (void)callUpdateInBackground {
    NSAutoreleasePool* pool = [NSAutoreleasePool new];
    
    [[NotificationCenter sharedInstance] postNotificationName:kAdUpdateNowNotification object:self];
    
    [pool release];
}

- (void)update {
	//[[NotificationCenter sharedInstance] postNotificationName:kAdUpdateNowNotification object:self];
    [self performSelectorInBackground:@selector(callUpdateInBackground) withObject:nil];
}

- (void)stopEverythingAndNotfiyDelegateOnCleanup {
    //stop ad update and cancel all network proccess
    [_adModel cancelAllNetworkConnection];
    
    //close internal browser
    [_adModel closeInternalBrowser];
    
    //pause video view player
    [_adModel pauseVideoViewPlayer];
    
    //cloase ORMMA and set in default state
    [[NotificationCenter sharedInstance] postNotificationName:kORMMASetDefaultStateNotification object:nil];
}

#pragma mark -
#pragma mark Private

- (void)setDefaultValues {
    self.updateTimeInterval = 120; // 2min
    self.animateMode = YES;
    self.internalOpenMode = YES;
    self.testMode = NO;
    self.premium = AdPremiumBoth;
    
    [self setLogMode:AdLogModeErrorsOnly];
    
    ((AdModel*)_adModel).loading = NO;
    ((AdModel*)_adModel).track = -1;
    ((AdModel*)_adModel).aligmentCenter = NO;
    ((AdModel*)_adModel).isDisplayed = NO;
}

- (void)registerObserver {
    // callback
    [[NotificationCenter sharedInstance] addObserver:self selector:@selector(startAdDownload:) name:kGetAdServerResponseNotification object:nil];
    [[NotificationCenter sharedInstance] addObserver:self selector:@selector(adDisplayd:) name:kAdDisplayedNotification object:nil];
    [[NotificationCenter sharedInstance] addObserver:self selector:@selector(openInternalBrowser:) name:kOpenInternalBrowserNotification object:nil];
    [[NotificationCenter sharedInstance] addObserver:self selector:@selector(adShouldOpenBrowser:) name:kShouldOpenInternalBrowserNotification object:nil];
    [[NotificationCenter sharedInstance] addObserver:self selector:@selector(adShouldOpenExternalApp:) name:kShouldOpenExternalAppNotification object:nil];
    [[NotificationCenter sharedInstance] addObserver:self selector:@selector(closeInternalBrowser:) name:kCloseInternalBrowserNotification object:nil];
    [[NotificationCenter sharedInstance] addObserver:self selector:@selector(failToReceiveAd:) name:kInvalidParamsServerResponseNotification object:nil];
    [[NotificationCenter sharedInstance] addObserver:self selector:@selector(failToReceiveAd:) name:kEmptyServerResponseNotification object:nil];
    [[NotificationCenter sharedInstance] addObserver:self selector:@selector(failToReceiveAd:) name:kFailAdDownloadNotification object:nil];
    [[NotificationCenter sharedInstance] addObserver:self selector:@selector(failToReceiveAd:) name:kFailAdDisplayNotification object:nil];
    [[NotificationCenter sharedInstance] addObserver:self selector:@selector(ormmaEvent:) name:kORMMAEventNotification object:nil];
    [[NotificationCenter sharedInstance] addObserver:self selector:@selector(receiveThirdParty:) name:kThirdPartyNotification object:nil];
    
    
	[[NotificationCenter sharedInstance] addObserver:self selector:@selector(adDownloaded:) name:kStartAdDisplayNotification object:nil];
	[[NotificationCenter sharedInstance] addObserver:self selector:@selector(updateAd:) name:kUpdateAdDisplayNotification object:nil];
	[[NotificationCenter sharedInstance] addObserver:self selector:@selector(addDefaultImage:) name:kAdDisplayDefaultImage object:nil];
	[[NotificationCenter sharedInstance] addObserver:self selector:@selector(dislpayAd:) name:kReadyAdDisplayNotification object:nil];
	[[NotificationCenter sharedInstance] addObserver:self selector:@selector(visibleAd:) name:kAdViewBecomeVisibleNotification object:nil];
	[[NotificationCenter sharedInstance] addObserver:self selector:@selector(invisibleAd:) name:kAdViewBecomeInvisibleNotification object:nil];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(deviceOrientationDidChange:) name: UIDeviceOrientationDidChangeNotification object: nil];
    
    [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionNew context:nil];
    
	[[NotificationCenter sharedInstance] postNotificationName:kRegisterAdNotification object:self];
	
	_observerSet = YES;
}

- (void)adDownloaded:(NSNotification*)notification {
	NSDictionary *info = [notification object];
	AdView* adView = [info objectForKey:@"adView"];
	AdDescriptor* descriptor = [info objectForKey:@"descriptor"];
	
	if (adView == self) {
        AdModel* model = [self adModel];
        
        if (descriptor.adContentType == AdContentTypeDefaultHtml) {			
            AdWebView* adWebView = [[AdWebView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            adWebView.adView = self;
            adWebView.hidden = YES;
            [self addSubview:adWebView];
            [adWebView loadData:descriptor.serverReponse MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:nil];
            [adWebView release];
            
            model.descriptor = descriptor;
        }
        else if (descriptor.adContentType == AdContentTypeMojivaVideo) {
            VideoView* videoView = [[VideoView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            videoView.hidden = YES;
            [self addSubview:videoView];
            NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:[Utils aHrefUrlfromString:descriptor.serverReponseString]]];
            [videoView showWithUrl:[Utils videoUrlFromString:descriptor.serverReponseString] request:request];
            [videoView release];
            
            model.descriptor = descriptor;
        }
#ifdef INCLUDE_IAD
        else if (descriptor.adContentType == AdContentTypeIAd) {
            IAdAdaptor* iAdAdaptor = [[IAdAdaptor alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) section:nil];
            iAdAdaptor.hidden = YES;
            [self addSubview:iAdAdaptor];
            [iAdAdaptor updateSection:descriptor.adId];
            [iAdAdaptor release];
            
            model.descriptor = descriptor;
        }
#endif
#ifdef INCLUDE_MILLENNIAL
        else if (descriptor.adContentType == AdContentTypeMillennial) {
            MillennialAdaptor* millennialAdaptor = [[MillennialAdaptor alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            millennialAdaptor.hidden = YES;
            [self addSubview:millennialAdaptor];
            [millennialAdaptor showWithAdType:descriptor.adType
                                        appId:descriptor.appId
                                     latitude:descriptor.latitude
                                    longitude:descriptor.longitude
                                          zip:descriptor.zip];
            [millennialAdaptor release];
            
            model.descriptor = descriptor;
        }
#endif
#ifdef INCLUDE_IVDOPIA
        else if (descriptor.adContentType == AdContentTypeiVdopia) {
            IVdopiaAdaptor* iVdopiaAdaptor = [[IVdopiaAdaptor alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            iVdopiaAdaptor.hidden = YES;
            [self addSubview:iVdopiaAdaptor];
            [iVdopiaAdaptor showWithAppKey:descriptor.appId];
            [iVdopiaAdaptor release];
            
            model.descriptor = descriptor;
        }
#endif
#ifdef INCLUDE_GREYSTRIPE
        else if (descriptor.adContentType == AdContentTypeGreystripe) {
            GreystripeAdaptor* greystripeAdaptor = [[GreystripeAdaptor alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            greystripeAdaptor.hidden = YES;
            [self addSubview:greystripeAdaptor];
            [greystripeAdaptor showWithAppID:descriptor.appId];
            [greystripeAdaptor release];
            
            model.descriptor = descriptor;
        }
#endif
	}
}


- (void)updateAd:(NSNotification*)notification {
	NSDictionary *info = [notification object];
	AdView* adView = [info objectForKey:@"adView"];
	
	if (adView == self) {
        AdModel* model = [self adModel];
        if (model.currentAdView) {
            // all code removed
        }
    }
}

- (void)addDefaultImage:(NSNotification*)notification {
	AdView *adView = [notification object];
    
    if (adView == self) {        
        AdModel* model = [self adModel];
        UIImage* defaultImage = model.defaultImage;
        UIView* currentAdView = model.currentAdView;
        
        if (defaultImage) {
            // background
            UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            imageView.image = defaultImage;
            [self addSubview:imageView];
            [imageView release];
            
            if (!currentAdView) {
                // current view for animation
                imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
                imageView.image = defaultImage;
                model.currentAdView = imageView;
                [self addSubview:imageView];
                [imageView release];
            }
        }
	}
}


- (void)dislpayAd:(NSNotification*)notification {
	NSDictionary *info = [notification object];
	AdView* adView = [info objectForKey:@"adView"];
	UIView* subView = [info objectForKey:@"subView"];
    NSString* contentWidth = [info objectForKey:@"contentWidth"];
    NSString* contentHeight = [info objectForKey:@"contentHeight"];
	
	if (adView == self) {        
        AdModel* model = [self adModel];
        UIView* currentAdView = model.currentAdView;
        if (subView != currentAdView) {            
            if ([currentAdView isKindOfClass:[AdWebView class]]) {
                AdWebView* adWebView = (AdWebView*)currentAdView;
                [adWebView closeOrmma];
            }
            
            model.snapshot = currentAdView;
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
                
                [UIView animateWithDuration:0.2 animations:^{
                    subView.frame = prevAdFrame;
                    CGRect newFrameForOldImage = CGRectMake(prevAdFrame.origin.x+prevAdFrame.size.width, prevAdFrame.origin.y, prevAdFrame.size.width, prevAdFrame.size.height);
                    currentAdView.frame = newFrameForOldImage;
                } completion:^(BOOL finished) {
                    UIView* oldView = model.snapshot;
                    
                    if (oldView && oldView.superview) {
                        [oldView removeFromSuperview];
                        model.snapshot = nil;
                    }
                }];
            } else if (model.snapshot) {
                [model.snapshot removeFromSuperview];
                model.snapshot = nil;
            }
            
            if (!((AdModel*)_adModel).isDisplayed) {
                ((AdModel*)_adModel).startDisplayDate = [NSDate date];
                ((AdModel*)_adModel).isDisplayed = YES;
            }
            
            if (!self.closeButton) {
                [self prepareResources];
                if (self.closeButton) {
                    self.closeButton.frame = CGRectMake(self.frame.size.width - self.closeButton.frame.size.width - 11, 11, self.closeButton.frame.size.width, self.closeButton.frame.size.height);
                    self.closeButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
                    [self addSubview:self.closeButton];
                }
                self.closeButton.hidden = YES;
            } else {
                [self bringSubviewToFront:self.closeButton];
            }

            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [[NotificationCenter sharedInstance] postNotificationName:kAdDisplayedNotification object:self];
            });
            //[[NotificationCenter sharedInstance] postNotificationName:kAdDisplayedNotification object:self];
        }
	}
}

- (void)visibleAd:(NSNotification*)notification {
	AdView* adView = [notification object];
	
	if (adView == self) {        
        AdModel* model = [self adModel];
        if (model && model.descriptor && model.descriptor.adContentType == AdContentTypeMojivaVideo && [model.currentAdView isKindOfClass:[VideoView class]]) {
            VideoView* videoView = (VideoView*)model.currentAdView;
            [videoView play];
        }
	}
}

- (void)invisibleAd:(NSNotification*)notification {
	AdView* adView = [notification object];
	
	if (adView == self) {        
        AdModel* model = [self adModel];
        if (model && model.descriptor && model.descriptor.adContentType == AdContentTypeMojivaVideo && [model.currentAdView isKindOfClass:[VideoView class]]) {
            VideoView* videoView = (VideoView*)model.currentAdView;
            [videoView pause];
        }
	}
}

- (BOOL)saveToMojivaFolderData:(NSData*)data name:(NSString*)name {
    BOOL result = NO;
    NSString* dirPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/MojivaAd/Cache"];
    NSString* fileName = name;
    NSString* path = [dirPath stringByAppendingPathComponent:fileName];
    
    if (![[NSFileManager defaultManager] isReadableFileAtPath:path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
        
        if ([data writeToFile:path atomically:YES]) {
            result = YES;
        }
    }
    else {
        result = YES;
    }
    return result;
}

- (void)prepareResources {
    NSString* dirPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/MojivaAd/Cache"];
    
    NSString* path = [dirPath stringByAppendingPathComponent:@"closeIcon.png"];
    UIImage* closeIcon = nil;
    
    if (![[NSFileManager defaultManager] isReadableFileAtPath:path]) {
        NSData* imageData = [QSStrings decodeBase64WithString:kCloseIconB64];
        NSData* imageData2x = [QSStrings decodeBase64WithString:kCloseIcon2xB64];
        if ([self saveToMojivaFolderData:imageData name:@"closeIcon.png"] &&
            [self saveToMojivaFolderData:imageData2x name:@"closeIcon@2x.png"]) {
            closeIcon = [UIImage imageWithContentsOfFile:path];
        }
    } else {
        closeIcon = [UIImage imageWithContentsOfFile:path];
    }
    
    if (closeIcon && !self.closeButton) {
        self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.closeButton.frame = CGRectMake(0, 0, closeIcon.size.width, closeIcon.size.height);
        [self.closeButton setImage:closeIcon forState:UIControlStateNormal];
        [self.closeButton addTarget:self action:@selector(buttonsAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)buttonsAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClosedAd:usageTimeInterval:)]) {
        NSDate* _startDate = ((AdModel*)_adModel).startDisplayDate;
        NSTimeInterval timeInterval = -[_startDate timeIntervalSinceNow];
        [self.delegate didClosedAd:self usageTimeInterval:timeInterval];
    } else {
        if (self.superview && self.window) {
            if ([sender isKindOfClass:[NSNotification class]]) {
                NSNotification* notification = sender;
                if ([notification object] == self) {
                    [[NotificationCenter sharedInstance] postNotificationName:kInterstitialAdCloseNotification object:self];
                    self.hidden = YES;
                } else if ([[notification object] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary* info = [notification object];
                    AdView* adView = [info objectForKey:@"adView"];
                    if (adView == self) {
                        [[NotificationCenter sharedInstance] postNotificationName:kInterstitialAdCloseNotification object:self];
                        self.hidden = YES;
                    }
                }
            } else {
                [[NotificationCenter sharedInstance] postNotificationName:kInterstitialAdCloseNotification object:self];
                self.hidden = YES;
            }
        }
    }
}

- (void)deviceOrientationDidChange:(NSNotification*)notification {
	AdModel* model = [self adModel];
    model.snapshotRAWData = nil;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    NSData* rawData = [self adModel].snapshotRAWData;
    NSDate* lastTime = [self adModel].snapshotRAWDataTime;
    if (!(rawData && lastTime && abs([lastTime timeIntervalSinceNow]) < 1)) {
        // update cached data
        
        rawData = [self ARGBData];
        lastTime = [NSDate date];
        [self adModel].snapshotRAWData = rawData;
        [self adModel].snapshotRAWDataTime = lastTime;
    }
    
    if ([self isPointTransparent:point rawData:rawData]) {
        return NO;
    }
    
    return [super pointInside:point withEvent:event];
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
    BOOL newState = !self.hidden && newWindow;
    BOOL oldSate = [self adModel].visibleState;
    
    if (oldSate != newState) {
        // set new value
        [self adModel].visibleState = newState;
        
        if (oldSate == NO) {
            // ad become visible
            [[NotificationCenter sharedInstance] postNotificationName:kAdViewBecomeVisibleNotification object:self];
        } else {
            // ad become invisible
            [[NotificationCenter sharedInstance] postNotificationName:kAdViewBecomeInvisibleNotification object:self];
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {    
    if ([keyPath isEqualToString:@"view.frame"] || [keyPath isEqualToString:@"frame"]) {
        //CGRect oldFrame = CGRectNull;
        CGRect newFrame = CGRectNull;
        if([change objectForKey:@"old"] != [NSNull null]) {
            //oldFrame = [[change objectForKey:@"old"] CGRectValue];
        }
        if([object valueForKeyPath:keyPath] != [NSNull null]) {
            newFrame = [[object valueForKeyPath:keyPath] CGRectValue];
        }
        NSMutableDictionary* info = [NSMutableDictionary dictionary];
        [info setObject:self forKey:@"adView"];
        [info setObject:[NSValue valueWithCGRect:newFrame] forKey:@"newFrame"];
        
        [[NotificationCenter sharedInstance] postNotificationName:kAdViewFrameChangedNotification object:info];
    } else if ([keyPath isEqualToString:@"hidden"]) {
        BOOL newState = [self isViewVisible];
        BOOL oldSate = [self adModel].visibleState;
        
        if (oldSate != newState) {
            // set new value
            [self adModel].visibleState = newState;
            
            if (oldSate == NO) {
                // ad become visible
                [[NotificationCenter sharedInstance] postNotificationName:kAdViewBecomeVisibleNotification object:self];
            } else {
                // ad become invisible
                [[NotificationCenter sharedInstance] postNotificationName:kAdViewBecomeInvisibleNotification object:self];
            }
        }
    }
}


#pragma mark - Callback


//- (void)willReceiveAd:(id)sender;
- (void)startAdDownload:(NSNotification*)notification {
    NSDictionary *info = [notification object];
    AdView* adView = [info objectForKey:@"adView"];
	
	if (adView == self) {
        [self adModel].loading = YES;
        
        id <AdViewDelegate> delegate = [self adModel].delegate;
        
        if (delegate && [delegate respondsToSelector:@selector(willReceiveAd:)]) {
            [delegate willReceiveAd:self];
        }
    }
}

//- (void)didReceiveAd:(id)sender;
- (void)adDisplayd:(NSNotification*)notification {
    AdView* adView = [notification object];
	
	if (adView == self) {
        [self adModel].loading = NO;
        
        id <AdViewDelegate> delegate = [self adModel].delegate;
        
        if (delegate && [delegate respondsToSelector:@selector(didReceiveAd:)]) {
            [delegate didReceiveAd:self];
        }
    }
}

//- (void)adWillStartFullScreen:(id)sender;
- (void)openInternalBrowser:(NSNotification*)notification {
    NSDictionary *info = [notification object];
    AdView* adView = [info objectForKey:@"adView"];
	
	if (adView == self) {
        id <AdViewDelegate> delegate = [self adModel].delegate;
        
        if (delegate && [delegate respondsToSelector:@selector(adWillStartFullScreen:)]) {
            [delegate adWillStartFullScreen:self];
        }
    }
}

//- (void)adDidEndFullScreen:(id)sender;
- (void)closeInternalBrowser:(NSNotification*)notification {
    AdView* adView = [notification object];
	
	if (adView == self) {
        id <AdViewDelegate> delegate = [self adModel].delegate;
        
        if (delegate && [delegate respondsToSelector:@selector(adDidEndFullScreen:)]) {
            [delegate adDidEndFullScreen:self];
        }
    }
}

//- (void)didFailToReceiveAd:(id)sender withError:(NSError*)error;
- (void)failToReceiveAd:(NSNotification*)notification {
    NSString* name = [notification name];
    
    if ([name isEqualToString:kInvalidParamsServerResponseNotification]) {
        AdView* ad = [notification object];
        if (ad == self) {
            id <AdViewDelegate> delegate = [self adModel].delegate;
            
            if (delegate && [delegate respondsToSelector:@selector(didFailToReceiveAd: withError:)]) {
                NSError* error = [NSError errorWithDomain:@"invalid site or zone params" code:1010 userInfo:nil];
                [delegate didFailToReceiveAd:self withError:error];
            }
        }
    } else if ([name isEqualToString:kFailAdDownloadNotification]) {
        NSDictionary* info = [notification object];
        AdView* ad = [info objectForKey:@"adView"];
        NSError* error = [info objectForKey:@"error"];
        if (ad == self) {
            id <AdViewDelegate> delegate = [self adModel].delegate;
            
            if (delegate && [delegate respondsToSelector:@selector(didFailToReceiveAd: withError:)]) {
                [delegate didFailToReceiveAd:self withError:error];
            }
        }
    } else if ([name isEqualToString:kFailAdDisplayNotification]) {
        NSDictionary* info = [notification object];
        AdView* ad = [info objectForKey:@"adView"];
        //NSObject* subview = [info objectForKey:@"subView"];
        if (ad == self) {
            id <AdViewDelegate> delegate = [self adModel].delegate;
            
            if (delegate && [delegate respondsToSelector:@selector(didFailToReceiveAd: withError:)]) {
                NSError* error = [NSError errorWithDomain:@"fail to display" code:1011 userInfo:nil];
                [delegate didFailToReceiveAd:self withError:error];
            }
        }
    } else if ([name isEqualToString:kEmptyServerResponseNotification]) {
        NSDictionary* info = [notification object];
        AdView* ad = [info objectForKey:@"adView"];
        if (ad == self) {
            id <AdViewDelegate> delegate = [self adModel].delegate;
            
            if (delegate && [delegate respondsToSelector:@selector(didFailToReceiveAd: withError:)]) {
                NSError* error = [NSError errorWithDomain:@"There is no ads for this time. Try again later..." code:22 userInfo:nil];
                [delegate didFailToReceiveAd:self withError:error];
            }
        }
    }
}

- (void)receiveThirdParty:(NSNotification*)notification {
    NSDictionary *info = [notification object];
    AdView* adView = [info objectForKey:@"adView"];
    NSDictionary* dic = [info objectForKey:@"dic"];
	
	if (adView == self) {
        id <AdViewDelegate> delegate = [self adModel].delegate;
        
        if (delegate && [delegate respondsToSelector:@selector(didReceiveThirdPartyRequest:content:)]) {
            [delegate didReceiveThirdPartyRequest:self content:dic];
        }
    }
}

- (void)ormmaEvent:(NSNotification*)notification {
    NSDictionary *info = [notification object];
    AdView* adView = [info objectForKey:@"adView"];
    NSString* event = [info objectForKey:@"event"];
    NSDictionary* dic = [info objectForKey:@"dic"];
	
	if (adView == self) {
        id <AdViewDelegate> delegate = [self adModel].delegate;
        
        if (delegate && [delegate respondsToSelector:@selector(ormmaProcess:event:parameters:)]) {
            [delegate ormmaProcess:self event:event parameters:dic];
        }
    }
}

//- (BOOL)adShouldOpen:(id)sender withUrl:(NSURL*)url;
- (void)adShouldOpenBrowser:(NSNotification*)notification {
    NSDictionary *info = [notification object];
    AdView* adView = [info objectForKey:@"adView"];
    NSURLRequest* request = [info objectForKey:@"request"];
	
	if (adView == self) {
        id <AdViewDelegate> delegate = [self adModel].delegate;
        
        BOOL result = YES;
        if (delegate && [delegate respondsToSelector:@selector(adShouldOpen:withUrl:)]) {
            result = [delegate adShouldOpen:self withUrl:[request URL]];
        }
        if (result) {
            AdModel* model = [adView adModel];
            
            if (model.internalOpenMode) {
                UIViewController* controller = [adView viewControllerForView];
                if (controller) {                    
                    [[NotificationCenter sharedInstance] postNotificationName:kOpenInternalBrowserNotification object:info];
                } else {
                    [[NotificationCenter sharedInstance] postNotificationName:kCantOpenInternalBrowserNotification object:adView];
                    [[UIApplication sharedApplication] openURL:[request URL]];
                }
            }
            else {
                // open safari
                [[UIApplication sharedApplication] openURL:[request URL]];
            }
        }
    }
}

- (void)adShouldOpenExternalApp:(NSNotification*)notification {
    NSDictionary *info = [notification object];
    AdView* adView = [info objectForKey:@"adView"];
    NSURLRequest* request = [info objectForKey:@"request"];
	
	if (adView == self) {
        id <AdViewDelegate> delegate = [self adModel].delegate;
        
        BOOL result = YES;
        if (delegate && [delegate respondsToSelector:@selector(adShouldOpen:withUrl:)]) {
            result = [delegate adShouldOpen:self withUrl:[request URL]];
        }
        
        if (result) {
            [[UIApplication sharedApplication] openURL:[request URL]];
        }
    }
}


#pragma mark -
#pragma mark Propertys


- (AdModel*)adModel {
	return ((AdModel*)_adModel);
}

- (NSString*)uid {
    return [NSString stringWithFormat:@"%ld", self];
}

// @property (assign) id <AdViewDelegate> delegate;
- (void)setDelegate:(id <AdViewDelegate>)delegate {
	((AdModel*)_adModel).delegate = (id <AdViewDelegate>)delegate;
}

- (id <AdViewDelegate>)delegate {
	return ((AdModel*)_adModel).delegate;
}

//@property (readonly) BOOL readyForDisplay;
- (BOOL)isLoading {
	return [self adModel].loading;
}

//@property BOOL	testMode;
- (void)setTestMode:(BOOL)testMode {
	((AdModel*)_adModel).testMode = testMode;
}

- (BOOL)testMode {
	return ((AdModel*)_adModel).testMode;
}

//@property AdLogMode	logMode;
- (void)setLogMode:(AdLogMode)logMode {
    AdLogMode oldValue = ((AdModel*)_adModel).logMode;
    AdLogMode newValue = logMode;
	((AdModel*)_adModel).logMode = newValue;
    
    if (oldValue != newValue) {
        if (newValue == AdLogModeErrorsOnly) {
            [[NotificationCenter sharedInstance] postNotificationName:kAdStartLoggingErrorsNotification object:self];
        } else if (newValue == AdLogModeAll) {
            [[NotificationCenter sharedInstance] postNotificationName:kAdStartLoggingAllNotification object:self];
        } else if (newValue == AdLogModeNone) {
            // stop logging for this ad
            [[NotificationCenter sharedInstance] postNotificationName:kAdStopLoggingNotification object:self];
        }
    }
}

- (AdLogMode)logMode {
	return ((AdModel*)_adModel).logMode;
}

//@property BOOL	animateMode;
- (void)setAnimateMode:(BOOL)animateMode {
	((AdModel*)_adModel).animateMode = animateMode;
}

- (BOOL)animateMode {
	return ((AdModel*)_adModel).animateMode;
}

//@property BOOL	contentAlignment;
- (void)setContentAlignment:(BOOL)contentAlignment {
	((AdModel*)_adModel).aligmentCenter = contentAlignment;
}

- (BOOL)contentAlignment {
	return ((AdModel*)_adModel).aligmentCenter;
}

//@property BOOL	internalOpenMode;
- (void)setInternalOpenMode:(BOOL)internalOpenMode {
	((AdModel*)_adModel).internalOpenMode = internalOpenMode;
}

- (BOOL)internalOpenMode {
	return ((AdModel*)_adModel).internalOpenMode;
}

- (void)setTrack:(BOOL)track {
    if (track) {
        ((AdModel*)_adModel).track = 1;
    } else {
        ((AdModel*)_adModel).track = 0;
    }
}

- (BOOL)track {
	return ((AdModel*)_adModel).track > 0;
}

//@property NSTimeInterval	updateTimeInterval;
- (void)setUpdateTimeInterval:(NSTimeInterval)updateTimeInterval {
	// filter
	if (updateTimeInterval > 0 && updateTimeInterval < 5) {
		updateTimeInterval = 5;
	}
	
	NSTimeInterval oldValue = ((AdModel*)_adModel).updateTimeInterval;
	
	// set new value to model
	((AdModel*)_adModel).updateTimeInterval = updateTimeInterval;
	
	
	// process
	if (updateTimeInterval == 0 && oldValue > 0) {
		[[NotificationCenter sharedInstance] postNotificationName:kAdStopUpdateNotification object:self];
	}
	else if(updateTimeInterval > 0 && oldValue == 0) {
		[[NotificationCenter sharedInstance] postNotificationName:kAdStartUpdateNotification object:self];
	}
	else if (updateTimeInterval != oldValue) {
		[[NotificationCenter sharedInstance] postNotificationName:kAdChangeUpdateTimeIntervalNotification object:self];
	}
}

- (NSTimeInterval)updateTimeInterval {
	return ((AdModel*)_adModel).updateTimeInterval;
}

//@property (retain) UIImage*	defaultImage;
- (void)setDefaultImage:(UIImage*)defaultImage {
	((AdModel*)_adModel).defaultImage = defaultImage;
    
    [[NotificationCenter sharedInstance] postNotificationName:kAdDisplayDefaultImage object:self];
}

- (UIImage*)defaultImage {
	return ((AdModel*)_adModel).defaultImage;
}


//@property (retain) NSString*	site;
- (void)setSite:(NSInteger)site {
	[((AdModel*)_adModel) setSite:site];
}

- (NSInteger)site {
	return [((AdModel*)_adModel) site];
}

//@property (retain) NSString*	zone;
- (void)setZone:(NSInteger)zone {
	[((AdModel*)_adModel) setAdZone:zone];
}

- (NSInteger)zone {
	return [((AdModel*)_adModel) adZone];
}

//@property AdPremium		premiumFilter;
- (void)setPremium:(AdPremium)premium {
	((AdModel*)_adModel).premiumFilter = premium;
}

- (AdPremium)premium {
	return ((AdModel*)_adModel).premiumFilter;
}

//@property AdType		type;
- (void)setType:(AdType)type {
	((AdModel*)_adModel).type = type;
}

- (AdType)type {
	return ((AdModel*)_adModel).type;
}

//@property (retain) NSString*	keywords;
- (void)setKeywords:(NSString*)keywords {
	((AdModel*)_adModel).keywords = keywords;
}

- (NSString*)keywords {
	return ((AdModel*)_adModel).keywords;
}

//@property CGSize	minSize;
- (void)setMinSize:(CGSize)minSize {
	((AdModel*)_adModel).minSize = minSize;
}

- (CGSize)minSize {
	return ((AdModel*)_adModel).minSize;
}

//@property CGSize	maxSize;
- (void)setMaxSize:(CGSize)maxSize {
	((AdModel*)_adModel).maxSize = maxSize;
}

- (CGSize)maxSize {
	return ((AdModel*)_adModel).maxSize;
}

//@property (readonly) CGSize contentSize;
- (CGSize)contentSize {
    return ((AdModel*)_adModel).contentSize;
}

//@property (retain) NSString*	paramBG;
- (void)setBackgroundColor:(UIColor*)backgroundColor {
	((AdModel*)_adModel).paramBG = backgroundColor;
    [super setBackgroundColor:backgroundColor];
}

//@property (retain) NSString*	paramLINK;
- (void)setTextColor:(UIColor*)textColor {
	((AdModel*)_adModel).paramLINK = textColor;
}

- (UIColor*)textColor {
	return ((AdModel*)_adModel).paramLINK;
}

//@property (retain) NSString*	additionalParameters;
- (void)setAdditionalParameters:(NSDictionary*)additionalParameters {
	((AdModel*)_adModel).additionalParameters = additionalParameters;
}

- (NSDictionary*)additionalParameters {
	return ((AdModel*)_adModel).additionalParameters;
}

//@property (retain) NSString*	adServerUrl;
- (void)setAdServerUrl:(NSString*)adServerUrl {
	((AdModel*)_adModel).adServerUrl = adServerUrl;
}

- (NSString*)adServerUrl {
	return ((AdModel*)_adModel).adServerUrl;
}

//@property (retain) NSString*	advertiserId;
- (void)setAdvertiserId:(NSInteger)advertiserId {
	((AdModel*)_adModel).advertiserId = advertiserId;
    
    if (((AdModel*)_adModel).groupCode) {
        [[InstallManager sharedInstance] sendNotificationWith:advertiserId groupCode:((AdModel*)_adModel).groupCode];
    }
}

- (NSInteger)advertiserId {
	return ((AdModel*)_adModel).advertiserId;
}

//@property (retain) NSString*	groupCode;
- (void)setGroupCode:(NSString*)groupCode {
	((AdModel*)_adModel).groupCode = groupCode;
    
    if (((AdModel*)_adModel).advertiserId) {
        [[InstallManager sharedInstance] sendNotificationWith:((AdModel*)_adModel).advertiserId groupCode:groupCode];
    }
}

- (NSString*)groupCode {
	return ((AdModel*)_adModel).groupCode;
}

//@property (retain) NSString*            country;
- (void)setCountry:(NSString*)country {
	((AdModel*)_adModel).country = country;
}

- (NSString*)country {
	return ((AdModel*)_adModel).country;
}

//@property (retain) NSString*            region;
- (void)setRegion:(NSString*)region {
	((AdModel*)_adModel).region = region;
}

- (NSString*)region {
	return ((AdModel*)_adModel).region;
}

//@property (retain) NSString*            city;
- (void)setCity:(NSString*)city {
	((AdModel*)_adModel).city = city;
}

- (NSString*)city {
	return ((AdModel*)_adModel).city;
}

//@property (retain) NSString*            area;
- (void)setArea:(NSString*)area {
	((AdModel*)_adModel).area = area;
}

- (NSString*)area {
	return ((AdModel*)_adModel).area;
}

//@property (retain) NSString*            metro;
- (void)setMetro:(NSString*)metro {
	((AdModel*)_adModel).metro = metro;
}

- (NSString*)metro {
	return ((AdModel*)_adModel).metro;
}

//@property (retain) NSString*            zip;
- (void)setZip:(NSString*)zip {
	((AdModel*)_adModel).zip = zip;
}

- (NSString*)zip {
	return ((AdModel*)_adModel).zip;
}

//@property (retain) NSString*            carrier
- (void)setCarrier:(NSString*)carrier {
	((AdModel*)_adModel).carrier = carrier;
}

- (NSString*)carrier {
	return ((AdModel*)_adModel).carrier;
}

//@property (retain) NSString*            lat;
- (void)setLatitude:(NSString*)latitude {
    [[LocationManager sharedInstance] stopUpdatingLocation];
    [[NotificationCenter sharedInstance] postNotificationName:kNewLocationSetNotification object:latitude];
	((AdModel*)_adModel).latitude = latitude;
}

- (NSString*)latitude {
	return ((AdModel*)_adModel).latitude;
}

//@property (retain) NSString*            lon;
- (void)setLongitude:(NSString*)longitude {
    [[LocationManager sharedInstance] stopUpdatingLocation];
    [[NotificationCenter sharedInstance] postNotificationName:kNewLocationSetNotification object:longitude];
	((AdModel*)_adModel).longitude = longitude;
}

- (NSString*)longitude {
	return ((AdModel*)_adModel).longitude;
}

@end
