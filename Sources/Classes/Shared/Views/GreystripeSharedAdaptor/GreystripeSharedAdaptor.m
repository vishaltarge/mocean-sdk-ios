//
//  GreystripeSharedAdaptor.m
//  AdMobileSDK
//
//  Created by Constantine Mureev on 4/19/11.
//

#import "GreystripeSharedAdaptor.h"

#ifdef INCLUDE_GREYSTRIPE

@implementation GreystripeSharedAdaptor

@synthesize delegate;

static GreystripeSharedAdaptor* sharedInstance = nil;


#pragma mark -
#pragma mark Singleton


- (id) init {
	self = [super init];
    if (self) {
        _greystripeAdReadyForSlotNamed = NO;
        _greystripeFullScreenDisplayWillOpen = NO;
        _greystripeFullScreenDisplayWillClose = NO;
    }
    
	return self;
}

+ (id)sharedInstance {
	@synchronized(self) {
		if (nil == sharedInstance) {
			sharedInstance = [[self alloc] init];
		}
	}
	return sharedInstance;
}

- (oneway void)superRelease {
	[super release];
}

+ (void)releaseSharedInstance {
	@synchronized(self) {
		[sharedInstance superRelease];
		sharedInstance = nil;
	}
}

+ (id)allocWithZone:(NSZone*)zone {
	@synchronized(self) {
		if (nil == sharedInstance) {
			sharedInstance = [super allocWithZone:zone];
		}
	}
	
	return sharedInstance;
}

- (id)copyWithZone:(NSZone *)zone {
	return sharedInstance;
}

- (id)retain {
	return sharedInstance;
}

- (unsigned)retainCount {
	return NSUIntegerMax;
}

- (oneway void)release {
	// Do nothing.
}

- (id)autorelease {
	return sharedInstance;
}


#pragma mark -
#pragma mark Private


-(NSInteger)getSlotWidthWithFrame:(CGRect)aFrame {
	//kGSAdSizeBanner = 1,				// 320x48
	//kGSAdSizeIPhoneFullScreen,		// full screen
	//kGSAdSizeIPadMediumRectangle,		// 300x250
	//kGSAdSizeIPadLeaderboard,			// 728x90
	//kGSAdSizeIPadWideSkyscraper		// 160x600
	
	NSInteger bannerWidth = aFrame.size.width;
	NSInteger bannerHeight =aFrame.size.height;
    
	if ( bannerWidth == 320 && bannerHeight == 48 ) {
		return kGSAdSizeBanner;
	}
	else if ( bannerWidth == 300 && bannerHeight == 250 ) {
		return kGSAdSizeIPadMediumRectangle;
	}
	else if ( bannerWidth == 728 && bannerHeight == 90 ) {
		return kGSAdSizeIPadLeaderboard;
	}
	else if ( bannerWidth == 160 && bannerHeight == 600 ) {
		return kGSAdSizeIPadWideSkyscraper;
	}
	
    
    if (bannerWidth >= 160 && bannerHeight >= 600) {
        return kGSAdSizeIPadWideSkyscraper;
    } else if (bannerWidth >= 728 && bannerHeight >= 90) {
        return kGSAdSizeIPadLeaderboard;
    } else if (bannerWidth >= 300 && bannerHeight >= 250) {
        return kGSAdSizeIPadMediumRectangle;
    } else {
        return kGSAdSizeBanner;
    }
}


#pragma mark -
#pragma mark Public


- (GSAdView*)adViewWithAppId:(NSString*)appId frame:(CGRect)frame {    
    if (!_appId) {
        _appId = [appId retain];
        _frame = frame;
        GSAdSlotDescription* slot = [GSAdSlotDescription descriptionWithSize:[self getSlotWidthWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)] name:BANNER_SLOT_NAME];
        
        [GSAdEngine startupWithAppID:appId adSlotDescriptions:[NSArray arrayWithObjects:slot, nil]];
        
        _adView = [GSAdView adViewForSlotNamed:slot.name delegate:self];
        
        [_adView retain];
        
        //never release adView!
        [_adView retain];
        [_adView retain];
        [_adView retain];
        [_adView retain];
        [_adView retain];
        [_adView retain];
        
        return _adView;
    }
    else {
        if (_greystripeAdReadyForSlotNamed && self.delegate && [self.delegate respondsToSelector:@selector(greystripeAdReadyForSlotNamed:)]) {
            [self.delegate greystripeAdReadyForSlotNamed:BANNER_SLOT_NAME];
        }
        if (_greystripeFullScreenDisplayWillOpen && self.delegate && [self.delegate respondsToSelector:@selector(greystripeFullScreenDisplayWillOpen)]) {
            [self.delegate greystripeFullScreenDisplayWillOpen];
        }
        if (_greystripeFullScreenDisplayWillClose && self.delegate && [self.delegate respondsToSelector:@selector(greystripeFullScreenDisplayWillClose)]) {
            [self.delegate greystripeFullScreenDisplayWillClose];
        }
        
        //never release adView!
        [_adView retain];
        [_adView retain];
        return _adView;
    }
    
    return nil;
}


#pragma mark 
#pragma mark Greystripe delegate


- (void)greystripeAdReadyForSlotNamed:(NSString *)a_name {
    _greystripeAdReadyForSlotNamed = YES;
    _greystripeFullScreenDisplayWillClose = NO;
    _greystripeFullScreenDisplayWillOpen = NO;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(greystripeAdReadyForSlotNamed:)]) {
        [self.delegate greystripeAdReadyForSlotNamed:a_name];
    }
}

- (void)greystripeFullScreenDisplayWillOpen {
    _greystripeFullScreenDisplayWillOpen = YES;
    _greystripeFullScreenDisplayWillClose = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(greystripeFullScreenDisplayWillOpen)]) {
        [self.delegate greystripeFullScreenDisplayWillOpen];
    }
}

- (void)greystripeFullScreenDisplayWillClose {
    _greystripeFullScreenDisplayWillClose = YES;
    _greystripeFullScreenDisplayWillOpen = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(greystripeFullScreenDisplayWillClose)]) {
        [self.delegate greystripeFullScreenDisplayWillClose];
    }
    
}

@end
#endif
