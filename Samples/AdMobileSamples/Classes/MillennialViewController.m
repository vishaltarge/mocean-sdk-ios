//
//  MillennialViewController.m
//  AdMobileSamples
//
//  Created by Constantine Mureev on 4/4/11.
//

#import "MillennialViewController.h"


@implementation MillennialViewController

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

	
	_adView = [[AdView alloc] initWithFrame:CGRectMake(0, 0, 320, 50) site:8061 zone:17324];
	_adView.updateTimeInterval = 10;
    _adView.delegate = self;
	_adView.defaultImage = [UIImage imageNamed:@"DefaultImage (320x50).png"];
	[self.view addSubview:_adView];
}

- (void) dealloc
{
    _adView.delegate = nil;
	[_adView release];
	[super dealloc];
}

- (void)didFailToReceiveAd:(id)sender withError:(NSError*)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[error description] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil]; 
    [alert show]; 
    [alert release];
}

@end