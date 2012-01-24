//
//  AdClicker.h
//  AdMobileSDK
//
//  Created by Constantine Mureev on 7/18/11.
//  Copyright 2011 AdMobile Mobile. A subsidiary of Mojiva, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NotificationCenter.h"

#define TIMER_INTERVAL      3.0
#define CLEAN_INTERVAL      7.0

@interface AdClicker : NSObject {
    NSMutableArray*         _infos;
    NSMutableArray*         _connections;
    NSMutableDictionary*    _urls;
    NSMutableArray*         _timers;
    
    NSTimer*                _cleanTimer;
}

+ (AdClicker*)sharedInstance;
+ (void)releaseSharedInstance;

@end
