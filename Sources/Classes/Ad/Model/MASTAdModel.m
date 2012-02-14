//
//  AdModel.m
//  AdMobileSDK
//
//  Created by Constantine Mureev on 3/1/11.
//

#import "MASTAdModel.h"

#import "MASTUtils.h"
#import "MASTConstants.h"
#import "MASTNotificationCenter.h"
#import "MASTDownloadController.h"
#import "MASTInternalBrowser.h"
#import "MASTVideoView.h"
#import "MASTMessages.h"

@implementation MASTAdModel

@synthesize delegate, readyForDisplay, testMode, logMode, animateMode, internalOpenMode, track,
updateTimeInterval, defaultImage, site, adZone, premiumFilter, type, keywords, minSize, maxSize,
paramBG, paramLINK, additionalParameters, adServerUrl, advertiserId, groupCode,
country, region, city, area, metro, zip, carrier, showCloseButtonTime,
autocloseInterstitialTime, startDisplayDate, isDisplayed, aligmentCenter, contentSize, frame,
visibleState, snapshotRAWData, snapshotRAWDataTime, currentAdView, adView, excampaigns, descriptor, loading,
longitude, latitude, timeout, isUserSetMaxSize, autoCollapse, showPreviousAdOnError;

- (BOOL)validate {
    if (self.site <= 0) {
        NSMutableDictionary* info = [NSMutableDictionary dictionary];
        [info setObject:self.adView forKey:@"adView"];
        [info setObject:[NSError errorWithDomain:[NSString stringWithFormat:@"%@ - %d", kErrorInvalidSiteMessage, self.site] code:171 userInfo:nil] forKey:@"error"];        
        [[MASTNotificationCenter sharedInstance] postNotificationName:kInvalidParamsNotification object:info];
        return NO;
    } else if (self.adZone <= 0) {
        NSMutableDictionary* info = [NSMutableDictionary dictionary];
        [info setObject:self.adView forKey:@"adView"];
        [info setObject:[NSError errorWithDomain:[NSString stringWithFormat:@"%@ - %d", kErrorInvalidZoneMessage, self.adZone] code:172 userInfo:nil] forKey:@"error"];        
        [[MASTNotificationCenter sharedInstance] postNotificationName:kInvalidParamsNotification object:info];
        return NO;
    }
    
    if (!(self.premiumFilter == 0 || self.premiumFilter == 1 || self.premiumFilter == 2)) {
        NSMutableDictionary* info = [NSMutableDictionary dictionary];
        [info setObject:self.adView forKey:@"adView"];
        [info setObject:[NSError errorWithDomain:[NSString stringWithFormat:@"%@ - %d", kErrorInvalidPremiumMessage, self.premiumFilter] code:174 userInfo:nil] forKey:@"error"];
        [[MASTNotificationCenter sharedInstance] postNotificationName:kInvalidParamsNotification object:info];
    }
    if (minSize.width < 0 || minSize.height < 0) {
        NSMutableDictionary* info = [NSMutableDictionary dictionary];
        [info setObject:self.adView forKey:@"adView"];
        [info setObject:[NSError errorWithDomain:[NSString stringWithFormat:@"%@ - {%f, %f}", kErrorInvalidMinSizeMessage, self.minSize.width, self.minSize.height] code:175 userInfo:nil] forKey:@"error"];        
        [[MASTNotificationCenter sharedInstance] postNotificationName:kInvalidParamsNotification object:info];
    }
    if (maxSize.width < 0 || maxSize.height < 0) {
        NSMutableDictionary* info = [NSMutableDictionary dictionary];
        [info setObject:self.adView forKey:@"adView"];
        [info setObject:[NSError errorWithDomain:[NSString stringWithFormat:@"%@ - {%f, %f}", kErrorInvalidMaxSizeMessage, self.maxSize.width, self.maxSize.height] code:176 userInfo:nil] forKey:@"error"];        
        [[MASTNotificationCenter sharedInstance] postNotificationName:kInvalidParamsNotification object:info];
    }
    if (advertiserId < 0) {
        NSMutableDictionary* info = [NSMutableDictionary dictionary];
        [info setObject:self.adView forKey:@"adView"];
        [info setObject:[NSError errorWithDomain:[NSString stringWithFormat:@"%@ - %d", kErrorInvalidAdvertiserIdMessage, self.advertiserId] code:177 userInfo:nil] forKey:@"error"];        
        [[MASTNotificationCenter sharedInstance] postNotificationName:kInvalidParamsNotification object:info];
    }
    if (!(self.type <= 7)) {
        NSMutableDictionary* info = [NSMutableDictionary dictionary];
        [info setObject:self.adView forKey:@"adView"];
        [info setObject:[NSError errorWithDomain:[NSString stringWithFormat:@"%@ - %d", kErrorInvalidTypeMessage, self.type] code:178 userInfo:nil] forKey:@"error"];        
        [[MASTNotificationCenter sharedInstance] postNotificationName:kInvalidParamsNotification object:info];
    }
    
    return YES;
}


- (NSString*)urlIgnoreValifation {
    NSMutableString* _banerUrl = [NSMutableString new];
	
	if ([self adServerUrl]) {
		[_banerUrl appendString:[self adServerUrl]];
	}
	else {
		[_banerUrl appendString:kDefaultAdServerUrl];
	}
    
    [_banerUrl appendString:@"?"];
	
	// required
	if (self.site > 0) [_banerUrl appendFormat:@"site=%d", self.site];
	if (self.adZone > 0) [_banerUrl appendFormat:@"&zone=%d", self.adZone];
	
	if (self.minSize.width > 0 && self.minSize.height > 0)
		[_banerUrl appendFormat:@"&min_size_x=%1.0f&min_size_y=%1.0f", self.minSize.width, self.minSize.height];
	
	if (self.maxSize.width > 0 && self.maxSize.height > 0)
		[_banerUrl appendFormat:@"&size_x=%1.0f&size_y=%1.0f", self.maxSize.width, self.maxSize.height];
    
	if (self.keywords != nil)
        [_banerUrl appendFormat:@"&keywords=%@", self.keywords];	
    
    if (self.premiumFilter == 0 || self.premiumFilter == 1 || self.premiumFilter == 2)
        [_banerUrl appendFormat:@"&premium=%d", self.premiumFilter];
    
	if (self.type >=1 && self.type <= 7)
        [_banerUrl appendFormat:@"&type=%d", self.type];
    
	if (self.testMode)
        [_banerUrl appendString:@"&test=1"];
    
	if (self.paramBG != nil && [MASTUtils canGetHexColor:self.paramBG])
        [_banerUrl appendFormat:@"&paramBG=#%@", [MASTUtils hexColor:self.paramBG]];
    
	if (self.paramLINK != nil && [MASTUtils canGetHexColor:self.paramLINK])
        [_banerUrl appendFormat:@"&paramLINK=#%@", [MASTUtils hexColor:self.paramLINK]];
    
    if (self.country)
        [_banerUrl appendFormat:@"&country=%@", self.country];
    
    if (self.region)
        [_banerUrl appendFormat:@"&region=%@", self.region];
    
    if (self.city)
        [_banerUrl appendFormat:@"&city=%@", self.city];
    
    if (self.area)
        [_banerUrl appendFormat:@"&area=%@", self.area];
    
    if (self.metro)
        [_banerUrl appendFormat:@"&metro=%@", self.metro];
    
    if (self.zip)
        [_banerUrl appendFormat:@"&zip=%@", self.zip];
    
    if (self.track >= 0) {
        [_banerUrl appendFormat:@"&track=%d", self.track];
    }
    
    if (self.carrier)
        [_banerUrl appendFormat:@"&carrier=%@", self.carrier];
    
    if (self.latitude == nil && self.longitude == nil)
    {
#ifdef INCLUDE_LOCATION_MANAGER
        if ([LocationManager sharedInstance].unknowsState == NO && 
            [LocationManager sharedInstance].currentLocationCoordinate.latitude != 0.0 &&
            [LocationManager sharedInstance].currentLocationCoordinate.longitude != 0.0)
        {
            [[NotificationCenter sharedInstance] postNotificationName:kLocationUsedFoundLocationNotification object:nil];
            [_banerUrl appendFormat:@"&lat=%f", [LocationManager sharedInstance].currentLocationCoordinate.latitude];
            [_banerUrl appendFormat:@"&long=%f", [LocationManager sharedInstance].currentLocationCoordinate.longitude];
        }
#endif
    }
    else if ([self.latitude length]>0 && [self.longitude length]>0)
    {
        [_banerUrl appendFormat:@"&lat=%@", self.latitude];
        [_banerUrl appendFormat:@"&long=%@", self.longitude];
    }
    else if ([self.latitude length] !=0 || [self.longitude length]!=0)
    {
        [[MASTNotificationCenter sharedInstance] postNotificationName:kLocationInvalidParamertsNotification object:nil]; 
    }
    
    [_banerUrl appendString:[[MASTSharedModel sharedInstance] sharedUrlPart]];
    
    if (self.excampaigns) 
        [_banerUrl appendFormat:@"&excampaigns=%@", [self.excampaigns componentsJoinedByString:@","]];
	
	[_banerUrl appendString:@"&count=1"];
	[_banerUrl appendString:@"&key=1"];
	
	if (self.additionalParameters) {
        NSArray* keys = [self.additionalParameters allKeys];
        for (NSString* key in keys) {
            NSString* val = [self.additionalParameters objectForKey:key];
            
            if (key && val) {
                [_banerUrl appendFormat:@"&%@=%@", key, val];
            }
        }
	}
	
    [_banerUrl appendFormat:@"&timeout=%d", self.timeout];
    
	// important! return url - isKindeOfClass NSString!
	NSString* url = [_banerUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	[_banerUrl release];
	return url;
}

- (NSString*)url {
    if (![self validate]) {
        return nil;
    }
    
    return [self urlIgnoreValifation];
}

- (BOOL)isFirstDisplay {
    return !self.isDisplayed;
}

- (void)dealloc {
	[defaultImage release];
	[keywords release];
	[paramBG release];
	[paramLINK release];
	[additionalParameters release];
	[adServerUrl release];
    [groupCode release];
    [country release];
    [region release];
    [city release];
    [area release];
    [metro release];
    [zip release];
    [carrier release];
    [startDisplayDate release];
    [excampaigns release];
    [descriptor release];
    [latitude release];
    [longitude release];
    [snapshotRAWData release];
    [snapshotRAWDataTime release];
    
    if ([NSThread isMainThread]) {
        if (currentAdView && currentAdView.superview) {
            [currentAdView removeFromSuperview];
        }
        [currentAdView release];
	}
	else {
        if (currentAdView && currentAdView.superview) {
            [currentAdView performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:YES];
        }
        [currentAdView performSelectorOnMainThread:@selector(release) withObject:nil waitUntilDone:YES];
	}
	
	[super dealloc];
}

- (void)cancelAllNetworkConnection {
    [[MASTDownloadController sharedInstance] cancelAll];
}

- (void)closeInternalBrowser {
    [[MASTInternalBrowser sharedInstance] close];
}

- (void)pauseVideoViewPlayer {
    for (UIView *view in self.adView.subviews) {
        if ([view isKindOfClass:[MASTVideoView class]]) {
            MASTVideoView *videoView = (MASTVideoView*)view;
            [videoView pause];
            [videoView setFullscreen:NO animated:NO];
        }
    }
}

@end
