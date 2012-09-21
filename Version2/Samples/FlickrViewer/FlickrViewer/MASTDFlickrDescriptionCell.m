//
//  MASTDFlickrDescriptionCell.m
//  FlickrViewer
//
//  Copyright (c) 2012 mOcean Mobile. All rights reserved.
//

#import "MASTDFlickrDescriptionCell.h"


@interface MASTDFlickrDescriptionCell ()

@property (nonatomic, strong) IBOutlet UIWebView* webView;

@end


@implementation MASTDFlickrDescriptionCell

@synthesize desc;
@synthesize webView;


- (void)didMoveToSuperview
{
    self.webView.scrollView.scrollEnabled = NO;
}

#pragma mark

- (void)setDesc:(NSString *)d
{
    desc = d;
    [self.webView loadHTMLString:desc baseURL:nil];
}

#pragma mark -

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    // All navigation from the web view should be handled by Safari not the cell.
    if (navigationType == UIWebViewNavigationTypeLinkClicked)
    {
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }
    
    return YES;
}

@end
