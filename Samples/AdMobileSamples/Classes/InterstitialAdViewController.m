//
//  RichInterstitialAdViewController.m
//  AdMobileSamples
//
//  Created by Slava Budnikov on 2/28/12.
//  Copyright (c) 2012 Team Force. All rights reserved.
//

#import "InterstitialAdViewController.h"

@implementation InterstitialAdViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
	
	_adView = [[MASTAdView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height) site:19829 zone:88269];
    _adView.contentAlignment = YES;
    CGFloat scale = [UIScreen mainScreen].scale;
    _adView.minSize = CGSizeMake(self.view.frame.size.width*scale, self.view.frame.size.height*scale);
    //_adView.type = AdTypeRichmedia;
    [_adView setBackgroundColor:[UIColor whiteColor]];
	_adView.showCloseButtonTime = 5;
	_adView.autocloseInterstitialTime = 15;
	
    [self.navigationController.view addSubview:_adView];
    
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
