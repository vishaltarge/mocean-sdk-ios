//
//  RichJSadViewController.m
//  AdMobileSamples
//
//  Created by Constantine Mureev on 2/18/11.
//

#import "RichJSadViewController.h"


@implementation RichJSadViewController

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


	_adView = [[AdInterstitialView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height) site:8061 zone:20664];
    _adView.contentAlignment = YES;
    [_adView setBackgroundColor:[UIColor whiteColor]];
    _adView.minSize = CGSizeMake(320, 460);
	_adView.showCloseButtonTime = 5;
	_adView.autocloseInterstitialTime = 15;
	
    [self.navigationController.view addSubview:_adView];
}

- (void) dealloc
{
	[_adView release];
	[super dealloc];
}

@end