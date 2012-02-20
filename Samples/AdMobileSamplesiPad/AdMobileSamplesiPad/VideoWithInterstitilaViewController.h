//
//  VideoWithInterstitilaViewController.h
//  AdMobileSamplesiPad
//
//  Created by Constantine Mureev on 8/10/11.
//

#import <UIKit/UIKit.h>
#import "MASTAdView.h"
#import "MASTAdInterstitialView.h"
#import "MASTAdDelegate.h"

@interface VideoWithInterstitilaViewController : UIViewController<MASTAdViewDelegate>
{
	MASTAdView* _adView;
	MASTAdInterstitialView* _adInterstitialView;
}

- (id)initWithFrame:(CGRect)frame;

@end
