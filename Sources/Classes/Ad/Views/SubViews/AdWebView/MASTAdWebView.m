//
//  MASTAdWebView.m
//  Copyright (c) Microsoft. All rights reserved.
//

#import "MASTAdWebView.h"

#import "MASTOrmmaAdaptor.h"
#import "MASTOrmmaConstants.h"
#import "MASTUIWebViewAdditions.h"
#import "MASTWebkitInfo.h"

@interface MASTAdWebView()

@property (nonatomic, retain) UIWebView*        webView;
@property (nonatomic, retain) MASTOrmmaAdaptor*  ormmaAdaptor;
@property (nonatomic, copy) CompletionBlock     completion;

@end

@implementation MASTAdWebView

@synthesize adView, ormmaDelegate, ormmaDataSource;
@synthesize webView, ormmaAdaptor, completion;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        if (frame.size.width == 0.0 && frame.size.height == 0.0) {
            frame = CGRectMake(frame.origin.x, frame.origin.y, 0, 1);
        }
        UIWebView* wView = [[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)] autorelease];
        self.webView = wView;
		self.webView.delegate = self;
        self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self.webView disableBouncesForWebView];
		
        self.webView.allowsInlineMediaPlayback = YES;
        self.webView.mediaPlaybackRequiresUserAction = NO;
        self.webView.opaque = NO;
        self.webView.backgroundColor = [UIColor clearColor];

		[self addSubview:self.webView];

        _defaultFrame = self.frame;
    }
    return self;
}

- (void)dealloc {
    [self.ormmaAdaptor invalidate];
    
    self.adView = nil;
    self.ormmaDelegate = nil;
    self.ormmaDataSource = nil;
	self.webView = nil;
    self.ormmaAdaptor = nil;
    self.completion = nil;
    
    [super dealloc];
}

- (void)loadHTML:(NSString*)html completion:(CompletionBlock)block {
    self.completion = block;
    self.ormmaAdaptor = [[[MASTOrmmaAdaptor alloc] initWithWebView:self.webView adView:self.adView] autorelease];
    self.ormmaAdaptor.ormmaDelegate = self.ormmaDelegate;
    self.ormmaAdaptor.ormmaDataSource = self.ormmaDataSource;
    
    html = [NSString stringWithFormat:@"<html><head><meta name=\"viewport\" content=\"width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;\"/><style>body { margin:0; padding:0; }</style><script type=\"text/javascript\">%@</script><script type=\"text/javascript\">%@</script></head><body>%@</body></html>", ORMMA_JS, [self.ormmaAdaptor getDefaultsJSCode], html];
    
    [self.webView loadHTMLString:html baseURL:nil];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)view {
    [self.ormmaAdaptor webViewDidFinishLoad:view];
    if (self.completion) {
        self.completion(nil);
        self.completion = nil;
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if (self.completion) {
        self.completion(error);
        self.completion = nil;
    }
}

- (BOOL)webView:(UIWebView *)view shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([self.ormmaAdaptor isOrmma:request]) {
        [self.ormmaAdaptor webView:view shouldStartLoadWithRequest:request navigationType:navigationType];
        return NO;
    } else {
        if (navigationType == UIWebViewNavigationTypeLinkClicked) {
            [[UIApplication sharedApplication] openURL:[request URL]];
            
            return NO;
        }
        else if (navigationType == UIWebViewNavigationTypeOther) {
            return YES;
        }
    }
    
	return NO;
}

@end