//
//  OrmmaHelper.h
//  AdMobileSDK
//
//  Created by Constantine Mureev on 8/29/11.
//  Copyright 2011 AdMobile Mobile. A subsidiary of Mojiva, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrmmaAdaptor.h"

@interface OrmmaHelper : NSObject

+ (void)signalReadyInWebView:(UIWebView*)webView;
+ (void)setState:(NSString*)state inWebView:(UIWebView*)webView;
+ (void)fireChangeEvent:(NSString*)value inWebView:(UIWebView*)webView;

@end
