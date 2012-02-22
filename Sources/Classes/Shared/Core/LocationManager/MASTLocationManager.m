//
//  MASTLocationManager.m
//  Copyright (c) Microsoft. All rights reserved.
//

#import "MASTLocationManager.h"


@implementation MASTLocationManager

@synthesize locationManager = _locationManager,
currentLocation = _currentLocation, currentHeading = _currentHeading, isUpdatingLocation = _isUpdatingLocation, unknowsState;


@synthesize currentLocationCoordinate = _currentLocationCoordinate;


static MASTLocationManager* sharedInstance = nil;


#pragma mark -
#pragma mark Singleton

- (id) init {
    self = [super init];
    
	if (self) {

        self.delegate = self;
		_currentLocationCoordinate.latitude = 0.0;
		_currentLocationCoordinate.longitude = 0.0;
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
        _isUpdatingLocation = YES;
        [super startUpdatingLocation];
        //[[NotificationCenter sharedInstance] postNotificationName:kLocationStartNotification object:_currentLocation];
    }
}

- (void)stopUpdatingLocation {
    if (self.unknowsState) {
        self.unknowsState = NO;
    }
    if (_isUpdatingLocation)
    {
        _isUpdatingLocation = NO;
        [super stopUpdatingLocation];
        //[[NotificationCenter sharedInstance] postNotificationName:kLocationStopNotification object:_currentLocation];
    }
}

- (void)startUpdatingHeading {
    [super startUpdatingHeading];
}

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
    
	[[NSNotificationCenter defaultCenter] postNotificationName:kNewLocationDetectedNotification object:_currentLocation];
    
    if (newLocation.horizontalAccuracy < 1000000 )
    {
        [self stopUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager  didFailWithError:(NSError *)error
{
    //[[NotificationCenter sharedInstance] postNotificationName:kLocationErrorNotification object:error];
    [super startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager 
	   didUpdateHeading:(CLHeading *)newHeading
{
    if (newHeading.trueHeading >= 0 && (newHeading.trueHeading != _currentHeading.trueHeading || !_currentHeading)) {
        if (_currentHeading) {
            [_currentHeading release];
        }
        _currentHeading = [newHeading retain];

		[[NSNotificationCenter defaultCenter] postNotificationName:kLocationUpdateHeadingNotification object:_currentHeading];

        //[[NotificationCenter sharedInstance] postNotificationName:kLocationUpdateHeadingNotification object:newHeading];
    }
}

@end