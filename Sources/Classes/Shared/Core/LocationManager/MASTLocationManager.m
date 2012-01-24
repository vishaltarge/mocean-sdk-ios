//
//  LocationManager.m
//  AdMobileSDK
//
//  Created by Constantine Mureev on 3/25/11.
//

#import "LocationManager.h"


@implementation LocationManager

@synthesize locationManager = _locationManager,
currentLocation = _currentLocation, currentHeading = _currentHeading, isUpdatingLocation = _isUpdatingLocation, unknowsState;

#ifdef INCLUDE_LOCATION_MANAGER
@synthesize currentLocationCoordinate = _currentLocationCoordinate;
#endif

static LocationManager* sharedInstance = nil;


#pragma mark -
#pragma mark Singleton


- (id) init {
    self = [super init];
    
	if (self) {
#ifdef INCLUDE_LOCATION_MANAGER
        self.delegate = self;
        
		_currentLocationCoordinate.latitude = 0.0;
		_currentLocationCoordinate.longitude = 0.0;
#endif
		_isUpdatingLocation = NO;
        self.unknowsState = YES;
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
#pragma mark Public

- (void)startUpdatingLocation {
    if (self.unknowsState) {
        self.unknowsState = NO;
    }
    if (!_isUpdatingLocation)
    {
#ifdef INCLUDE_LOCATION_MANAGER
        _isUpdatingLocation = YES;
        [super startUpdatingLocation];
        [[NotificationCenter sharedInstance] postNotificationName:kLocationStartNotification object:_currentLocation];
#endif
    }
}

- (void)stopUpdatingLocation {
    if (self.unknowsState) {
        self.unknowsState = NO;
    }
    if (_isUpdatingLocation)
    {
#ifdef INCLUDE_LOCATION_MANAGER
        _isUpdatingLocation = NO;
        [super stopUpdatingLocation];
        [[NotificationCenter sharedInstance] postNotificationName:kLocationStopNotification object:_currentLocation];
#endif        
    }
}

- (void)startUpdatingHeading {
#ifdef INCLUDE_LOCATION_MANAGER
    [super startUpdatingHeading];
#endif
}

#ifdef INCLUDE_LOCATION_MANAGER

#pragma mark -
#pragma mark Private


- (CLLocationManager*)locationManager {
    return self;
}


#pragma mark -
#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager*)manager
	didUpdateToLocation:(CLLocation*)newLocation
           fromLocation:(CLLocation*)oldLocation {
    if (_currentLocation) {
        [_currentLocation release];
    }
    _currentLocation = [newLocation retain];
    _currentLocationCoordinate = _currentLocation.coordinate;
    
    [[NotificationCenter sharedInstance] postNotificationName:kNewLocationDetectedNotification object:_currentLocation];
    
    if (newLocation.horizontalAccuracy < 1000000 )
    {
        [self stopUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager  didFailWithError:(NSError *)error
{
    [[NotificationCenter sharedInstance] postNotificationName:kLocationErrorNotification object:error];

    //[super startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager 
	   didUpdateHeading:(CLHeading *)newHeading
{
    if (newHeading.trueHeading >= 0 && (newHeading.trueHeading != _currentHeading.trueHeading || !_currentHeading)) {
        if (_currentHeading) {
            [_currentHeading release];
        }
        _currentHeading = [newHeading retain];
        
        [[NotificationCenter sharedInstance] postNotificationName:kLocationUpdateHeadingNotification object:newHeading];
    }
}

#endif 

@end