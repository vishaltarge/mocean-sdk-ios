//
//  VideoViewController.m
//  AdMobileSamples
//
//  Created by Ilya Rudometov on 8/2/10.
//

#import "VideoViewController.h"

@implementation VideoViewController

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

	_adView = [[AdView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 240) site:8061 zone:16109];
	_adView.updateTimeInterval = 60;
	_adView.defaultImage = [UIImage imageNamed:@"DefaultImage (320x240).png"];
	[self.view addSubview:_adView];
}

- (void) dealloc
{
	[_adView release];
	[super dealloc];
}

@end
