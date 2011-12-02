//
//  VideoWithInterstitilaViewController.h
//  AdMobileSamplesiPad
//
//  Created by Constantine Mureev on 8/10/11.
//

#import <UIKit/UIKit.h>
#import "AdView.h"
#import "AdInterstitialView.h"
#import "AdDelegate.h"

@interface VideoWithInterstitilaViewController : UIViewController<AdViewDelegate>
{
	AdView* _adView;
	AdInterstitialView* _adInterstitialView;
}

- (id)initWithFrame:(CGRect)frame;

@end
