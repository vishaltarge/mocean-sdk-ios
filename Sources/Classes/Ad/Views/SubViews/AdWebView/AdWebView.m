//
//  AdWebView.m
//  AdMobileSDK
//
//  Created by Constantine Mureev on 2/22/11.
//

#import "AdWebView.h"

#import "NotificationCenter.h"
#import "OrmmaAdaptor.h"
#import "UIWebViewAdditions.h"

@interface AdWebView()
@property (nonatomic, retain) UIWebView*        webView;
@property (nonatomic, retain) OrmmaAdaptor*     ormmaAdaptor;
@end

@implementation AdWebView

@synthesize adView, webView, ormmaAdaptor;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        if (frame.size.width == 0.0 && frame.size.height == 0.0) {
            frame = CGRectMake(frame.origin.x, frame.origin.y, 0, 1);
        }
        UIWebView* wView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
		wView.delegate = self;
        wView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[wView disableBouncesForWebView];
		
        wView.allowsInlineMediaPlayback = YES;
        wView.mediaPlaybackRequiresUserAction = NO;
        wView.opaque = NO;
        wView.backgroundColor = [UIColor clearColor];
        
        self.webView = wView;
        [wView release];

		[self addSubview:self.webView];

        _defaultFrame = self.frame;
        
        OrmmaAdaptor* oa = [[OrmmaAdaptor alloc] initWithWebView:self.webView];
        self.ormmaAdaptor = oa;
        [oa release];
    }
    return self;
}

- (void)dealloc {
    self.adView = nil;
	self.webView = nil;
    self.ormmaAdaptor = nil;
    
    [super dealloc];
}

- (void)loadData:(NSData *)data MIMEType:(NSString *)MIMEType textEncodingName:(NSString *)encodingName baseURL:(NSURL *)baseURL {
    [self.webView loadData:data MIMEType:MIMEType textEncodingName:encodingName baseURL:baseURL];
}


#pragma mark - UIWebViewDelegate


- (void)webViewDidFinishLoad:(UIWebView *)view {
    [self.ormmaAdaptor webViewDidFinishLoad:view];
    
    if (self.superview) {
        NSString* contentWidth = [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('contentwidth').offsetWidth"];
        NSString* contentHeight = [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('contentheight').offsetHeight"];
        
        NSMutableDictionary* senfInfo = [NSMutableDictionary dictionary];
        [senfInfo setObject:self.superview forKey:@"adView"];
        [senfInfo setObject:self forKey:@"subView"];
        [senfInfo setObject:contentWidth forKey:@"contentWidth"];
        [senfInfo setObject:contentHeight forKey:@"contentHeight"];
        [[NotificationCenter sharedInstance] postNotificationName:kReadyAdDisplayNotification object:senfInfo];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if (adView) {
        NSMutableDictionary* senfInfo = [NSMutableDictionary dictionary];
        [senfInfo setObject:adView forKey:@"adView"];
        [senfInfo setObject:self forKey:@"subView"];
        [[NotificationCenter sharedInstance] postNotificationName:kFailAdDisplayNotification object:senfInfo];
    }
}

- (BOOL)webView:(UIWebView *)view shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        if (adView) {
            NSMutableDictionary* info = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:request, adView, nil]
                                                                           forKeys:[NSArray arrayWithObjects:@"request", @"adView", nil]];
            
            [[NotificationCenter sharedInstance] postNotificationName:kOpenURLNotification object:info];
        }
        
		return NO;
	}
	else if (navigationType == UIWebViewNavigationTypeOther) {
        if ([self.ormmaAdaptor isOrmma:request]) {
            [self.ormmaAdaptor webView:view shouldStartLoadWithRequest:request navigationType:navigationType];
            return NO;
        } else {
            return YES;
        }
	}
    
	return NO;
}

@end