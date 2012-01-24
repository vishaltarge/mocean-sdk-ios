//
//  InterstitialViewController.h
//  AdMobileSamplesiPad
//
//  Created by Constantine Mureev on 8/10/11.
//

#import <UIKit/UIKit.h>
#import "MASTAdInterstitialView.h"

@interface InterstitialViewController : UIViewController {
	MASTAdInterstitialView* _adView;
}

- (id)initWithFrame:(CGRect)frame;

@end
