//
//  MASTAdWebView.h
//  Copyright (c) Microsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OrmmaProtocols.h"

typedef void (^CompletionBlock)(NSError* error);

@interface MASTAdWebView : UIView <UIWebViewDelegate> {
    CGRect                      _defaultFrame;
}

@property (nonatomic, assign) UIView*               adView;
@property (nonatomic, assign) id <OrmmaDelegate>    ormmaDelegate;
@property (nonatomic, assign) id <OrmmaDataSource>  ormmaDataSource;

- (void)loadHTML:(NSString*)html completion:(CompletionBlock)completion;

@end