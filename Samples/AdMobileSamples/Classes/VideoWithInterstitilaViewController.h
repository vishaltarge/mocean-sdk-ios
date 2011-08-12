//
//  VideoWithInterstitilaViewController.h
//  AdMobileSamples
//
//  Created by Ilya Rudometov on 8/4/10.
//

#import <UIKit/UIKit.h>
#import "AdView.h"
#import "AdInterstitialView.h"
#import "AdDelegate.h"

@interface VideoWithInterstitilaViewController : UIViewController <AdViewDelegate, AdInterstitialViewDelegate>
{
	AdView* _adView;
	AdInterstitialView* _adInterstitialView;
}

@end
