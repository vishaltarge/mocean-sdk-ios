//
//  GreystripeSharedAdaptor.h
//  AdMobileSDK
//
//  Created by Constantine Mureev on 4/19/11.
//

#import <Foundation/Foundation.h>

#import "AdView.h"

#ifdef INCLUDE_GREYSTRIPE
#import "GSAdEngine.h"
#import "GSAdView.h"
#endif

#define BANNER_SLOT_NAME @"bannerSlot"
#define FULLSCREEN_SLOT_NAME @"fullscreenSlot"

#define	GREYSTRIPE_LIBRARY_VERSION	3.1.2


#ifdef INCLUDE_GREYSTRIPE
@interface GreystripeSharedAdaptor : NSObject <GreystripeDelegate> {
    GSAdEngine*             _engine;
    GSAdView*               _adView;
    NSString*               _appId;
    CGRect                  _frame;
    
    
    BOOL                    _greystripeAdReadyForSlotNamed;
    BOOL                    _greystripeFullScreenDisplayWillOpen;
    BOOL                    _greystripeFullScreenDisplayWillClose;
}

@property (assign) id<GreystripeDelegate>       delegate;

+ (GreystripeSharedAdaptor*)sharedInstance;
+ (void)releaseSharedInstance;

- (GSAdView*)adViewWithAppId:(NSString*)appId frame:(CGRect)frame;

@end
#endif
