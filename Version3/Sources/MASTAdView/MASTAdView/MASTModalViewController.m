//
//  MASTModalViewController.m
//  MASTAdView
//
//  Created on 1/2/13.
//  Copyright (c) 2013 Mocean Mobile. All rights reserved.
//

#import "MASTModalViewController.h"

@interface MASTModalViewController ()

@property (nonatomic, assign) UIInterfaceOrientation forcedOrientation;

@end

@implementation MASTModalViewController

@synthesize delegate, allowRotation;
@synthesize forcedOrientation;

- (id)init
{
    self = [super init];
    if (self)
    {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        self.forcedOrientation = UIInterfaceOrientationPortrait;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.opaque = YES;
    self.view.backgroundColor = [UIColor blackColor];
    
    self.view.autoresizesSubviews = YES;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight |
        UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
        UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if (self.allowRotation)
        return YES;
    
    if (toInterfaceOrientation == self.forcedOrientation)
        return YES;
    
    return NO;
}

- (BOOL)shouldAutorotate
{
    if (self.allowRotation)
        return YES;
    
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return self.forcedOrientation;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if (self.allowRotation)
        return UIInterfaceOrientationMaskAll;
    
    switch (self.forcedOrientation)
    {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
            return UIInterfaceOrientationPortrait;

        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            return UIInterfaceOrientationMaskLandscape;
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if ([self.delegate respondsToSelector:@selector(MASTModalViewControllerDidRotate:)])
    {
        [self.delegate MASTModalViewControllerDidRotate:self];
    }
}

- (void)forceRotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    self.forcedOrientation = interfaceOrientation;
    
    UIViewController* presentingController = self.parentViewController;
    
    if ([self respondsToSelector:@selector(presentingViewController)])
    {
        presentingController = [self presentingViewController];
    }
    
    if ([self respondsToSelector:@selector(dismissViewControllerAnimated:completion:)])
    {
        [self dismissViewControllerAnimated:NO completion:^
        {
            [presentingController presentModalViewController:self animated:NO];
        }];
    }
    else
    {
        [self dismissModalViewControllerAnimated:NO];
        [presentingController presentModalViewController:self animated:NO];
    }
}

@end
