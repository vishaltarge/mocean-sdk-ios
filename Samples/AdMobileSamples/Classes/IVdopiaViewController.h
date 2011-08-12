//
//  IVdopiaViewController.h
//  AdMobileSamples
//
//  Created by Constantine Mureev on 4/6/11.
//

#import <UIKit/UIKit.h>
#import "AdView.h"
#import "AdDelegate.h"


@interface IVdopiaViewController : UIViewController <AdViewDelegate> {
	AdView* _adView;
}

@end
