//
//  GreystripeAdaptor.h
//  AdMobileSDK
//
//  Created by Constantine Mureev on 4/6/11.
//

#import <UIKit/UIKit.h>

#import "AdView.h"

#ifdef INCLUDE_GREYSTRIPE
#import "GSAdEngine.h"
#import "GSAdView.h"
#import "GreystripeSharedAdaptor.h"
#import "NotificationCenter.h"
#endif

#define	GREYSTRIPE_LIBRARY_VERSION      @"3.1.2"

#ifdef INCLUDE_GREYSTRIPE
@interface GreystripeAdaptor : UIView <GreystripeDelegate> {
	GSAdView			*adView;
	NSInteger			slotType;
    BOOL                _loaded;
    
    BOOL                _firstDealloc;
#else
@interface GreystripeAdaptor : UIView {
#endif
}

- (void)showWithAppID:(NSString*)appId;
- (void)update;

@end
