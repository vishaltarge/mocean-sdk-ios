//
//  OrmmaHelper.h
//  AdMobileSDK
//
//  Created by Constantine Mureev on 8/29/11.
//

#import <Foundation/Foundation.h>
#import "OrmmaAdaptor.h"
#import "Reachability.h"

@interface OrmmaHelper : NSObject

+ (void)registerOrmmaUpCaseObject:(UIWebView*)webView;
+ (void)signalReadyInWebView:(UIWebView*)webView;

+ (void)setState:(ORMMAState)state inWebView:(UIWebView*)webView;
+ (void)setNetwork:(NetworkStatus)status inWebView:(UIWebView*)webView;
+ (void)setSize:(CGSize)size inWebView:(UIWebView*)webView;
+ (void)setMaxSize:(CGSize)size inWebView:(UIWebView*)webView;
+ (void)setScreenSize:(CGSize)size inWebView:(UIWebView*)webView;
+ (void)setDefaultPosition:(CGRect)frame inWebView:(UIWebView*)webView;
+ (void)setOrientation:(UIDeviceOrientation)orientation inWebView:(UIWebView*)webView;
+ (void)setSupports:(NSArray*)supports inWebView:(UIWebView*)webView;
+ (void)setKeyboardShow:(BOOL)isShow inWebView:(UIWebView*)webView;
+ (void)setTilt:(UIAcceleration*)acceleration inWebView:(UIWebView*)webView;
+ (void)setHeading:(CGFloat)heading inWebView:(UIWebView*)webView;
+ (void)setLatitude:(CGFloat)latitude longitude:(CGFloat)longitude accuracy:(CGFloat)accuracy inWebView:(UIWebView*)webView;

+ (void)fireChangeEvent:(NSString*)value inWebView:(UIWebView*)webView;
+ (void)fireShakeEventInWebView:(UIWebView*)webView;

+ (CGSize)screenSizeForOrientation:(UIDeviceOrientation)orientation;

@end
