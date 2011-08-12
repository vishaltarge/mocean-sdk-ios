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
updateTimeInterval, defaultImage, site, adZone, premiumFilter, adsType, keywords, minSize, maxSize,
paramBG, paramLINK, additionalParameters, adServerUrl, advertiserId, groupCode,
country, region, city, area, metro, zip, carrier, showCloseButtonTime,
autocloseInterstitialTime, startDisplayDate, closeButton, isDisplayed, aligmentCenter, frame,
snapshot, snapshotRAWData, snapshotRAWDataTime, currentAdView, excampaigns, descriptor, loading,
longitude, latitude;

- (BOOL)validate {
    if (self.site <= 0) {
        [[NotificationCenter sharedInstance] postNotificationName:[NSString stringWithFormat:@"Invalid site property: %d", self.site] object:nil];
        return NO;
    } else if (self.adZone <= 0) {
        [[NotificationCenter sharedInstance] postNotificationName:[NSString stringWithFormat:@"Invalid zone property: %d", self.adZone] object:nil];
        return NO;
    } else if (!(self.adsType == 1 || self.adsType == 2 || self.adsType == 3 || self.adsType == 6 || self.adsType == -1)) {
        [[NotificationCenter sharedInstance] postNotificationName:[NSString stringWithFormat:@"Invalid adsType property: %d", self.adsType] object:nil];
        return NO;
    } else if (minSize.width <= 0 || minSize.height <= 0) {
        [[NotificationCenter sharedInstance] postNotificationName:[NSString stringWithFormat:@"Invalid minSize property: {%f, %f}", self.minSize.width, self.minSize.height] object:nil];
        return NO;
    } else if (maxSize.width <= 0 || maxSize.height <= 0) {
        [[NotificationCenter sharedInstance] postNotificationName:[NSString stringWithFormat:@"Invalid maxSize property: {%f, %f}", self.minSize.width, self.minSize.height] object:nil];
        return NO;
    } else if ([advertiserId intValue] <= 0) {
        [[NotificationCenter sharedInstance] postNotificationName:[NSString stringWithFormat:@"Invalid advertiserId property: %a", self.advertiserId] object:nil];
        return NO;
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
	
	if (self.minSize.width > 0 && self.minSize.height > 0) {
		[_banerUrl appendFormat:@"&min_size_x=%1.0f&min_size_y=%1.0f", self.minSize.width, self.minSize.height];
	}
	
	if (self.maxSize.width > 0 && self.maxSize.height > 0) {
		[_banerUrl appendFormat:@"&size_x=%1.0f&size_y=%1.0f", self.maxSize.width, self.maxSize.height];
	}
    
	if (self.keywords != nil) [_banerUrl appendFormat:@"&keywords=%@", self.keywords];	
	if (self.premiumFilter != -1) [_banerUrl appendFormat:@"&premium=%d", self.premiumFilter];
	if (self.adsType != -1) [_banerUrl appendFormat:@"&adstype=%d", self.adsType];
	if (self.testMode) [_banerUrl appendString:@"&test=1"];
	if (self.paramBG != nil) [_banerUrl appendFormat:@"&paramBG=%@", [Utils hexColor:self.paramBG]];
	if (self.paramLINK != nil) [_banerUrl appendFormat:@"&paramLINK=%@", [Utils hexColor:self.paramLINK]];
    
    if (self.country) [_banerUrl appendFormat:@"&country=%@", self.country];
    if (self.region) [_banerUrl appendFormat:@"&region=%@", self.region];
    if (self.city) [_banerUrl appendFormat:@"&city=%@", self.city];
    if (self.area) [_banerUrl appendFormat:@"&area=%@", self.area];
    if (self.metro) [_banerUrl appendFormat:@"&metro=%@", self.metro];
    if (self.zip) [_banerUrl appendFormat:@"&zip=%@", self.zip];
    if (self.carrier) [_banerUrl appendFormat:@"&carrier=%@", self.carrier];
    
    if (self.latitude == nil && self.longitude == nil)
    {
#ifdef INCLUDE_LOCATION_MANAGER
        if ([LocationManager sharedInstance].unknowsState == NO && 
            [LocationManager sharedInstance].currentLocationCoordinate.latitude != 0.0 &&
            [LocationManager sharedInstance].currentLocationCoordinate.longitude != 0.0)
        {
            [[NotificationCenter sharedInstance] postNotificationName:kLocationUsedFoundLocationNotification object:nil];
            [_banerUrl appendFormat:@"&latitude=%f", [LocationManager sharedInstance].currentLocationCoordinate.latitude];
            [_banerUrl appendFormat:@"&longitude=%f", [LocationManager sharedInstance].currentLocationCoordinate.longitude];
        }
#endif
    }
    else if ([self.latitude length]>0 && [self.longitude length]>0)
    {
        [_banerUrl appendFormat:@"&latitude=%@", self.latitude];
        [_banerUrl appendFormat:@"&longitude=%@", self.longitude];
    }
    else if ([self.latitude length] !=0 || [self.longitude length]!=0)
    {
        [[NotificationCenter sharedInstance] postNotificationName:kLocationInvalidParamertsNotification object:nil]; 
    }
    
    [_banerUrl appendString:[[SharedModel sharedInstance] sharedUrlPart]];
    
    if (self.excampaigns) [_banerUrl appendFormat:@"&excampaigns=%@", [self.excampaigns componentsJoinedByString:@","]];
	
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
    [advertiserId release];
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
