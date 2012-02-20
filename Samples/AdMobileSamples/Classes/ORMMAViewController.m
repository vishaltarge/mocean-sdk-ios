//
//  ORMMAViewController.m
//  AdMobileSamples
//
//  Created by Slava on 5/17/11.
//  Copyright 2011 Team Force. All rights reserved.
//

#import "ORMMAViewController.h"

@implementation ORMMAViewController

-(NSInteger)getBannerZone
{
	return 53923;
}

-(CGRect)getBannerFrame
{
	return  CGRectMake(0, 0, 320, 240);
}

- (void)viewDidLoad {
	[super viewDidLoad];

	_adView.updateTimeInterval = 30;
    _adView.delegate = self;
    _adView.logMode = AdLogModeAll;
    _adView.type = AdTypeRichmedia;
}

@end