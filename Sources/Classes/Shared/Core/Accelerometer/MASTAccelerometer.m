//
//  MASTAccelerometer.m
//  Copyright (c) Microsoft. All rights reserved.
//

#import "MASTAccelerometer.h"
#import "MASTUtils.h"

@interface MASTAccelerometer()
@property (retain) NSMutableArray* delegates;
@end

@implementation MASTAccelerometer

@synthesize delegates;

static MASTAccelerometer* sharedInstance = nil;


#pragma mark -
#pragma mark Singleton


- (id) init {
    self = [super init];
    
    if (self) {
        self.delegates = CreateNonRetainingArray();
        UIAccelerometer* accelerometer = [UIAccelerometer sharedAccelerometer];
        accelerometer.updateInterval = .1;
        accelerometer.delegate = self;
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


#pragma mark - Public


- (void)addDelegate:(id <UIAccelerometerDelegate>)delegate {
    @synchronized(self.delegates) {
        [self.delegates addObject:delegate];
    }
}
- (void)removeDelegate:(id <UIAccelerometerDelegate>)delegate {
    @synchronized(self.delegates) {
        [self.delegates removeObject:delegate];
    }
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    @synchronized(self.delegates) {
        for (id <UIAccelerometerDelegate> del in self.delegates) {
            [del accelerometer:accelerometer didAccelerate:acceleration];
        }
    }
}

@end
