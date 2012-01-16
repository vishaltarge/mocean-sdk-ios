//
//  ORMMAViewController.m
//  AdMobileSamples
//
//  Created by Slava on 5/17/11.
//  Copyright 2011 Team Force. All rights reserved.
//

#import "ORMMAViewController.h"

@implementation ORMMAViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
    self.view.backgroundColor = [UIColor colorWithRed:35 /255.0f
                                                green:31 /255.0f
                                                 blue:32 /255.0f
                                                alpha:1.0];
    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default.png"]];
    imageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:imageView];
    [imageView release];
	
	
	_adView = [[AdView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 416) site:8061 zone:53923];
	_adView.updateTimeInterval = 180;
    _adView.delegate = self;
    _adView.logMode = AdLogModeAll;
    _adView.type = AdTypeRichmedia;
	[self.view addSubview:_adView];
    
    UIButton *btnStartTimer = [[UIButton alloc] initWithFrame:CGRectMake(10.0, 100.0, 100.0, 45.0)];
    [btnStartTimer setTitle:@"Start timer" forState:UIControlStateNormal];
    [btnStartTimer addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnStartTimer];
}

- (void)buttonClick {
    [NSTimer scheduledTimerWithTimeInterval:10.0 target:_adView selector:@selector(stopEverythingAndNotfiyDelegateOnCleanup) userInfo:nil repeats:NO];
}

- (void) dealloc
{
    _adView.delegate = nil;
	[_adView release];
	[super dealloc];
}

@end