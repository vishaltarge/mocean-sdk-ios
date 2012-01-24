//
//  Logger.h
//  AdMobileSDK
//
//  Created by Constantine Mureev on 8/19/10.
//

#import <Foundation/Foundation.h>

#import "LogBasicFormatter.h"
#import "NotificationCenter.h"
#import "AdView.h"
#import "AdView_Private.h"

@interface Logger : NSObject {
    NSMutableDictionary*    _ads;
    NSMutableArray*         _allLogAds;
}

+ (Logger*)sharedInstance;
+ (void)releaseSharedInstance;

@end
