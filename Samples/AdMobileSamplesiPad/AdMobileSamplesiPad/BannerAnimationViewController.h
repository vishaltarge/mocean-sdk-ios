//
//  BannerAnimationViewController.h
//  AdMobileSamplesiPad
//
//  Created by Constantine Mureev on 8/10/11.
//

#import <UIKit/UIKit.h>
#import "AdView.h"

@interface BannerAnimationViewController : UIViewController <AdViewDelegate>
{
	AdView* _adView;
}

- (id)initWithFrame:(CGRect)frame;

@end