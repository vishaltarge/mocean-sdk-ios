//
//  MASTOrmmaSharedDataSource.h
//  Copyright (c) Microsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OrmmaProtocols.h"
#import "MASTLocationManager.h"
#import "MASTAccelerometer.h"

@interface MASTOrmmaSharedDataSource : NSObject <OrmmaDataSource>

+ (id)sharedInstance;

@end