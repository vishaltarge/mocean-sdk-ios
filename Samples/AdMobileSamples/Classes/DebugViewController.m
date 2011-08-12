//
//  DebugViewController.m
//  AdMobileSamples
//
//  Created by Constantine Mureev on 2/16/11.
//

#import "DebugViewController.h"


@implementation DebugViewController

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

	
	_adView = [[AdView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50) site:8061 zone:20249];
	_adView.updateTimeInterval = 0; // disable updates
	//_adView.additionalParameters = [NSDictionary dictionaryWithObject:@"1" forKey:@"debug"];
	_adView.logMode = YES;
    _adView.testMode = YES;
	[self.view addSubview:_adView];
}

- (void) dealloc {
	[_adView release];
	[super dealloc];
}

@end