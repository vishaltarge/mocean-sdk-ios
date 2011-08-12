//
//  InstallManager.h
//  AdMobileSDK
//
//  Created by Constantine Mureev on 3/28/11.
//

#import <Foundation/Foundation.h>

#import "NotificationCenter.h"
#import "Utils.h"


@interface InstallManager : NSObject {
    BOOL        _started;
}

@property (retain) NSString* advertiserId;
@property (retain) NSString* groupCode;
@property (retain) NSString* udid;

+ (InstallManager*)sharedInstance;
+ (void)releaseSharedInstance;

- (void)sendNotificationWith:(NSString*)adId groupCode:(NSString*)gCode;

@end
