//
//  OrmmaAdaptor.m
//  AdMobileSDK
//
//  Created by Constantine Mureev on 8/23/11.
//

#import "OrmmaAdaptor.h"
#import "OrmmaConstants.h"
#import "OrmmaHelper.h"
#import "UIViewAdditions.h"
#import "Reachability.h"
#import "NotificationCenter.h"
#import "LocationManager.h"
#import "Accelerometer.h"

#define ORMMA_SHAME     @"ormma"

@interface OrmmaAdaptor() <UIAccelerometerDelegate>

@property (nonatomic, retain) UIWebView*        webView;
@property (nonatomic, retain) AdView*           adView;

@property (nonatomic, assign) ORMMAState        currentState;
@property (nonatomic, assign) ORMMAState        notHiddenState;
@property (nonatomic, assign) CGSize            maxSize;

- (void)viewVisible:(NSNotification*)notification;
- (void)viewInvisible:(NSNotification*)notification;
- (void)invalidate:(NSNotification*)notification;
- (void)frameChanged:(NSNotification*)notification;
- (void)orientationChanged:(NSNotification *)notification;
- (void)keyboardWillShow:(NSNotification *)notification;
- (void)keyboardWillHide:(NSNotification *)notification;
- (void)handleReachabilityChangedNotification:(NSNotification *)notification;
- (void)locationDetected:(NSNotification*)notification;
- (void)headingDetected:(NSNotification*)notification;
- (void)evalJS:(NSString*)js;

@end

@implementation OrmmaAdaptor

@synthesize webView, adView, currentState, notHiddenState, maxSize;

- (id)initWithWebView:(UIWebView*)view adView:(AdView*)ad {
    self = [super init];
    if (self) {
        self.webView = view;
        self.adView = ad;
        
        [[NotificationCenter sharedInstance] addObserver:self selector:@selector(viewVisible:) name:kAdViewBecomeVisibleNotification object:nil];
		[[NotificationCenter sharedInstance] addObserver:self selector:@selector(viewInvisible:) name:kAdViewBecomeInvisibleNotification object:nil];        
        [[NotificationCenter sharedInstance] addObserver:self selector:@selector(invalidate:) name:kUnregisterAdNotification object:nil];
        [[NotificationCenter sharedInstance] addObserver:self selector:@selector(frameChanged:) name:kAdViewFrameChangedNotification object:nil];
#ifdef INCLUDE_LOCATION_MANAGER
        [[NotificationCenter sharedInstance] addObserver:self selector:@selector(locationDetected:) name:kNewLocationDetectedNotification object:nil];
        [[NotificationCenter sharedInstance] addObserver:self selector:@selector(headingDetected:) name:kLocationUpdateHeadingNotification object:nil];
#endif
        
        // setup our network reachability        
		NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
		[notificationCenter addObserver:self
							   selector:@selector(orientationChanged:)
								   name:UIDeviceOrientationDidChangeNotification
								 object:nil];
		[notificationCenter addObserver:self 
							   selector:@selector(keyboardWillShow:) 
								   name:UIKeyboardWillShowNotification
								 object:nil];
		[notificationCenter addObserver:self 
							   selector:@selector(keyboardWillHide:) 
								   name:UIKeyboardWillHideNotification
								 object:nil];
		[notificationCenter addObserver:self
							   selector:@selector(handleReachabilityChangedNotification:)
								   name:kReachabilityChangedNotification
								 object:nil];
        
		// start up reachability notifications
        Reachability* reachability = [Reachability reachabilityForInternetConnection];
        if ([reachability respondsToSelector:@selector(startNotifier)]) {
            [reachability startNotifier];
        }
        
        [[Accelerometer sharedInstance] addDelegate:self];
    }
    
    return self;
}

- (void)dealloc {
    self.adView = nil;
    self.webView = nil;
    [[NotificationCenter sharedInstance] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[Accelerometer sharedInstance] removeDelegate:self];
    [super dealloc];
}

- (BOOL)isOrmma:(NSURLRequest *)request {
    return [[[request URL] scheme] isEqualToString:ORMMA_SHAME];
}

- (void)webViewDidFinishLoad:(UIWebView*)webView {
    [self evalJS:[OrmmaHelper signalReadyInWebView]];
}

- (NSString*)getDefaultsJSCode {
    NSMutableString* result = [NSMutableString string];
    UIDevice* device = [UIDevice currentDevice];
    UIDeviceOrientation orientation = device.orientation;
    
    // Register up case 'Ormma' object
    [result appendString:[OrmmaHelper registerOrmmaUpCaseObject]];
    
    // Default state
    if ([webView isViewVisible]) {
        self.currentState = ORMMAStateDefault;
    } else {
        self.currentState = ORMMAStateHidden;
    }
    self.notHiddenState = self.currentState;
    [result appendString:[OrmmaHelper setState:self.currentState]];
    
    // Viewable
    [result appendString:[OrmmaHelper setViewable:[webView isViewVisible]]];
    
    // Network
    Reachability* reachability = [Reachability reachabilityForInternetConnection];
    [result appendString:[OrmmaHelper setNetwork:[reachability currentReachabilityStatus]]];
    
    // Frame size
    [result appendString:[OrmmaHelper setSize:self.webView.frame.size]];
    
    // Max size
    self.maxSize = self.webView.frame.size;
    [result appendString:[OrmmaHelper setMaxSize:self.maxSize]];
    
    // Screen size
	CGSize screenSize = [OrmmaHelper screenSizeForOrientation:orientation];	
    [result appendString:[OrmmaHelper setScreenSize:screenSize]];
    
    // Default position
    [result appendString:[OrmmaHelper setDefaultPosition:self.adView.frame]];
    
    // Orientation
    [result appendString:[OrmmaHelper setOrientation:orientation]];
    
    // Supports
    
    NSMutableArray* supports = [NSMutableArray array];
    [supports addObject:@"'level-1'"];
    [supports addObject:@"'level-2'"];
    [supports addObject:@"'orientation'"];
    [supports addObject:@"'network'"];
    [supports addObject:@"'location'"];
    [supports addObject:@"'screen'"];
    [supports addObject:@"'shake'"];
    [supports addObject:@"'size'"];
    [supports addObject:@"'tilt'"];
    [supports addObject:@"'audio'"];
    [supports addObject:@"'video'"];
    [supports addObject:@"'map'"];
    
	if (NSClassFromString(@"EKEventStore")) {
		[supports addObject:@"'calendar'"]; 
	}

#ifdef INCLUDE_LOCATION_MANAGER
    if ([[LocationManager sharedInstance].locationManager headingAvailable]) {
        [supports addObject:@"'heading'"];
    }
#endif
    
    if (device.model == @"iPhone") {
        [supports addObject:@"'phone'"];
    }
    
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil) {
        if ([mailClass canSendMail]) {
            [supports addObject:@"'email'"];
        }
    }
    
    Class smsClass = (NSClassFromString(@"MFMessageComposeViewController"));
    if (smsClass != nil) {
        if ([smsClass canSendText]) {
            [supports addObject:@"'sms'"];
        }
    }
    
    Class cameraClass = (NSClassFromString(@"UIImagePickerController"));
    if (cameraClass != nil) {
        if ([cameraClass isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [supports addObject:@"'camera'"];
        }
    }
    
    [result appendString:[OrmmaHelper setSupports:supports]]; 
    
    return result;
}

- (void)evalJS:(NSString*)js {
    if ([NSThread isMainThread]) {
        [self.webView stringByEvaluatingJavaScriptFromString:js];
    } else {
        [self.webView performSelectorOnMainThread:@selector(stringByEvaluatingJavaScriptFromString:) withObject:js waitUntilDone:NO];
    }
}

- (void)webView:(UIWebView *)view shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([self isOrmma:request]) {
        NSLog(@"%@", [[request URL] absoluteString]);
    }
}

- (void)viewVisible:(NSNotification*)notification {
	AdView* adViewNotify = [notification object];
    if (adViewNotify == self.adView) {
        self.currentState = self.notHiddenState;
        [self evalJS:[OrmmaHelper setState:self.currentState]];
        [self evalJS:[OrmmaHelper setViewable:YES]];
	}
}

- (void)viewInvisible:(NSNotification*)notification {
	AdView* adViewNotify = [notification object];
    if (adViewNotify == self.adView) {
        self.currentState = ORMMAStateHidden;
        [self evalJS:[OrmmaHelper setState:self.currentState]];
        [self evalJS:[OrmmaHelper setViewable:NO]];
	}
}

- (void)invalidate:(NSNotification*)notification {
	AdView* adViewNotify = [notification object];
    if (adViewNotify == self.adView) {
        self.adView = nil;
        self.webView = nil;
		[[NotificationCenter sharedInstance] removeObserver:self];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [[Accelerometer sharedInstance] removeDelegate:self];
	}
}

- (void)frameChanged:(NSNotification*)notification {
    NSDictionary* info = [notification object];
	AdView* adViewNotify = [info objectForKey:@"adView"];
    if (adViewNotify == self.adView) {
        NSValue* frameValue = [info objectForKey:@"newFrame"];
        CGRect newFrame = [frameValue CGRectValue];
        
        if (self.currentState != ORMMAStateResized) {
            if (self.currentState == self.notHiddenState) {
                self.notHiddenState = ORMMAStateResized;
                self.currentState = self.notHiddenState;
                [self evalJS:[OrmmaHelper setState:self.currentState]];
            } else {
                self.notHiddenState = ORMMAStateResized;
            }
        }
        
        [self evalJS:[OrmmaHelper setSize:newFrame.size]];
	}
}


#pragma mark - Notification Center Dispatch Methods


- (void)orientationChanged:(NSNotification *)notification {
	UIDevice *device = [UIDevice currentDevice];
    UIDeviceOrientation orientation = device.orientation;
    
    [self evalJS:[OrmmaHelper setOrientation:orientation]];
    
	CGSize screenSize = [OrmmaHelper screenSizeForOrientation:orientation];	
    [self evalJS:[OrmmaHelper setScreenSize:screenSize]];
    
    // TODO
    //[self.bridgeDelegate rotateExpandedWindowsToCurrentOrientation];
}


- (void)keyboardWillShow:(NSNotification *)notification {
    [self evalJS:[OrmmaHelper setKeyboardShow:true]];
}


- (void)keyboardWillHide:(NSNotification *)notification {
    [self evalJS:[OrmmaHelper setKeyboardShow:false]];
}


- (void)handleReachabilityChangedNotification:(NSNotification *)notification {
    Reachability* reachability = [Reachability reachabilityForInternetConnection];
	[self evalJS:[OrmmaHelper setNetwork:[reachability currentReachabilityStatus]]];
}

- (void)locationDetected:(NSNotification*)notification {
#ifdef INCLUDE_LOCATION_MANAGER
    CLLocation* location = [notification object];
    [self evalJS:[OrmmaHelper setLatitude:location.coordinate.latitude longitude:location.coordinate.longitude accuracy:location.horizontalAccuracy]];
#endif   
}

- (void)headingDetected:(NSNotification*)notification {
#ifdef INCLUDE_LOCATION_MANAGER
    CLHeading* heading = [notification object];
    [self evalJS:[OrmmaHelper setHeading:heading.trueHeading]];
#endif
}


#pragma mark - Accelerometer Delegete

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
	// Send accelerometer data
    [self evalJS:[OrmmaHelper setTilt:acceleration]];
	
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
        [self evalJS:[OrmmaHelper fireShakeEventInWebView]];
    }
}


@end
