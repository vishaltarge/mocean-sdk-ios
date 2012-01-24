//
//  VideoWithInterstitilaViewController.h
//  AdMobileSamples
//
//  Created by Ilya Rudometov on 8/4/10.
//

#import <UIKit/UIKit.h>
#import "MASTAdView.h"
#import "MASTAdInterstitialView.h"
#import "MASTAdDelegate.h"

@interface VideoWithInterstitilaViewController : UIViewController <MASTAdViewDelegate>
{
	MASTAdView* _adView;
	MASTAdInterstitialView* _adInterstitialView;
}

@end
