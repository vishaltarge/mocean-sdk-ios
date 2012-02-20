//
//  InterstitialViewController.m
//  AdMobileSamplesiPad
//
//  Created by Constantine Mureev on 8/10/11.
//

#import "InterstitialViewController.h"

@implementation InterstitialViewController

- (id)initWithFrame:(CGRect)frame {
    self = [super init];
    if (self) {        
        _adView = [[MASTAdInterstitialView alloc] initWithFrame:frame site:8061 zone:16112];
        _adView.contentAlignment = YES;
        _adView.minSize = CGSizeMake(320, 460);
        _adView.showCloseButtonTime = 5;
        _adView.autocloseInterstitialTime = 15;
        _adView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.view = _adView;
    }
    
    return self;
}

- (void)dealloc {
    [_adView release];
    [super dealloc];
}

@end
