//
//  DownloadController.h
//  AdMobileSDK
//
//  Created by Constantine Mureev on 2/21/11.
//

#import <Foundation/Foundation.h>


#import "NotificationCenter.h"
#import "NotificationAtlas.h"

#import "AdView_Private.h"
#import "AdRequests.h"
#import "Utils.h"
#import "CacheController.h"


@interface DownloadController : NSObject {
    CacheController*        _cacheController;
	
	AdRequests*				_adRequests;
}

+ (DownloadController*)sharedInstance;
+ (void)releaseSharedInstance;

- (void)cancelAll;

- (void)downladAd:(AdView*)adView;

@end
