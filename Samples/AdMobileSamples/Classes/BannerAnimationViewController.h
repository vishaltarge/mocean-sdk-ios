//
//  BannerAnimationViewController.h
//  AdMobileSamples
//
//  Created by Ilya Rudometov on 8/2/10.
//

#import <UIKit/UIKit.h>
#import "AdView.h"

@interface BannerAnimationViewController : UIViewController <AdViewDelegate>
{
	AdView* _adView;
}

@end