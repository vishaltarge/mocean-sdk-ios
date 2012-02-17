//
//  VideoWithInterstitilaViewController.h
//  AdMobileSamples
//
//  Created by Ilya Rudometov on 8/4/10.
//

#import <UIKit/UIKit.h>
#import "MASTAdView.h"
#import "MASTAdView.h"
#import "MASTAdDelegate.h"

@interface VideoWithInterstitilaViewController : UIViewController <MASTAdViewDelegate>
{
	MASTAdView* _adView;
	MASTAdView* _adInterstitialView;
}

@end
