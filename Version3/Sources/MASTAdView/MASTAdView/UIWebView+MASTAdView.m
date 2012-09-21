//
//  UIWebView+MASTAdView.m
//  MRAID2
//
//  Created by Jason Dickert on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIWebView+MASTAdView.h"

@implementation UIWebView (MASTAdView)

- (void)disableScrolling
{
    UIScrollView* scrollView = nil;
    
    if ([self respondsToSelector:@selector(scrollView)])
    {
        scrollView = [self scrollView];
    }
    else
    {
        for (id sv in [self subviews])
        {
            if ([sv isKindOfClass:[UIScrollView class]])
            {
                scrollView = sv;
                break;
            }
        }
    }

    [scrollView setContentInset:UIEdgeInsetsZero];
    [scrollView setScrollEnabled:NO];
    [scrollView setBounces:NO];
}

@end
