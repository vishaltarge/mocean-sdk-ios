//
//  MASTExpandView.h
//  Copyright (c) Microsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MASTExpandView : UIView <UIWebViewDelegate> {
    CGRect                      _defaultFrame;
}

@property (assign) UIView*  adView;

- (void)loadUrl:(NSString*)url;
- (void)close;

@end