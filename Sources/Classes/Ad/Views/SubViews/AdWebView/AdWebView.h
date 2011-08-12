//
//  AdWebView.h
//  AdMobileSDK
//
//  Created by Constantine Mureev on 2/22/11.
//

#import <UIKit/UIKit.h>
#import "ORMMAJavascriptBridge.h"
#import <MediaPlayer/MediaPlayer.h>

@interface AdWebView : UIView <UIWebViewDelegate, ORMMAJavascriptBridgeDelegate>
{
    UIWebView*                  _webView;
    ORMMAJavascriptBridge*      _javascriptBridge;
    CGRect                      _defaultFrame;
    MPMoviePlayerController*    _player;
}

@property (assign) UIView*  adView;

- (void)loadData:(NSData *)data MIMEType:(NSString *)MIMEType textEncodingName:(NSString *)encodingName baseURL:(NSURL *)baseURL;
- (void)injectORMMAStateIntoWebView:(UIWebView *)webView;

@end