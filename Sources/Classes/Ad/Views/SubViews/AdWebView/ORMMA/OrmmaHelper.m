//
//  OrmmaHelper.m
//  AdMobileSDK
//
//  Created by Constantine Mureev on 8/29/11.
//  Copyright 2011 AdMobile Mobile. A subsidiary of Mojiva, Inc. All rights reserved.
//

#import "OrmmaHelper.h"

@implementation OrmmaHelper


+ (void)setState:(NSString*)state inWebView:(UIWebView*)webView {
    [OrmmaHelper fireChangeEvent:[NSString stringWithFormat:@"{ state: '%@' }", state] inWebView:webView];
}

+ (void)fireChangeEvent:(NSString*)value inWebView:(UIWebView*)webView {
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.ormmaview.fireChangeEvent( %@ );", value]];
}

@end
