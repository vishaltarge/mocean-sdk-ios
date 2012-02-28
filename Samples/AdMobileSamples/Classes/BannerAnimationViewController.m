//
//  BannerAnimationViewController.m
//  AdMobileSamples
//
//  Created by Ilya Rudometov on 8/2/10.
//

#import "BannerAnimationViewController.h"
#import "Settings.h"

#define AD_HEIGHT 50

@implementation BannerAnimationViewController

-(CGRect)getBannerFrame
{
	return CGRectMake(0, -AD_HEIGHT, self.view.bounds.size.width, AD_HEIGHT);
}

- (void)viewDidLoad
{
	[super viewDidLoad];

	_adView.updateTimeInterval = 10;
	_adView.isAdChangeAnimated = NO;
	_adView.delegate = self;
}

#pragma mark -
#pragma mark AdViewDelegate Members

- (void) didReceiveAd:(id)sender
{
	CGRect adFrame = _adView.frame;
	
	if (adFrame.origin.y >= 0)
		return;
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	
	adFrame.origin.y = 0;
	_adView.frame = adFrame;
	
	[UIView commitAnimations];
}

@end
