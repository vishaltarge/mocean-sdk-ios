//
//  SimpleBannerViewController.m
//  AdMobileSamplesiPad
//
//  Created by Constantine Mureev on 8/10/11.
//

#import "SimpleBannerViewController.h"

@implementation SimpleBannerViewController

- (id)initWithFrame:(CGRect)frame {
    self = [super init];
    if (self) {
        UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default-Portrait.png"]];
        imageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [self.view addSubview:imageView];
        [imageView release];
        
        _adView = [[MASTAdView alloc] initWithFrame:frame site:8061 zone:20249];
        _adView.updateTimeInterval = 15;
        _adView.contentAlignment = YES;
        _adView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.view = _adView;
        
        [_adView update];
    }
    
    return self;
}

- (void)dealloc {
    [_adView release];
    [super dealloc];
}

@end
