//
//  IVdopiaAdaptor.h
//  AdMobileSDK
//
//  Created by Constantine Mureev on 4/6/11.
//

#import <UIKit/UIKit.h>


#define	IVDOPIA_LIBRARY_VERSION     @"3.4.9"

#import "AdView.h"
#import "NotificationCenter.h"

#ifdef INCLUDE_IVDOPIA
#import "VDOAds.h"
#endif

#ifdef INCLUDE_IVDOPIA
@interface IVdopiaAdaptor : UIView <VDOAdsDelegate> {
	VDOAds*					_bannerView;
}
#else
@interface IVdopiaAdaptor : UIView  {
}
#endif

- (void)showWithAppKey:(NSString*)appKey;

@end
