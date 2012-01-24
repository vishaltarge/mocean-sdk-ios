//
//  WebKitInfo.h
//  AdMobileSDK
//
//  Created by Constantine Mureev on 3/24/11.
//

#import <Foundation/Foundation.h>

#import "NotificationCenter.h"


@interface WebKitInfo : NSObject <UIWebViewDelegate> {
    UIWebView*          _webView;
}

@property (retain) NSString*        ua;

+ (WebKitInfo*)sharedInstance;
+ (void)releaseSharedInstance;


@end
