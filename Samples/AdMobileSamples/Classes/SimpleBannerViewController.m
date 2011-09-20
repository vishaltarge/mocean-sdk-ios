//
//  SimpleBannerViewController.m
//  AdMobileSamples
//
//  Created by Ilya Rudometov on 8/2/10.
//

#import "SimpleBannerViewController.h"

@implementation SimpleBannerViewController

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

	_adView = [[AdView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 414)];
    _adView.backgroundColor = [UIColor grayColor];
    _adView.site = 8061;
    _adView.zone = 1122;
    _adView.adServerUrl = @"http://192.168.1.153/mocean/ad.php";
    _adView.updateTimeInterval = 15;
    [self.view addSubview:_adView];
}

- (void) dealloc
{
	[_adView release];
	[super dealloc];
}

@end
