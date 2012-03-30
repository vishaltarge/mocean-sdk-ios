//
//  InstallManager.h
//  AdMobileSDK
//
//  Created by Constantine Mureev on 3/28/11.
//

#import <Foundation/Foundation.h>

#import "MASTNotificationCenter.h"
#import "MASTUtils.h"


@interface MASTInstallManager : NSObject {
    BOOL        _started;
}

@property (assign) NSInteger advertiserId;
@property (retain) NSString* groupCode;
@property (retain) NSString* udid;

+ (MASTInstallManager*)sharedInstance;
+ (void)releaseSharedInstance;

- (void)sendNotificationWith:(NSInteger)adId groupCode:(NSString*)gCode udid:(NSString*)udid;

@end
