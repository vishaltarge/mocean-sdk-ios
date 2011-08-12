//
//  VideoWithInterstitilaViewController.m
//  AdMobileSamplesiPad
//
//  Created by Constantine Mureev on 8/10/11.
//

#import "VideoWithInterstitilaViewController.h"

@implementation VideoWithInterstitilaViewController

- (id)initWithFrame:(CGRect)frame {
    self = [super init];
    if (self) {
        self.view.frame = frame;
        self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.view.backgroundColor = [UIColor colorWithRed:35 /255.0f
                                                    green:31 /255.0f
                                                     blue:32 /255.0f
                                                    alpha:1.0];
        
        
        _adView = [[AdView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) site:8061 zone:16109];
        _adView.updateTimeInterval = 60;
        
        [self.view addSubview:_adView];
        
        _adInterstitialView = [[AdInterstitialView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) site:8061 zone:16112];
        _adInterstitialView.contentAlignment = YES;
        _adView.contentAlignment = YES;
        _adView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        _adInterstitialView.minSize = CGSizeMake(320, 460);
        _adInterstitialView.showCloseButtonTime = 5;
        _adInterstitialView.autocloseInterstitialTime = 15;
        
        _adInterstitialView.delegate = self;
        _adInterstitialView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self.view addSubview:_adInterstitialView];
    }
    
    return self;
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
