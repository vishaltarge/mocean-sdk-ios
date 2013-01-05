//
//  MASTModalViewController.m
//  MASTAdView
//
//  Created on 1/2/13.
//  Copyright (c) 2013 Mocean Mobile. All rights reserved.
//

#import "MASTModalViewController.h"

@interface MASTModalViewController ()

@end

@implementation MASTModalViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
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
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait)
        return YES;
    
    return NO;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (NSUInteger)supportedInterfaceOrientationsXXX
{
    return UIInterfaceOrientationPortrait;
}

@end
