//
//  RichJSadViewController.m
//  AdMobileSamplesiPad
//
//  Created by Constantine Mureev on 8/10/11.
//

#import "RichJSadViewController.h"

@implementation RichJSadViewController

- (id)initWithFrame:(CGRect)frame {
    self = [super init];
    if (self) {
        UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default-Portrait.png"]];
        imageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [self.view addSubview:imageView];
        [imageView release];
        
        _adView = [[MASTAdInterstitialView alloc] initWithFrame:frame site:8061 zone:20664];
        _adView.updateTimeInterval = 60;
        _adView.minSize = CGSizeMake(320, 460);
        _adView.showCloseButtonTime = 5;
        _adView.autocloseInterstitialTime = 15;
        _adView.contentAlignment = YES;
        _adView.type = AdTypeRichmedia;
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
