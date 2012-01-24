//
//  DelegateViewController.h
//  AdMobileSamples
//
//  Created by Constantine on 8/6/10.
//

#import <UIKit/UIKit.h>
#import "MASTAdView.h"
#import "MASTAdDelegate.h"

@interface DelegateViewController : UIViewController <MASTAdViewDelegate> {
	MASTAdView*		_adView;
}

@end
