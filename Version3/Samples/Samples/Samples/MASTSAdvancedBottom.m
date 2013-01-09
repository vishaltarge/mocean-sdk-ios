//
//  MASTSAdvancedBottom.m
//  AdMobileSamples
//
//  Created by Jason Dickert on 4/18/12.
//  Copyright (c) 2012 mOcean Mobile. All rights reserved.
//

#import "MASTSAdvancedBottom.h"

@interface MASTSAdvancedBottom ()

@end

@implementation MASTSAdvancedBottom

- (void)loadView
{
    [super loadView];

    // Adjust for the status bar, the navigation bar space will trigger an update layout.
    CGRect adjustedFrame = [[UIScreen mainScreen] bounds];
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]))
        adjustedFrame = CGRectMake(adjustedFrame.origin.x, adjustedFrame.origin.y,
                                   adjustedFrame.size.height, adjustedFrame.size.width);

    adjustedFrame.size.height -= [[UIApplication sharedApplication] statusBarFrame].size.height;
    
    // Place the view on the bottom and size it to a fixed 320.
    CGRect frame = super.adView.frame;
    frame.size.width = 320;
    frame.origin.y = CGRectGetMaxY(adjustedFrame) - frame.size.height;
    super.adView.frame = frame;
    
    // Update the autoresizing mask to include adjusting the top margin to cover 
    // the navigation bar and rotation and remove the width resizing and add the
    // left margine to center it.
    self.adView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | 
        UIViewAutoresizingFlexibleTopMargin;
    
    self.adConfigController.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSInteger site = 19829;
    NSInteger zone = 98465;
    
    super.adView.site = site;
    super.adView.zone = zone;
    
    super.adView.backgroundColor = [UIColor clearColor];
    
    super.adConfigController.site = site;
    super.adConfigController.zone = zone;
}

#pragma mark -

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
