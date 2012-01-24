//
//  DelegateViewController.h
//  AdMobileSamples
//
//  Created by Constantine on 8/6/10.
//

#import <UIKit/UIKit.h>
#import "MASTAdView.h"
#import "AdDelegate.h"

@interface DelegateViewController : UIViewController <AdViewDelegate> {
	AdView*		_adView;
}

@end
