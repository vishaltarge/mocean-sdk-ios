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
    CGRect adjustedFrame = super.view.frame;
    adjustedFrame.size.height -= [[UIApplication sharedApplication] statusBarFrame].size.height;
    
    // Place the view on the bottom.
    CGRect frame = super.adView.frame;
    frame.origin.y = CGRectGetMaxY(adjustedFrame) - frame.size.height;
    super.adView.frame = frame;
    
    // Update the autoresizing mask to include adjusting the top margin to cover 
    // the navigation bar and rotation.
    self.adView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | 
        UIViewAutoresizingFlexibleTopMargin;
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

@end
