//
//  VideoViewController.m
//  AdMobileSamples
//
//  Created by Ilya Rudometov on 8/2/10.
//

#import "VideoViewController.h"

@implementation VideoViewController

-(NSInteger)getBannerZone
{
	return 16109;
}

-(CGRect)getBannerFrame
{
	return  CGRectMake(0, 0, 320, 240);
}

- (void)viewDidLoad
{
	[super viewDidLoad];

	_adView.updateTimeInterval = 60;
    _adView.type = AdTypeRichmedia;
	_adView.defaultImage = [UIImage imageNamed:@"DefaultImage (320x240).png"];

}

@end