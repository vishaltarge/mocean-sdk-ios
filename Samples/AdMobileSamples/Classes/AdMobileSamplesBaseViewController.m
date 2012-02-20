//
//  AdMobileSamplesBaseViewController.m
//  AdMobileSamples
//
//  Created by Slava Budnikov on 2/18/12.
//  Copyright (c) 2012 Team Force. All rights reserved.
//

#import "AdMobileSamplesBaseViewController.h"


@implementation AdMobileSamplesBaseViewController

#pragma mark -
#pragma mark Public functional

-(UIColor *)getViewBackgroundColor
{
	return  [UIColor colorWithRed:35 /255.0f
							green:31 /255.0f
							 blue:32 /255.0f
							alpha:1.0];
}

-(UIImage *)getViewBackgroundImage
{
	return [UIImage imageNamed:@"Default.png"];
}

-(NSInteger)getBannerSite
{
	return 8061;
}

-(NSInteger)getBannerZone
{
	return 20249;
}

-(CGRect)getBannerFrame
{
	return  CGRectMake(0, 0, 320, 50);
}

-(UIViewAutoresizing)getBannerAutoresizing
{
	return UIViewAutoresizingFlexibleWidth;
}

#pragma mark -
#pragma mark Application lifecycle

- (void)viewDidLoad
{
	[super viewDidLoad];
	
    self.view.backgroundColor = [self getViewBackgroundColor];
	
    UIImageView* imageView = [[UIImageView alloc] init];//WithImage:[UIImage imageNamed:@"Default.png"]];
    imageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
	[imageView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
	[imageView setContentMode:UIViewContentModeCenter];
	UIImage *img = [self getViewBackgroundImage];
	if ( img )
	{
		[imageView setImage:img];
		[self.view addSubview:imageView];		
	}
    [imageView release];
	
	_adView = [[AdView alloc] initWithFrame:[self getBannerFrame]];
	[_adView setAutoresizingMask:[self getBannerAutoresizing]];
    _adView.site = [self getBannerSite];
    _adView.zone = [self getBannerZone];
    [self.view addSubview:_adView];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    //_adView.frame = CGRectMake(0, 0, self.view.frame.size.width, 50);
    [_adView update];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation
{	
	return YES;
}

#pragma mark -
#pragma mark Memory management

- (void) dealloc
{
	_adView.delegate = nil;
	[_adView release];
	[super dealloc];
}

@end