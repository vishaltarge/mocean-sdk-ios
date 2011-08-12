//
//  SASUIViewControllerAdaptor.h
//  AdMobileSDK
//
//  Created by Constantine Mureev on 4/20/11.
//

#import <UIKit/UIKit.h>

#import "AdView.h"

#ifdef INCLUDE_SAS
#import "NotificationCenter.h"
#import "SmartAdServerView.h"
#import "SmartAdServerAd.h"
#import "UIViewAdditions.h"


@interface SASUIViewControllerAdaptor : UIViewController <SmartAdServerViewDelegate> {
    
}

@property (assign) UIView* adView;

@end
#endif
