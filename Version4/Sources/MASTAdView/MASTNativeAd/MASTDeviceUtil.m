/*
 
 * PubMatic Inc. ("PubMatic") CONFIDENTIAL
 
 * Unpublished Copyright (c) 2006-2014 PubMatic, All Rights Reserved.
 
 *
 
 * NOTICE:  All information contained herein is, and remains the property of PubMatic. The intellectual and technical concepts contained
 
 * herein are proprietary to PubMatic and may be covered by U.S. and Foreign Patents, patents in process, and are protected by trade secret or copyright law.
 
 * Dissemination of this information or reproduction of this material is strictly forbidden unless prior written permission is obtained
 
 * from PubMatic.  Access to the source code contained herein is hereby forbidden to anyone except current PubMatic employees, managers or contractors who have executed
 
 * Confidentiality and Non-disclosure agreements explicitly covering such access.
 
 *
 
 * The copyright notice above does not evidence any actual or intended publication or disclosure  of  this source code, which includes
 
 * information that is confidential and/or proprietary, and is a trade secret, of  PubMatic.   ANY REPRODUCTION, MODIFICATION, DISTRIBUTION, PUBLIC  PERFORMANCE,
 
 * OR PUBLIC DISPLAY OF OR THROUGH USE  OF THIS  SOURCE CODE  WITHOUT  THE EXPRESS WRITTEN CONSENT OF PubMatic IS STRICTLY PROHIBITED, AND IN VIOLATION OF APPLICABLE
 
 * LAWS AND INTERNATIONAL TREATIES.  THE RECEIPT OR POSSESSION OF  THIS SOURCE CODE AND/OR RELATED INFORMATION DOES NOT CONVEY OR IMPLY ANY RIGHTS
 
 * TO REPRODUCE, DISCLOSE OR DISTRIBUTE ITS CONTENTS, OR TO MANUFACTURE, USE, OR SELL ANYTHING THAT IT  MAY DESCRIBE, IN WHOLE OR IN PART.
 
 */

//
//  PUBDeviceUtil.m


#import "MASTDeviceUtil.h"

@interface MASTDeviceUtil ()<CLLocationManagerDelegate>

@property(nonatomic,strong) CLLocationManager* locationManager;


@end


@implementation MASTDeviceUtil
@dynamic userAgent;
@synthesize locationManager;
@synthesize isLocationDetectionEnabled=_isLocationDetectionEnabled;
@synthesize latitude,longitude;


#pragma mark -  Initialization
- (id)init {
    
    self = [super init];
    
    if (self) {
        self.latitude = nil;
        self.longitude = nil;
    }
    return self;
}


#pragma mark -  ReadOnly Methods

-(NSString *) userAgent
{
    
    UIWebView *webview = [[UIWebView alloc] init];
    NSString *userAgent = [webview stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    
    return userAgent;
}


#pragma mark -  Overridden methods to make class singleton

static id sharedInstance = nil;

//
// Static functions return the singleton object of Derived class
//
+ (id)sharedInstance
{
    @synchronized(self) 
    {
        if (nil == sharedInstance || (![sharedInstance isKindOfClass:self])) 
            sharedInstance = [[super allocWithZone:NULL] init];
        return sharedInstance;
    }
}

// We don't allocate a new instance, so return the current one.

+ (id)allocWithZone:(NSZone*)zone {
    return [self sharedInstance] ;
}

//  we don't generate multiple copies.
- (id)copyWithZone:(NSZone *)zone {
    return self;
}


-(void) enableAutoLocationRetrivialWithSignificantUpdating:(BOOL)significantUpdating
                                            distanceFilter:(CLLocationDistance)distanceFilter
                                           desiredAccuracy:(CLLocationAccuracy)desiredAccuracy
{
    if([self isLocationRetrivalAllowed])
    {
        if (self.locationManager == nil)
        {
            self.locationManager = [CLLocationManager new];
            self.locationManager.delegate = self;
        }
        
        self.locationManager.distanceFilter = distanceFilter;
        self.locationManager.desiredAccuracy = desiredAccuracy;
        
        if (significantUpdating && [CLLocationManager significantLocationChangeMonitoringAvailable])
        {
            [locationManager startMonitoringSignificantLocationChanges];
        }
        else
        {
            [locationManager startUpdatingLocation];
        }
        
        _isLocationDetectionEnabled = YES;
    }
    else
    {
         [self disableAutoLocationRetrivial];
    }
}

-(BOOL) isLocationRetrivalAllowed
{
    
    BOOL available = YES;
    if ([CLLocationManager respondsToSelector:@selector(authorizationStatus)])
    {
        CLAuthorizationStatus authStatus = [CLLocationManager authorizationStatus];
        if ((authStatus != kCLAuthorizationStatusNotDetermined) && (authStatus != kCLAuthorizationStatusAuthorized))
        {
            available = NO;
        }
    }
    
    if (available && ([CLLocationManager locationServicesEnabled] == NO))
        available = NO;
    
    return available;

}

-(void) disableAutoLocationRetrivial
{
    [self.locationManager setDelegate:nil];
    [self.locationManager stopUpdatingLocation];
    
    if ([self.locationManager respondsToSelector:@selector(stopMonitoringSignificantLocationChanges)])
        [self.locationManager stopMonitoringSignificantLocationChanges];
    
    self.locationManager = nil;
    _isLocationDetectionEnabled = NO;

}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    self.latitude = nil;
    self.longitude = nil;
}

// This method has been depricated only kept to support backward compatability
- (void)locationManager:(CLLocationManager*)manager didUpdateToLocation:(CLLocation*)newLocation fromLocation:(CLLocation*)oldLocation
{
    self.latitude = [NSNumber numberWithDouble:newLocation.coordinate.latitude];
    self.longitude = [NSNumber numberWithDouble:newLocation.coordinate.longitude];
}

- (void)locationManager:(CLLocationManager *)manager
	 didUpdateLocations:(NSArray *)locations
{
    CLLocation *current_location = [locations lastObject];
    
    self.latitude = [NSNumber numberWithDouble:current_location.coordinate.latitude];
    self.longitude = [NSNumber numberWithDouble:current_location.coordinate.longitude];
    
}



- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    
}

- (void)dealloc
{
        self.latitude = nil;
        self.longitude = nil;
}


@end




