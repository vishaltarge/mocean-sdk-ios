//
//  NotificationCenter.m
//  AdMobileSDK
//
//  Created by Constantine Mureev on 2/22/11.
//

#import "NotificationCenter.h"

#import "DownloadController.h"
#import "AdController.h"
#import "InternalBrowser.h"
#import "Logger.h"
#import "SharedModel.h"
#import "AdClicker.h"
#import "InternalAVPlayer.h"


@implementation NotificationCenter

static NotificationCenter* sharedInstance = nil;

#pragma mark -
#pragma mark Singleton

- (id) init {
    self = [super init];
	if (self) {
	}
	
	return self;
}

+ (id)sharedInstance {
	@synchronized(self) {
		if (nil == sharedInstance) {
			sharedInstance = [[self alloc] init];
            
			
            if (![Logger sharedInstance]) {
				// somtheing going wrong...
			}
            
            if (![SharedModel sharedInstance]) {
				// somtheing going wrong...
			}
            
			if (![AdController sharedInstance]) {
				// somtheing going wrong...
			}
			
            if (![DownloadController sharedInstance]) {
				// somtheing going wrong...
			}
			
            if (![AdClicker sharedInstance]) {
				// somtheing going wrong...
			}
			
			if ([NSThread isMainThread]) {
				if (![InternalBrowser sharedInstance]) {
					// somtheing going wrong...
				}
			}
			else {
				[InternalBrowser performSelectorOnMainThread:@selector(sharedInstance) withObject:nil waitUntilDone:NO];
			}
			
			if ([NSThread isMainThread]) {
				if (![InternalAVPlayer sharedInstance]) {
					// somtheing going wrong...
				}
			}
			else {
				[InternalAVPlayer performSelectorOnMainThread:@selector(sharedInstance) withObject:nil waitUntilDone:NO];
			}

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

@end
