//
//  InterstitialViewController.m
//  AdMobileSamples
//
//  Created by Ilya Rudometov on 8/2/10.
//

#import "InterstitialViewController.h"
#import "Settings.h"

@implementation InterstitialViewController

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

	
	_adView = [[MASTAdView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height) site:8061 zone:96002];
    _adView.contentAlignment = YES;
    [_adView setBackgroundColor:[UIColor whiteColor]];
    _adView.minSize = CGSizeMake(320, 460);
	_adView.showCloseButtonTime = 5;
	_adView.adServerUrl = @"http://188.187.188.71:8080/new_mcn/request.php";
    _adView.internalOpenMode = YES;
    
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

#pragma mark -
#pragma mark AdserverInterstitialView Delegate methodes


- (void) didClickedAd:(id)sender request:(NSURLRequest *)request {
	if (sender == _adView) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[[request URL] absoluteString] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil]; 
		[alert show]; 
		[alert release];
	}
}

- (void) willReceiveAd:(id)sender {
	// Do something here
}

- (void) didReceiveAd:(id)sender {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"didReceiveAd" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil]; 
	[alert show]; 
	[alert release];
	
}

- (void) adUnavailable:(id)sender {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"adUnavailable" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil]; 
	[alert show]; 
	[alert release];
}

- (void) didClosedAd:(id)sender usageTime:(NSTimeInterval)usageTime {
	NSString* message = [NSString stringWithFormat: @"Usage time: %f seconds.", usageTime];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil]; 
	[alert show]; 
	[alert release];
}

@end
