//
//  MASTOrmmaSharedDataSource.m
//  Copyright (c) Microsoft. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "MASTOrmmaSharedDataSource.h"
#import "MASTNotificationCenter.h"
#import "MASTLocationManager.h"


@interface MASTOrmmaSharedDataSource() <UIAccelerometerDelegate>
{
    BOOL isShakeDetected,isTiltDetected;
    UIAcceleration* lastAcceleration;
}

@property(retain) UIAcceleration* lastAcceleration;
@end

@implementation MASTOrmmaSharedDataSource

@synthesize lastAcceleration;
static MASTOrmmaSharedDataSource* sharedInstance = nil;


static BOOL accelerationIsShaking(UIAcceleration* last, UIAcceleration* current, double threshold) {
    double
    deltaX = fabs(last.x - current.x),
    deltaY = fabs(last.y - current.y),
    deltaZ = fabs(last.z - current.z);
    
    return
    (deltaX > threshold && deltaY > threshold) ||
    (deltaX > threshold && deltaZ > threshold) ||
    (deltaY > threshold && deltaZ > threshold);
}

static BOOL accelerationIsTilting(UIAcceleration* last, UIAcceleration* current, double max_threshold, double min_threshold) {
    
    double
    deltaX = fabs(last.x - current.x),
    deltaY = fabs(last.y - current.y),
    deltaZ = fabs(last.z - current.z);
    
    //check again to make sure that it is not shaking
    bool isShaking = 
    (deltaX > max_threshold && deltaY > max_threshold) ||
    (deltaX > max_threshold && deltaZ > max_threshold) ||
    (deltaY > max_threshold && deltaZ > max_threshold);
    
        
    
    //check to make sure if acceleration is titled
    bool isTilted = 
    ( deltaX > min_threshold && deltaX < max_threshold ) ||
    ( deltaY > min_threshold && deltaY < max_threshold ) ||
    ( deltaZ > min_threshold && deltaZ < max_threshold );
    
    
    //if not shaking and tilted,
    return !isShaking && isTilted;
}

#pragma mark -
#pragma mark - Location

- (void)locationUpdated:(NSNotification*)notification
{
    CLLocation* location = [notification object];
	NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:self, kOrmmaKeySender, location, kOrmmaKeyObject, nil];
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
		[[MASTNotificationCenter sharedInstance] addObserver:self selector:@selector(locationUpdated:) name:kLocationManagerLocationUpdate object:nil];
		[[MASTNotificationCenter sharedInstance] addObserver:self selector:@selector(headingUpdated:) name:kLocationManagerHeadingUpdate object:nil];

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
    BOOL support = [MASTLocationManager deviceLocationAvailable];
    if (support)
        support = [[MASTLocationManager sharedInstance] locationDetectionActive];
    
	return support;
}

- (BOOL)supportHeadingForAd:(id)sender
{
    BOOL support = [MASTLocationManager deviceHeadingAvailable];
    if (support)
        support = [[MASTLocationManager sharedInstance] locationDetectionActive];
    
	return support;
}

- (BOOL)supportTiltForAd:(id)sender
{
	return YES;
}

#pragma mark -
#pragma mark - Accelerometer Delegete

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
	// Send accelerometer data
	NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self, kOrmmaKeySender, acceleration, kOrmmaKeyObject, nil];
    
    /*
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
     */
    
    CGFloat kDefaultMaxThreshold = 1.0;
    CGFloat kDefaultMinThreshold = 0.3;
    
    if (self.lastAcceleration == nil)
    {
        self.lastAcceleration = acceleration;
    }
    
    if (self.lastAcceleration) {
        
        if (!isShakeDetected && accelerationIsShaking(self.lastAcceleration, acceleration, kDefaultMaxThreshold)) {
            isShakeDetected = YES;
            
            // Shake detected
            [[NSNotificationCenter defaultCenter] postNotificationName:kOrmmaShake object:dic];
            
        } else if (isShakeDetected && !accelerationIsShaking(self.lastAcceleration, acceleration, kDefaultMinThreshold)) {
            
            isShakeDetected = NO;
        }
        
        if (!isShakeDetected)
        {
            
            /* fall through the tilt checking */
            
            if (!isTiltDetected && accelerationIsTilting(self.lastAcceleration,acceleration,kDefaultMaxThreshold,kDefaultMinThreshold))
            {
                //tilt detected
                isTiltDetected = YES;
                [[NSNotificationCenter defaultCenter] postNotificationName:kOrmmaTiltUpdated object:dic];
            } else if (isTiltDetected && !accelerationIsTilting(self.lastAcceleration,acceleration,kDefaultMaxThreshold,kDefaultMinThreshold))
            {
                isTiltDetected = NO;
            }
            
        } 
        self.lastAcceleration = acceleration;

    }

    
    
}

@end