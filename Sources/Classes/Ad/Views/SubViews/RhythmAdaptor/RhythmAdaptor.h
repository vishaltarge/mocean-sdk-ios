//
//  RhythmAdaptor.h
//  AdMobileSDK
//
//  Created by Constantine Mureev on 4/12/11.
//

#import <UIKit/UIKit.h>

#import "AdView.h"
#import "LocationManager.h"
#import "NotificationCenter.h"

#define	RHYTH_LIBRARY_VERSION       @"4.4.1"


#ifdef INCLUDE_RHYTHM
#import "RhythmAd.h"
#import "RhythmAdDelegate.h"
#endif

#ifdef INCLUDE_RHYTHM
@interface RhythmAdaptor : UIView <RhythmAdDelegate> {
    UIView<RhythmAd>*   rhythmAdView;
    NSString*           _appId;
#else
@interface RhythmAdaptor : UIView {
#endif
}

- (void) showWithAppID:(NSString*)appId;

@end
