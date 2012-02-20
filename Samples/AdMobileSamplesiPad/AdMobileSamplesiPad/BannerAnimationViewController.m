//
//  BannerAnimationViewController.m
//  AdMobileSamplesiPad
//
//  Created by Constantine Mureev on 8/10/11.
//

#import "BannerAnimationViewController.h"

#define AD_HEIGHT 50

@implementation BannerAnimationViewController

- (id)initWithFrame:(CGRect)frame {
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor colorWithRed:35 /255.0f
                                                    green:31 /255.0f
                                                     blue:32 /255.0f
                                                    alpha:1.0];
        UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default.png"]];
        imageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [self.view addSubview:imageView];
        [imageView release];
        
        
        _adView = [[MASTAdView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, AD_HEIGHT) site:8061 zone:20249];
        _adView.updateTimeInterval = 30;
        _adView.animateMode = NO;
        _adView.contentAlignment = YES;
        
        _adView.delegate = self;
        
        self.view = _adView;
    }
    
    return self;
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
	
	if (adFrame.origin.y >= 44)
		return;
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	
	adFrame.origin.y += 44;
	_adView.frame = adFrame;
	
	[UIView commitAnimations];
}

@end
