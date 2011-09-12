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

#define ORMMA_SHAME     @"ormma"

@interface OrmmaAdaptor()

@property (nonatomic, retain) UIWebView*        webView;
@property (nonatomic, retain) AdView*           adView;

@property (nonatomic, assign) ORMMAState        currentState;
@property (nonatomic, assign) ORMMAState        notHiddenState;
@property (nonatomic, assign) CGSize            maxSize;

- (void)viewVisible:(NSNotification*)notification;
- (void)viewInvisible:(NSNotification*)notification;
- (void)invalidate:(NSNotification*)notification;

- (void)setDefaults;

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
    }
    
    return self;
}

- (void)dealloc {
    self.webView = nil;
    [super dealloc];
}

- (BOOL)isOrmma:(NSURLRequest *)request {
    return [[[request URL] scheme] isEqualToString:ORMMA_SHAME];
}

- (void)webViewDidFinishLoad:(UIWebView*)webView {
    [self setDefaults];
}

- (void)setDefaults {
    UIDevice* device = [UIDevice currentDevice];
    UIDeviceOrientation orientation = device.orientation;
    
    // Default state
    if ([webView isViewVisible]) {
        self.currentState = ORMMAStateDefault;
    } else {
        self.currentState = ORMMAStateHidden;
    }
    self.notHiddenState = self.currentState;
    [OrmmaHelper setState:self.currentState inWebView:self.webView];
    
    // Network
    NSString* network = nil;
    Reachability* reachability = [Reachability reachabilityForInternetConnection];
	switch ([reachability currentReachabilityStatus]) {
		case ReachableViaWWAN:
			network = @"cell";
            break;
		case ReachableViaWiFi:
			network = @"wifi";
            break;
        default:
			network = @"offline";
            break;
	}
    if (network) {
        [OrmmaHelper setNetwork:network inWebView:self.webView];
    }
    
    // Frame size
    [OrmmaHelper setSize:self.webView.frame.size inWebView:self.webView];
    
    // Max size
    self.maxSize = self.webView.frame.size;
    [OrmmaHelper setMaxSize:self.maxSize inWebView:self.webView];
    
    // Screen size
	CGSize screenSize = [OrmmaHelper screenSizeForOrientation:orientation];	
    [OrmmaHelper setScreenSize:screenSize inWebView:self.webView];
    
    // Default position
    [OrmmaHelper setDefaultPosition:self.adView.frame inWebView:self.webView];
    
    // Orientation
    [OrmmaHelper setOrientation:orientation inWebView:self.webView];
    
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
    
    [OrmmaHelper setSupports:supports inWebView:self.webView];
    
    // Done!    
    [OrmmaHelper signalReadyInWebView:self.webView];
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
        [OrmmaHelper setState:self.currentState inWebView:self.webView];
	}
}

- (void)viewInvisible:(NSNotification*)notification {
	AdView* adViewNotify = [notification object];
    if (adViewNotify == self.adView) {
        self.currentState = ORMMAStateHidden;
        [OrmmaHelper setState:self.currentState inWebView:self.webView];
	}
}

- (void)invalidate:(NSNotification*)notification {
	AdView* adViewNotify = [notification object];
    if (adViewNotify == self.adView) {
        self.adView = nil;
        self.webView = nil;
		[[NotificationCenter sharedInstance] removeObserver:self];
	}
}



@end
