//
//  VideoWithInterstitilaViewController.m
//  AdMobileSamples
//
//  Created by Ilya Rudometov on 8/4/10.
//

#import "VideoWithInterstitilaViewController.h"


@implementation VideoWithInterstitilaViewController

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

	
	_adView = [[MASTAdView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 240) site:8061 zone:16109];
	_adView.updateTimeInterval = 60;
    _adView.type = AdTypeRichmedia;
	_adView.defaultImage = [UIImage imageNamed:@"DefaultImage (320x240).png"];
	
	[self.view addSubview:_adView];
	
	_adInterstitialView = [[MASTAdView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height) site:8061 zone:16112];
    _adView.contentAlignment = YES;
    _adView.showCloseButtonTime = 5;
    [_adInterstitialView setBackgroundColor:[UIColor whiteColor]];
    
    _adInterstitialView.minSize = CGSizeMake(320, 460);
	_adInterstitialView.showCloseButtonTime = 5;
	_adInterstitialView.autocloseInterstitialTime = 15;
	
	_adInterstitialView.delegate = self;
    
    [self.navigationController.view addSubview:_adInterstitialView];
    
    UIBarButtonItem *update = [[UIBarButtonItem alloc] initWithTitle:@"Update" style:UIBarButtonItemStylePlain target:_adView action:@selector(update)];
    [self.navigationItem setRightBarButtonItem:update];
    [update release];
}

- (void) dealloc
{
    _adView.delegate = nil;
	[_adView release];
	[_adInterstitialView release];
	[super dealloc];
}

#pragma mark -
#pragma mark AdserverInterstitialView Delegate methodes

- (void) showAd
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1];
	
	_adView.alpha = 1;
	
	[UIView commitAnimations];
}

- (void) didClosedInterstitialAd:(id)sender usageTime:(NSTimeInterval)usageTime
{
	[self performSelector:@selector(showAd) withObject:nil afterDelay:0.5];
}

@end
