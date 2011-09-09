//
//  OrmmaAdaptor.m
//  AdMobileSDK
//
//  Created by Constantine Mureev on 8/23/11.
//

#import "OrmmaAdaptor.h"
#import "OrmmaConstants.h"
#import "OrmmaHelper.h"

#define ORMMA_SHAME     @"ormma"

@interface OrmmaAdaptor()

@property (nonatomic, retain) UIWebView*        webView;
@property (nonatomic, assign) ORMMAState        currentState;

- (void)setDefaults;

@end

@implementation OrmmaAdaptor

@synthesize webView, currentState;

- (id)initWithWebView:(UIWebView*)view {
    self = [super init];
    if (self) {
        self.webView = view;
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
	self.currentState = ORMMAStateDefault;
    [OrmmaHelper setState:@"default" inWebView:self.webView];
    
    [OrmmaHelper signalReadyInWebView:self.webView];
}

- (void)webView:(UIWebView *)view shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([self isOrmma:request]) {
        // check callbacks
    }
}

@end
