//
//  MASTUIWebViewAdditions.h
//  Copyright (c) Microsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// do nothing, just for make this catagory linked
void useCatagory1();

@interface UIWebView (MASTWebView)

- (void)disableBouncesForWebView;

@end
