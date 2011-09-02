//
//  SharedModel.m
//  AdMobileSDK
//
//  Created by Constantine Mureev on 3/1/11.
//

#import "SharedModel.h"

@interface SharedModel()

- (void)uaDetected:(NSNotification*)notification;
- (void)locationDetected:(NSNotification*)notification;

@end

@implementation SharedModel

@synthesize udidMd5 = _udidMd5, ua, latitude, longitude, mcc, mnc;

static SharedModel* sharedInstance = nil;


#pragma mark -
#pragma mark Singleton


- (id) init {
    self = [super init];
	if (self) {
        [[NotificationCenter sharedInstance] addObserver:self selector:@selector(uaDetected:) name:kUaDetectedNotification object:nil];
        [[NotificationCenter sharedInstance] addObserver:self selector:@selector(locationDetected:) name:kNewLocationDetectedNotification object:nil];
        
        if (![WebKitInfo sharedInstance]) {
            // somthing going wrong...
        }
        
        if (![LocationManager sharedInstance]) {
            // somthing going wrong...
        }
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


- (NSString*)sharedUrlPart {
    NSMutableString* result = [NSMutableString string];
    
	if (self.udidMd5) {
        [result appendFormat:@"&udid=%@", self.udidMd5];
    }
    
	if (self.ua) {
        [result appendFormat:@"&ua=%@", self.ua];
    }
    
    else if ([WebKitInfo sharedInstance].ua) {
        self.ua = [WebKitInfo sharedInstance].ua;
        [result appendFormat:@"&ua=%@", self.ua];
    }
    
    // set connection speed
    NetworkStatus networkState = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
    if (networkState == ReachableViaWiFi) {
        [result appendFormat:@"&connection_speed=%d", 1];
    }
    else if (networkState == ReachableViaWWAN) {
        [result appendFormat:@"&connection_speed=%d", 0];
    }
    
    // set mcc and mnc
    if (self.mcc && self.mnc) {
        [result appendFormat:@"&mcc=%@", self.mcc];
        [result appendFormat:@"&mnc=%@", self.mnc];
    } else {
        CTTelephonyNetworkInfo *netInfo = [[[CTTelephonyNetworkInfo alloc] init] autorelease];
        CTCarrier *carrier = [netInfo subscriberCellularProvider];
        NSString *local_mcc = [carrier mobileCountryCode];
        if (local_mcc && [local_mcc length] > 0) {
            self.mcc = local_mcc;
            [result appendFormat:@"&mcc=%@", self.mcc];
        }
        
        NSString *local_mnc = [carrier mobileNetworkCode];
        if (local_mnc && [local_mnc length] > 0) {
            self.mnc = local_mnc;
            [result appendFormat:@"&mnc=%@", self.mnc];
        }
    }
    
    [result appendFormat:@"&version=%@", LIBRARY_VERSION];
    
	return result;
}


#pragma mark -
#pragma mark Private


- (void)uaDetected:(NSNotification*)notification {
    self.ua = [notification object];
}


- (void)locationDetected:(NSNotification*)notification {
#ifdef INCLUDE_LOCATION_MANAGER
    CLLocation* location = [notification object];
    self.latitude = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
    self.longitude = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
#endif
}


#pragma mark -
#pragma mark Propertys


//@property (retain) NSString*                udid;
- (NSString*)udidMd5; {
    if (_udidMd5) {
        return _udidMd5;
    } else {
        self.udidMd5 = [Utils md5HashForString:[[UIDevice currentDevice] uniqueIdentifier]];
        return _udidMd5;
    }
}

@end
