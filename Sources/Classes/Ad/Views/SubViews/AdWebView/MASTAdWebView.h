//
//  AdWebView.h
//  AdMobileSDK
//
//  Created by Constantine Mureev on 2/22/11.
//

#import <UIKit/UIKit.h>

@interface AdWebView : UIView <UIWebViewDelegate> {
    CGRect                      _defaultFrame;
}

@property (assign) UIView*  adView;

- (void)loadData:(NSData *)data MIMEType:(NSString *)MIMEType textEncodingName:(NSString *)encodingName baseURL:(NSURL *)baseURL;
- (void)closeOrmma;

@end