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

+ (void)setState:(ORMMAState)state inWebView:(UIWebView*)webView {
    if (state == ORMMAStateDefault) {
        [OrmmaHelper fireChangeEvent:[NSString stringWithFormat:@"{state: 'default'}", state] inWebView:webView];
    } else if (state == ORMMAStateExpanded) {
        [OrmmaHelper fireChangeEvent:[NSString stringWithFormat:@"{state: 'expanded'}", state] inWebView:webView];
    } else if (state == ORMMAStateHidden) {
        [OrmmaHelper fireChangeEvent:[NSString stringWithFormat:@"{state: 'hidden'}", state] inWebView:webView];
    } else if (state == ORMMAStateResized) {
        [OrmmaHelper fireChangeEvent:[NSString stringWithFormat:@"{state: 'resized'}", state] inWebView:webView];
    }
}

+ (void)setNetwork:(NetworkStatus)status inWebView:(UIWebView*)webView {
    NSString* network = nil;
    switch (status) {
		case ReachableViaWWAN:
			network = @"cell";
            break;
		case ReachableViaWiFi:
			network = @"wifi";
            break;
        default:
			network = @"offline";
            break;
	}
    if (network) {
        [OrmmaHelper fireChangeEvent:[NSString stringWithFormat:@"{network: '%@'}", network] inWebView:webView];
    }
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

+ (void)setSupports:(NSArray*)supports inWebView:(UIWebView*)webView {
    NSString* value = [supports componentsJoinedByString:@", "];
    [OrmmaHelper fireChangeEvent:[NSString stringWithFormat:@"{supports: [%@]}", value] inWebView:webView];
}

+ (void)setKeyboardShow:(BOOL)isShow inWebView:(UIWebView*)webView {
    if (isShow) {
        [OrmmaHelper fireChangeEvent:@"{keyboardState: true}" inWebView:webView];
    } else {
        [OrmmaHelper fireChangeEvent:@"{keyboardState: false}" inWebView:webView];
    }
}

+ (void)setTilt:(UIAcceleration*)acceleration inWebView:(UIWebView*)webView {
    [OrmmaHelper fireChangeEvent:[NSString stringWithFormat:@"{tilt: { x: %f, y: %f, z: %f }}", acceleration.x, acceleration.y, acceleration.z] inWebView:webView];
}

+ (void)setHeading:(CGFloat)heading inWebView:(UIWebView*)webView {
    [OrmmaHelper fireChangeEvent:[NSString stringWithFormat:@"{heading: %f }", heading] inWebView:webView];
}

+ (void)setLatitude:(CGFloat)latitude longitude:(CGFloat)longitude accuracy:(CGFloat)accuracy inWebView:(UIWebView*)webView {
    [OrmmaHelper fireChangeEvent:[NSString stringWithFormat:@"{location: { lat: %f, lon: %f, acc: %f }}", latitude, longitude, accuracy] inWebView:webView];
}



+ (void)fireChangeEvent:(NSString*)value inWebView:(UIWebView*)webView {
    if ([NSThread isMainThread]) {
        [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.ormmaview.fireChangeEvent(%@);", value]];
    } else {
        [webView performSelectorOnMainThread:@selector(stringByEvaluatingJavaScriptFromString:) withObject:[NSString stringWithFormat:@"window.ormmaview.fireChangeEvent(%@);", value] waitUntilDone:NO];
    }
}

+ (void)fireShakeEventInWebView:(UIWebView*)webView {
    [webView stringByEvaluatingJavaScriptFromString:@"window.ormmaview.fireShakeEvent();"];
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
