//
//  DownloadController.h
//  AdMobileSDK
//
//  Created by Constantine Mureev on 2/21/11.
//

#import <Foundation/Foundation.h>


#import "MASTNotificationCenter.h"
#import "MASTNotificationAtlas.h"

#import "MASTAdView_Private.h"
#import "MASTAdRequests.h"
#import "MASTUtils.h"
#import "MASTCacheController.h"


@interface MASTDownloadController : NSObject {
    MASTCacheController*        _cacheController;
	
	MASTAdRequests*				_adRequests;
}

+ (MASTDownloadController*)sharedInstance;
+ (void)releaseSharedInstance;

- (void)cancelAll;

- (void)downladAd:(MASTAdView*)adView;

@end
