//
//  MedialetsViewController.h
//  AdMobileSamples
//
//  Created by Constantine Mureev on 4/4/11.
//

#import <UIKit/UIKit.h>
#import "AdView.h"
#import "AdDelegate.h"


@interface MedialetsViewController : UIViewController <AdViewDelegate> {
	AdView* _adView;
}

@end
