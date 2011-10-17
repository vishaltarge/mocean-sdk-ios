//
//  MillennialAdaptor.h
//  AdMobileSDK
//
//  Created by Constantine Mureev on 4/4/11.
//

#import <UIKit/UIKit.h>

#import "AdView.h"
#ifdef INCLUDE_MILLENNIAL
#import "MMAdView.h"
#endif

#define	MILLENNIAL_LIBRARY_VERSION      @"4.2.5"

#import "NotificationCenter.h"

#ifdef INCLUDE_MILLENNIAL
@interface MillennialAdaptor : UIView <MMAdDelegate> {
	MMAdView*				_bannerView;
	MMAdType				_type;
#else
@interface MillennialAdaptor : UIView {
#endif
        
        NSString*               _latitide;
        NSString*               _longitude;
        NSString*               _zip;
        BOOL                    _loaded;
    }
    
    - (void)showWithAdType:(NSString*)adType
appId:(NSString*)appId
latitude:(NSString*)latitude
longitude:(NSString*)longitude
zip:(NSString*)zip;
    - (void)update;
    
    @end
