//
//  OrmmaHelper.h
//  AdMobileSDK
//
//  Created by Constantine Mureev on 8/29/11.
//

#import <Foundation/Foundation.h>
#import "OrmmaAdaptor.h"

@interface OrmmaHelper : NSObject

+ (void)signalReadyInWebView:(UIWebView*)webView;

+ (void)setState:(NSString*)state inWebView:(UIWebView*)webView;
+ (void)setNetwork:(NSString*)network inWebView:(UIWebView*)webView;
+ (void)setSize:(CGSize)size inWebView:(UIWebView*)webView;
+ (void)setMaxSize:(CGSize)size inWebView:(UIWebView*)webView;
+ (void)setScreenSize:(CGSize)size inWebView:(UIWebView*)webView;
+ (void)setDefaultPosition:(CGRect)frame inWebView:(UIWebView*)webView;
+ (void)setOrientation:(UIDeviceOrientation)orientation inWebView:(UIWebView*)webView;

+ (void)fireChangeEvent:(NSString*)value inWebView:(UIWebView*)webView;

+ (CGSize)screenSizeForOrientation:(UIDeviceOrientation)orientation;

@end
