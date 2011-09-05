//
//  AdModel.m
//  AdMobileSDK
//
//  Created by Constantine Mureev on 3/1/11.
//

#import "AdModel.h"

#import "Utils.h"
#import "Constants.h"
#import "NotificationCenter.h"

@implementation AdModel

@synthesize delegate, readyForDisplay, testMode, logMode, animateMode, internalOpenMode,
updateTimeInterval, defaultImage, site, adZone, premiumFilter, adsType, type, keywords, minSize, maxSize,
paramBG, paramLINK, additionalParameters, adServerUrl, advertiserId, groupCode,
country, region, city, area, metro, zip, carrier, showCloseButtonTime,
autocloseInterstitialTime, startDisplayDate, closeButton, isDisplayed, aligmentCenter, contentSize, frame,
snapshot, snapshotRAWData, snapshotRAWDataTime, currentAdView, adView, excampaigns, descriptor, loading,
longitude, latitude;

- (BOOL)validate {
    if (self.site <= 0) {
        NSMutableDictionary* info = [NSMutableDictionary dictionary];
        [info setObject:self.adView forKey:@"adView"];
        [info setObject:[NSError errorWithDomain:[NSString stringWithFormat:@"Invalid site property. value - %d", self.site] code:171 userInfo:nil] forKey:@"error"];        
        [[NotificationCenter sharedInstance] postNotificationName:kInvalidParamsNotification object:info];
        return NO;
    } else if (self.adZone <= 0) {
        NSMutableDictionary* info = [NSMutableDictionary dictionary];
        [info setObject:self.adView forKey:@"adView"];
        [info setObject:[NSError errorWithDomain:[NSString stringWithFormat:@"Invalid zone property. value - %d", self.adZone] code:172 userInfo:nil] forKey:@"error"];        
        [[NotificationCenter sharedInstance] postNotificationName:kInvalidParamsNotification object:info];
        return NO;
    }
    
    if (!(self.adsType == 1 || self.adsType == 2 || self.adsType == 3 || self.adsType == 6)) {
        NSMutableDictionary* info = [NSMutableDictionary dictionary];
        [info setObject:self.adView forKey:@"adView"];
        [info setObject:[NSError errorWithDomain:[NSString stringWithFormat:@"Invalid adsType property. value - %d", self.adsType] code:173 userInfo:nil] forKey:@"error"];        
        [[NotificationCenter sharedInstance] postNotificationName:kInvalidParamsNotification object:info];
    }
    if (!(self.premiumFilter == 0 || self.premiumFilter == 1 || self.premiumFilter == 2)) {
        NSMutableDictionary* info = [NSMutableDictionary dictionary];
        [info setObject:self.adView forKey:@"adView"];
        [info setObject:[NSError errorWithDomain:[NSString stringWithFormat:@"Invalid premium property. value - %d", self.premiumFilter] code:174 userInfo:nil] forKey:@"error"];        
        [[NotificationCenter sharedInstance] postNotificationName:kInvalidParamsNotification object:info];
    }
    if (minSize.width < 0 || minSize.height < 0) {
        NSMutableDictionary* info = [NSMutableDictionary dictionary];
        [info setObject:self.adView forKey:@"adView"];
        [info setObject:[NSError errorWithDomain:[NSString stringWithFormat:@"Invalid minSize property. value - {%f, %f}", self.minSize.width, self.minSize.height] code:175 userInfo:nil] forKey:@"error"];        
        [[NotificationCenter sharedInstance] postNotificationName:kInvalidParamsNotification object:info];
    }
    if (maxSize.width < 0 || maxSize.height < 0) {
        NSMutableDictionary* info = [NSMutableDictionary dictionary];
        [info setObject:self.adView forKey:@"adView"];
        [info setObject:[NSError errorWithDomain:[NSString stringWithFormat:@"Invalid maxSize property. value - {%f, %f}", self.maxSize.width, self.maxSize.height] code:176 userInfo:nil] forKey:@"error"];        
        [[NotificationCenter sharedInstance] postNotificationName:kInvalidParamsNotification object:info];
    }
    if (advertiserId < 0) {
        NSMutableDictionary* info = [NSMutableDictionary dictionary];
        [info setObject:self.adView forKey:@"adView"];
        [info setObject:[NSError errorWithDomain:[NSString stringWithFormat:@"Invalid advertiserId property. value - %d", self.advertiserId] code:177 userInfo:nil] forKey:@"error"];        
        [[NotificationCenter sharedInstance] postNotificationName:kInvalidParamsNotification object:info];
    }
    if (!(self.type >=1 && self.type <= 7)) {
        NSMutableDictionary* info = [NSMutableDictionary dictionary];
        [info setObject:self.adView forKey:@"adView"];
        [info setObject:[NSError errorWithDomain:[NSString stringWithFormat:@"Invalid type property. value - %d", self.type] code:178 userInfo:nil] forKey:@"error"];        
        [[NotificationCenter sharedInstance] postNotificationName:kInvalidParamsNotification object:info];
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
    
	if (self.adsType == 1 || self.adsType == 2 || self.adsType == 3 || self.adsType == 6)
        [_banerUrl appendFormat:@"&adstype=%d", self.adsType];
        
    if (self.type >=1 && self.type <= 7)
        [_banerUrl appendFormat:@"&type=%d", self.type];
    
	if (self.testMode)
        [_banerUrl appendString:@"&test=1"];
    
	if (self.paramBG != nil && [Utils canGetHexColor:self.paramBG])
        [_banerUrl appendFormat:@"&paramBG=#%@", [Utils hexColor:self.paramBG]];
    
	if (self.paramLINK != nil && [Utils canGetHexColor:self.paramLINK])
        [_banerUrl appendFormat:@"&paramLINK=#%@", [Utils hexColor:self.paramLINK]];
    
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
        [[NotificationCenter sharedInstance] postNotificationName:kLocationInvalidParamertsNotification object:nil]; 
    }
    
    [_banerUrl appendString:[[SharedModel sharedInstance] sharedUrlPart]];
    
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
	[closeButton release];
    [startDisplayDate release];
    [excampaigns release];
    [descriptor release];
    [latitude release];
    [longitude release];
    [snapshotRAWData release];
    [snapshotRAWDataTime release];
    
    if ([NSThread isMainThread]) {
        if (snapshot && snapshot.superview) {
            [snapshot removeFromSuperview];
        }
        [snapshot release];
        
        if (currentAdView && currentAdView.superview) {
            [currentAdView removeFromSuperview];
        }
        [currentAdView release];
	}
	else {
        if (snapshot && snapshot.superview) {
            [snapshot performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:YES];
        }
        [snapshot performSelectorOnMainThread:@selector(release) withObject:nil waitUntilDone:YES];
        
        if (currentAdView && currentAdView.superview) {
            [currentAdView performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:YES];
        }
        [currentAdView performSelectorOnMainThread:@selector(release) withObject:nil waitUntilDone:YES];
	}
	
	[super dealloc];
}

@end
