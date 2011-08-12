//
//  IAdViewController.h
//  AdMobileSamples
//
//  Created by Constantine Mureev on 3/31/11.
//

#import <UIKit/UIKit.h>

#import "AdView.h"
#import "AdDelegate.h"


@interface IAdViewController : UIViewController <AdViewDelegate> {
	AdView* _adView;
}

@end
