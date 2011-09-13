//
//  OrmmaAdaptor.h
//  AdMobileSDK
//
//  Created by Constantine Mureev on 8/23/11.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MFMessageComposeViewController.h>

#ifdef INCLUDE_LOCATION_MANAGER
#import <CoreLocation/CoreLocation.h>
#endif

#import "AdView.h"

typedef enum ORMMAStateEnum {
	ORMMAStateHidden = -1,
	ORMMAStateDefault = 0,
	ORMMAStateResized,
	ORMMAStateExpanded
} ORMMAState;

@interface OrmmaAdaptor : NSObject

- (id)initWithWebView:(UIWebView*)webView adView:(AdView*)ad;

- (NSString*)getDefaultsJSCode;

- (BOOL)isOrmma:(NSURLRequest *)request; 
- (void)webViewDidFinishLoad:(UIWebView*)webView;
- (void)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;

@end
