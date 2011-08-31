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
@property (nonatomic, retain) ScriptObject*     scriptObject;
@property (nonatomic, assign) ORMMAState        currentState;

- (void)registerEnvironment;
- (void)registerJSCallBacks;
- (void)setDefaults;

@end

@implementation OrmmaAdaptor

@synthesize webView, scriptObject, currentState;

- (id)initWithWebView:(UIWebView*)view {
    self = [super init];
    if (self) {
        self.webView = view;
        
        ScriptObject* so = [ScriptObject new];
        so.webView = self.webView;
        self.scriptObject = so;
        [so release];
    }
    
    return self;
}

- (void)dealloc {
    self.webView = nil;
    self.scriptObject = nil;
    [super dealloc];
}

- (BOOL)isOrmma:(NSURLRequest *)request {
    return [[[request URL] scheme] isEqualToString:ORMMA_SHAME];
}

- (void)webViewDidFinishLoad:(UIWebView*)webView {
    [self registerEnvironment];
    [self registerJSCallBacks];
    [self setDefaults];
}

- (void)webView:(UIWebView *)view shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([self isOrmma:request]) {
        [scriptObject webView:view shouldStartLoadWithRequest:request navigationType:navigationType];
    }
}

- (void)setDefaults {    
	self.currentState = ORMMAStateDefault;
    
    NSString* properties = @"{ state: 'default', network: 'wifi', size: { width: 320.000000, height: 50.000000 }, maxSize: { width: 320.000000, height: 250.000000 }, screenSize: { width: 320.000000, height: 480.000000 }, defaultPosition: { x: 0.000000, y: 20.000000, width: 320.000000, height: 50.000000 }, orientation: 0, supports: [ 'level-1', 'level-2', 'orientation', 'network', 'heading', 'location', 'screen', 'shake', 'size', 'tilt', 'sms', 'phone', 'email', 'audio', 'video', 'map', 'email', 'location', 'calendar' ] }";
    
	//[OrmmaHelper setState:@"default" inWebView:self.webView];
    [OrmmaHelper fireChangeEvent:properties inWebView:self.webView];
    [OrmmaHelper setState:@"default" inWebView:self.webView];
}

- (void)registerEnvironment {
    [self.webView stringByEvaluatingJavaScriptFromString:ORMMA_BRIDGE];
    [self.webView stringByEvaluatingJavaScriptFromString:ORMMA_JS];
}

- (void)registerJSCallBacks {
}

- (void)callBacktFire:(NSString*)key result:(NSString*)result {
    if ([key isEqualToString:@"checkRealState"]) {
        [self.webView stringByEvaluatingJavaScriptFromString:@"waitVar = 'real state value';"];
    } else if ([key isEqualToString:@"alert"]) {
        NSLog(@"Alert: %@", result);
    }
}

@end
