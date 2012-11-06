//
//  MASTAdView
//
//  Created on 9/21/12.
//  Copyright (c) 2011, 2012 Mocean Mobile. All rights reserved.
//

#import "MASTAdBrowser.h"
#import "MASTBrowserBackPNG.h"
#import "MASTBrowserForwardPNG.h"


@interface MASTAdBrowser () <UIWebViewDelegate>
@property (nonatomic, strong) UIWebView* webView;
@property (nonatomic, strong) UIToolbar* toolbar;
@end

@implementation MASTAdBrowser

@synthesize delegate, URL;

- (void)dealloc
{
    
}

- (id)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.autoresizesSubviews = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (self.toolbar == nil)
    {
        self.toolbar = [UIToolbar new];
        self.toolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        self.toolbar.barStyle = UIBarStyleBlack;
        
        NSMutableArray* items = [NSMutableArray array];
        
        // Close
        UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                                                                              target:self
                                                                              action:@selector(toolbarClose:)];
        [items addObject:item];
        
        item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                             target:nil
                                                             action:nil];
        [items addObject:item];
        
        // Back
        NSData* buttonData = [NSData dataWithBytesNoCopy:MASTBrowserBack_png
                                                  length:MASTBrowserBack_png_len
                                            freeWhenDone:NO];
        
        UIImage* buttonImage = [UIImage imageWithData:buttonData];
        buttonImage = [UIImage imageWithCGImage:buttonImage.CGImage
                                          scale:2.0
                                    orientation:UIImageOrientationUp];
        
        item = [[UIBarButtonItem alloc] initWithImage:buttonImage
                                                style:UIBarButtonItemStylePlain
                                               target:self
                                               action:@selector(toolbarBack:)];
        
        [items addObject:item];
        
        item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                             target:nil
                                                             action:nil];
        [items addObject:item];
        

        // Forward
        buttonData = [NSData dataWithBytesNoCopy:MASTBrowserForward_png
                                          length:MASTBrowserForward_png_len
                                    freeWhenDone:NO];
        
        buttonImage = [UIImage imageWithData:buttonData];
        buttonImage = [UIImage imageWithCGImage:buttonImage.CGImage
                                          scale:2.0
                                    orientation:UIImageOrientationUp];
        
        item = [[UIBarButtonItem alloc] initWithImage:buttonImage
                                                style:UIBarButtonItemStylePlain
                                               target:self
                                               action:@selector(toolbarForward:)];
        [items addObject:item];
        
        item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                             target:nil
                                                             action:nil];
        [items addObject:item];
        
        
        // Reload
        item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                             target:self
                                                             action:@selector(toolbarReload:)];
        [items addObject:item];
        
        item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                             target:nil
                                                             action:nil];
        [items addObject:item];
        
        
        // Action
        item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                             target:self
                                                             action:@selector(toolbarAction:)];
        [items addObject:item];
        
        
        self.toolbar.items = items;
    }
    
    if (self.webView == nil)
    {
        self.webView = [[UIWebView alloc] initWithFrame:self.view.frame];
        self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        self.webView.allowsInlineMediaPlayback = YES;
        self.webView.mediaPlaybackRequiresUserAction = YES;
    }
    
    [self.view addSubview:self.webView];
    [self.view addSubview:self.toolbar];
}

- (void)viewWillAppear:(BOOL)animated
{
    CGRect frame = self.view.bounds;
    frame.size.height -= 44;
    self.webView.frame = frame;
    
    frame.origin.y = CGRectGetMaxY(frame);
    frame.size.height = 44;
    self.toolbar.frame = frame;
    
    if (self.webView.request == nil)
        [self load];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setURL:(NSURL *)url
{
    URL = [url copy];
    [self load];
}

- (void)load
{
    if (self.isViewLoaded == NO)
        return;
    
    NSURLRequest* request = [[NSURLRequest alloc] initWithURL:self.URL
                                                  cachePolicy:NSURLRequestReloadIgnoringCacheData
                                              timeoutInterval:10];
    
    [self.webView loadRequest:request];
}

#pragma mark - Toolbar Selectors

- (void)toolbarClose:(id)sender
{
    [self.delegate MASTAdBrowserClose:self];
}

- (void)toolbarBack:(id)sender
{
    [self.webView goBack];
}

- (void)toolbarForward:(id)sender
{
    [self.webView goForward];
}

- (void)toolbarReload:(id)sender
{
    [self.webView reload];
}

- (void)toolbarAction:(id)sender
{
    // TODO: Prompt user with action sheet vs. just jumping to Safari.
    
    [self.delegate MASTAdBrowserWillLeaveApplication:self];
    
    [[UIApplication sharedApplication] openURL:[self.webView.request URL]];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.delegate MASTAdBrowser:self didFailLoadWithError:error];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

@end
