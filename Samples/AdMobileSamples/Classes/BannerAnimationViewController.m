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

	
	_adView = [[AdView alloc] initWithFrame:CGRectMake(0, -AD_HEIGHT, self.view.frame.size.width, AD_HEIGHT) site:8061 zone:20249];
	_adView.updateTimeInterval = 30;
	_adView.animateMode = NO;
	
	_adView.delegate = self;
	[self.view addSubview:_adView];
}

- (void) dealloc
{
    _adView.delegate = nil;
	[_adView release];
	[super dealloc];
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
