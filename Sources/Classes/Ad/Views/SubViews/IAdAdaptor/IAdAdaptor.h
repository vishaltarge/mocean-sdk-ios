//
//  IAdAdaptor.h
//  AdMobileSDK
//
//  Created by Constantine Mureev on 4/1/11.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "AdView.h"

#ifdef INCLUDE_IAD
#import <iAd/iAd.h>
#endif

#import "NotificationCenter.h"


#ifdef INCLUDE_IAD
@interface IAdAdaptor : UIView <ADBannerViewDelegate> {
    ADBannerView*       adBannerView;
#else
@interface IAdAdaptor : UIView {
#endif
    BOOL                loadedFirstTime;
    NSUInteger          _lastErorCode;
}

- (id)initWithFrame:(CGRect)frame section:(NSString*)adSection;

- (void)updateSection:(NSString*)adSection;

@end
