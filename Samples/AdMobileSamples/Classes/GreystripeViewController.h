//
//  GreystripeViewController.h
//  AdMobileSamples
//
//  Created by Constantine Mureev on 4/19/11.
//

#import <UIKit/UIKit.h>
#import "AdView.h"
#import "AdDelegate.h"


@interface GreystripeViewController : UIViewController <AdViewDelegate>  {
	AdView* _adView;
}

@end
