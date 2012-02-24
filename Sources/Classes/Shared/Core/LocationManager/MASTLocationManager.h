//
//  MASTLocationManager.h
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

// location
#define kNewLocationDetectedNotification @"New location found"
#define kNewLocationSetNotification @"Set new location"
#define kLocationStartNotification @"Start location search"
#define kLocationStopNotification @"Stop location search"
#define kLocationInvalidParamertsNotification @"use both longitude and latitude parameters"
#define kLocationErrorNotification @"Error find location"
#define kLocationUpdateHeadingNotification @"Update heading"
#define kLocationUsedFoundLocationNotification @"Used Found Location"

@interface MASTLocationManager : CLLocationManager <CLLocationManagerDelegate>
{
	CLLocationCoordinate2D              _currentLocationCoordinate;
	CLLocation*                         _currentLocation;
	CLHeading*                          _currentHeading;

	BOOL								_isUpdatingLocation;
	NSString*							_latitude;
	NSString*							_longitude;
}

@property (readonly) CLLocationManager*             locationManager;
@property (readonly) CLLocationCoordinate2D         currentLocationCoordinate;
@property (readonly) CLLocation*                    currentLocation;
@property (readonly) CLHeading*                     currentHeading;
@property (readonly) BOOL                           isUpdatingLocation;
@property (assign) BOOL                             unknowsState;

+ (MASTLocationManager*)sharedInstance;
+ (void)releaseSharedInstance;

- (void)startUpdatingHeading;

@end
