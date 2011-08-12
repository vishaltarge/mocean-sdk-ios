//
//  NotificationCenter.h
//  AdMobileSDK
//
//  Created by Constantine Mureev on 2/22/11.
//

#import <Foundation/Foundation.h>

#import "NotificationAtlas.h"
#import "NotificationCenterAdditions.h"


@interface NotificationCenter : NSNotificationCenter {

}

+ (NotificationCenter*)sharedInstance;
+ (void)releaseSharedInstance;

@end
