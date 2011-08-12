//
//  LocationManager.h
//  AdMobileSDK
//
//  Created by Constantine Mureev on 3/25/11.
//

#import <Foundation/Foundation.h>

#import "AdView.h"

#ifdef INCLUDE_LOCATION_MANAGER
#import <CoreLocation/CoreLocation.h>
#endif


#import "NotificationCenter.h"

#ifdef INCLUDE_LOCATION_MANAGER
@interface LocationManager : CLLocationManager <CLLocationManagerDelegate> {
	CLLocationCoordinate2D              _currentLocationCoordinate;
	CLLocation*                         _currentLocation;
#else
@interface LocationManager : NSObject {
#endif
	BOOL								_isUpdatingLocation;
	NSString*							_latitude;
	NSString*							_longitude;
}
    
#ifdef INCLUDE_LOCATION_MANAGER
@property (readonly) CLLocationManager*             locationManager;
@property (readonly) CLLocationCoordinate2D         currentLocationCoordinate;
@property (readonly) CLLocation*                    currentLocation;
#else
@property (readonly) id                             locationManager;
@property (readonly) id                             currentLocation;
#endif
@property (readonly) BOOL                           isUpdatingLocation;
@property (assign) BOOL                             unknowsState;

+ (LocationManager*)sharedInstance;
+ (void)releaseSharedInstance;

@end
