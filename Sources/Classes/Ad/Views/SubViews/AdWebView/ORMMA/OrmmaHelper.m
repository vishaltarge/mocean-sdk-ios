//
//  OrmmaHelper.m
//  AdMobileSDK
//
//  Created by Constantine Mureev on 8/29/11.
//

#import "OrmmaHelper.h"

@implementation OrmmaHelper


+ (void)signalReadyInWebView:(UIWebView*)webView {
    [webView stringByEvaluatingJavaScriptFromString:@"window.ormma.signalReady();"];
}

+ (void)setState:(NSString*)state inWebView:(UIWebView*)webView {
    [OrmmaHelper fireChangeEvent:[NSString stringWithFormat:@"{state: %@}", state] inWebView:webView];
}

+ (void)setNetwork:(NSString*)network inWebView:(UIWebView*)webView {
    [OrmmaHelper fireChangeEvent:[NSString stringWithFormat:@"{network: %@}", network] inWebView:webView];
}

+ (void)setSize:(CGSize)size inWebView:(UIWebView*)webView {
    [OrmmaHelper fireChangeEvent:[NSString stringWithFormat:@"{size: { width: %f, height: %f }}", size.width, size.height] inWebView:webView];
}

+ (void)setMaxSize:(CGSize)size inWebView:(UIWebView*)webView {
    [OrmmaHelper fireChangeEvent:[NSString stringWithFormat:@"{maxSize: { width: %f, height: %f }}", size.width, size.height] inWebView:webView];
}

+ (void)setScreenSize:(CGSize)size inWebView:(UIWebView*)webView {
    [OrmmaHelper fireChangeEvent:[NSString stringWithFormat:@"{screenSize: { width: %f, height: %f }}", size.width, size.height] inWebView:webView];
}

+ (void)setDefaultPosition:(CGRect)frame inWebView:(UIWebView*)webView {
    [OrmmaHelper fireChangeEvent:[NSString stringWithFormat:@"defaultPosition: { x: %f, y: %f, width: %f, height: %f }", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height] inWebView:webView];
}

+ (void)setOrientation:(UIDeviceOrientation)orientation inWebView:(UIWebView*)webView {
    NSInteger orientationAngle = -1;
	switch (orientation) {
		case UIDeviceOrientationPortrait:
			orientationAngle = 0;
			break;
		case UIDeviceOrientationPortraitUpsideDown:
			orientationAngle = 180;
			break;
		case UIDeviceOrientationLandscapeLeft:
			orientationAngle = 270;
			break;
		case UIDeviceOrientationLandscapeRight:
			orientationAngle = 90;
			break;
		default:
			orientationAngle = -1;
			break;
	}
    
    [OrmmaHelper fireChangeEvent:[NSString stringWithFormat:@"{orientation: %i}", orientationAngle] inWebView:webView];
}

+ (void)fireChangeEvent:(NSString*)value inWebView:(UIWebView*)webView {
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.ormmaview.fireChangeEvent(%@);", value]];
}

+ (CGSize)screenSizeForOrientation:(UIDeviceOrientation)orientation {
	CGSize size;
	UIScreen *screen = [UIScreen mainScreen];
	CGSize screenSize = screen.bounds.size;	
	if (UIDeviceOrientationIsLandscape(orientation)) {
		// Landscape Orientation, reverse size values
		size.width = screenSize.height;
		size.height = screenSize.width;
	} else {
		// portrait orientation, use normal size values
		size.width = screenSize.width;
		size.height = screenSize.height;
	}
	return size;
}

@end
