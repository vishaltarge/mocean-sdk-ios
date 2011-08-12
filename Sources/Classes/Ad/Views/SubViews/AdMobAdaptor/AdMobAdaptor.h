//
//  AdMobAdaptor.h
//  AdMobileSDK
//
//  Created by Constantine Mureev on 4/12/11.
//

#import <UIKit/UIKit.h>

#import "AdView.h"

#ifdef INCLUDE_ADMOB
#import "NotificationCenter.h"
#import "UIViewAdditions.h"
#import "GADBannerView.h"
#import "GADBannerViewDelegate.h"
#endif

#define	ADMOB_LIBRARY_VERSION      @"afma-sdk-i-v4.1.0"


#ifdef INCLUDE_ADMOB
@interface AdMobAdaptor : UIView <GADBannerViewDelegate> {
    GADBannerView*      _adView;
    NSString*           _pubId;
    
    NSString*           _latitide;
    NSString*           _longitude;
    NSString*           _zip;
    BOOL                _loaded;
#else
@interface AdMobAdaptor : UIView  {
#endif
}

- (void)showWithPublisherID:(NSString*)publisherId
                   latitude:(NSString*)latitude
                  longitude:(NSString*)longitude
                        zip:(NSString*)zip;
- (void)update;

@end
