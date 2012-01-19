//
//  SimpleBannerRetinaViewController.m
//  AdMobileSamples
//
//  Created by Constantine Mureev on 9/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SimpleBannerRetinaViewController.h"

@implementation SimpleBannerRetinaViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
    self.view.backgroundColor = [UIColor colorWithRed:35 /255.0f
                                                green:31 /255.0f
                                                 blue:32 /255.0f
                                                alpha:1.0];
    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default.png"]];
    imageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:imageView];
    [imageView release];
    
	_adView = [[AdView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100.0) site:8061 zone:20249];
    
    // get only ad with size 640x100
    _adView.minSize = CGSizeMake(640, 100);
    _adView.maxSize = CGSizeMake(640, 100);
    
    [self.view addSubview:_adView];
    
    UIBarButtonItem *update = [[UIBarButtonItem alloc] initWithTitle:@"Update" style:UIBarButtonItemStylePlain target:_adView action:@selector(update)];
    [self.navigationItem setRightBarButtonItem:update];
    [update release];
}

- (void) dealloc
{
	[_adView release];
	[super dealloc];
}

@end
