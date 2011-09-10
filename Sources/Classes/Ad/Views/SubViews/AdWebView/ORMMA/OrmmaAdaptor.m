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

#define ORMMA_SHAME     @"ormma"

@interface OrmmaAdaptor()

@property (nonatomic, retain) UIWebView*        webView;
@property (nonatomic, retain) AdView*           adView;

@property (nonatomic, assign) ORMMAState        currentState;
@property (nonatomic, assign) CGSize            maxSize;

- (void)viewVisible:(NSNotification*)notification;
- (void)viewInvisible:(NSNotification*)notification;
- (void)invalidate:(NSNotification*)notification;

- (void)setDefaults;

@end

@implementation OrmmaAdaptor

@synthesize webView, adView, currentState, maxSize;

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
    UIApplication *app = [UIApplication sharedApplication];
    UIDeviceOrientation orientation = app.statusBarOrientation;
    
    // Default state
    if ([webView isViewVisible]) {
        self.currentState = ORMMAStateDefault;
        [OrmmaHelper setState:@"default" inWebView:self.webView];
    } else {
        self.currentState = ORMMAStateHidden;
        [OrmmaHelper setState:@"hidden" inWebView:self.webView];
    }
    
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
    
    // supports
    
    // supports: [ 'level-1', 'level-2', 'orientation', 'network', 'heading', 'location', 'screen', 'shake', 'size', 'tilt', 'sms', 'phone', 'email', 'audio', 'video', 'map'%@ ]
    
    [OrmmaHelper signalReadyInWebView:self.webView];
}

- (void)webView:(UIWebView *)view shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([self isOrmma:request]) {
        // check callbacks
    }
}

- (void)viewVisible:(NSNotification*)notification {
	AdView* adViewNotify = [notification object];
    if (adViewNotify == self.adView) {
		//
	}
}

- (void)viewInvisible:(NSNotification*)notification {
	AdView* adViewNotify = [notification object];
    if (adViewNotify == self.adView) {
		//
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
