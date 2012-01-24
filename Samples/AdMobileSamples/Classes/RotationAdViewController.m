//
//  RotationAdViewController.m
//  AdMobileSamples
//
//  Created by Constantine Mureev on 2/4/11.
//

#import "RotationAdViewController.h"


@implementation RotationAdViewController

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
	
	_adView = [[MASTAdView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50) site:8061 zone:20249];
	_adView.updateTimeInterval = 30;
    _adView.contentAlignment = YES;
    //_adView.minSize = _adView.frame.size;
    //_adView.maxSize = _adView.frame.size;
    
	[self.view addSubview:_adView];
    
    UIBarButtonItem *update = [[UIBarButtonItem alloc] initWithTitle:@"Update" style:UIBarButtonItemStylePlain target:_adView action:@selector(update)];
    [self.navigationItem setRightBarButtonItem:update];
    [update release];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    _adView.frame = CGRectMake(0, 0, self.view.frame.size.width, 50);
    [_adView update];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation {	
	return YES;
}

- (void) dealloc
{
	[_adView release];
	[super dealloc];
}

@end