//
//  AdMobViewController.h
//  AdMobileSamples
//
//  Created by Constantine Mureev on 4/14/11.
//

#import <UIKit/UIKit.h>
#import "AdView.h"
#import "AdDelegate.h"


@interface AdMobViewController : UIViewController <AdViewDelegate>  {
	AdView* _adView;
}

@end
