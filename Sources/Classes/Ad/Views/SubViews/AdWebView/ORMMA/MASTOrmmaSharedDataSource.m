//
//  MASTOrmmaSharedDataSource.m
//  Copyright (c) Microsoft. All rights reserved.
//

#import "MASTOrmmaSharedDataSource.h"

@interface MASTOrmmaSharedDataSource() <UIAccelerometerDelegate>
@end

@implementation MASTOrmmaSharedDataSource

static MASTOrmmaSharedDataSource* sharedInstance = nil;

#pragma mark -
#pragma mark - Location

- (void)locationDetected:(NSNotification*)notification
{
    CLLocation* location = [notification object];
	//NSLog(@"lon = %.4f %.4f",location.coordinate.latitude, location.coordinate.longitude);
	NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self, kOrmmaKeySender, location, kOrmmaKeyObject, nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:kOrmmaLocationUpdated object:dic];
}

#pragma mark -
#pragma mark - HeadingUpdated

- (void)headingUpdated:(NSNotification*)notification
{
    CLHeading* heading = [notification object];
    NSNumber* headingNumber = [NSNumber numberWithDouble:heading.trueHeading];
	NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self, kOrmmaKeySender, headingNumber, kOrmmaKeyObject, nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:kOrmmaHeadingUpdated object:dic];
}

#pragma mark -
#pragma mark Singleton

- (id)init {
    self = [super init];
    
	if (self) {
		//location
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationDetected:) name:kNewLocationDetectedNotification object:nil];
		//HeadingUpdated
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(headingUpdated:) name:kLocationUpdateHeadingNotification object:nil];

#ifdef INCLUDE_LOCATION_MANAGER
		[[MASTLocationManager sharedInstance] startUpdatingLocation];
		[[MASTLocationManager sharedInstance] startUpdatingHeading];
#endif
		//Accelerometer
		[[MASTAccelerometer sharedInstance] addDelegate:self];
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
#pragma mark - OrmmaDataSource 

- (BOOL)supportLocationForAd:(id)sender
{
#ifdef INCLUDE_LOCATION_MANAGER
	return  YES;
#endif
	return NO;
}

- (BOOL)supportHeadingForAd:(id)sender
{
#ifdef INCLUDE_LOCATION_MANAGER
	return  [CLLocationManager headingAvailable];
#endif
	return NO;
}

- (BOOL)supportTiltForAd:(id)sender
{
#ifdef INCLUDE_LOCATION_MANAGER
	return  YES;
#endif
	return NO;
}

#pragma mark -
#pragma mark - Accelerometer Delegete

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
	// Send accelerometer data
	NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self, kOrmmaKeySender, acceleration, kOrmmaKeyObject, nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:kOrmmaTiltUpdated object:dic];

	// Deal with shakes
    BOOL shake = NO;
    CGFloat kDefaultShakeIntensity = 1.5;
    if ((acceleration.x > kDefaultShakeIntensity) || (acceleration.x < (-1 * kDefaultShakeIntensity))) {
        shake = YES;
    }
    
    if ((acceleration.x > kDefaultShakeIntensity) || (acceleration.x < (-1 * kDefaultShakeIntensity))) {
        shake = YES;
    }
    
    if ((acceleration.x > kDefaultShakeIntensity) || (acceleration.x < (-1 * kDefaultShakeIntensity))) {
        shake = YES;
    }
    
    if (shake) {
        // Shake detected
		[[NSNotificationCenter defaultCenter] postNotificationName:kOrmmaShake object:dic];
    }
}

@end