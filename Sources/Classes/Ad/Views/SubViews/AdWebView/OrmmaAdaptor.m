//
//  OrmmaAdaptor.m
//  AdMobileSDK
//
//  Created by Constantine Mureev on 8/23/11.
//

#import "OrmmaAdaptor.h"

#define ORMMA_SHAME     @"ormma"

@interface OrmmaAdaptor()

@property (nonatomic, retain) UIWebView*        webView;
@property (nonatomic, retain) ScriptObject*     scriptObject;

- (void)registerEnvironment;
- (void)registerJSCallBacks;

@end

@implementation OrmmaAdaptor

@synthesize webView, scriptObject;

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
}

- (void)webView:(UIWebView *)view shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([self isOrmma:request]) {
        [scriptObject webView:view shouldStartLoadWithRequest:request navigationType:navigationType];
    }
}

- (void)registerEnvironment {
    [self.webView stringByEvaluatingJavaScriptFromString:@"function() {\n"
     "window.Ormma = {\n"
     "\"use-background\":false,\n"
     "\"background-color\" : \"#000000\",\n"
     "\"background-opacity\" : 1.0,\n"
     "\"is-modal\" : true}"];
}

- (void)registerJSCallBacks {
    [self.webView stringByEvaluatingJavaScriptFromString:@"var waitVar = ''; function getState() { checkRealState(); while(waitVar == '') { var i = 0; i++; } return waitVar };"];
    
    BOOL result = [scriptObject registerCallbackForFunction:@"function checkRealState()"
                                               functionCode:@""
                                                argumentVar:nil
                                                        key:@"checkRealState"
                                                  urlSchame:ORMMA_SHAME
                                                   delegate:self];
    result = [scriptObject registerCallbackForFunction:@"function alertObj(text)"
                                          functionCode:@""
                                           argumentVar:@"text"
                                                   key:@"alert"
                                             urlSchame:ORMMA_SHAME
                                              delegate:self];
    if (result) {
        [self.webView stringByEvaluatingJavaScriptFromString:@"setTimeout(alertObj(getState()), 1000);"];
    }
    
    /*
     result = [scriptObject registerCallbackForFunction:@"function testFunction(arg)"
     functionCode:@"var result = 'getState';"
     argumentVar:@"result"
     key:@"testKey"
     urlSchame:ORMMA_SHAME
     delegate:self];
     */
}

- (void)callBacktFire:(NSString*)key result:(NSString*)result {
    if ([key isEqualToString:@"checkRealState"]) {
        [self.webView stringByEvaluatingJavaScriptFromString:@"waitVar = 'real state value';"];
    } else if ([key isEqualToString:@"alert"]) {
        NSLog(@"Alert: %@", result);
    }
}

@end
