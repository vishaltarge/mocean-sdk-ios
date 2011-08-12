//
//  DelegateViewController.h
//  AdMobileSamples
//
//  Created by Constantine on 8/6/10.
//

#import <UIKit/UIKit.h>
#import "AdView.h"
#import "AdDelegate.h"

@interface DelegateViewController : UIViewController <AdViewDelegate> {
	AdView*		_adView;
}

@end
