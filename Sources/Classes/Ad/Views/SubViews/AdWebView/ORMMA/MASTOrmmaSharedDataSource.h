//
//  MASTOrmmaSharedDataSource.h
//

#import <Foundation/Foundation.h>

#import "OrmmaProtocols.h"
#import "MASTAdView.h"
#import "MASTLocationManager.h"
#import "MASTAccelerometer.h"

@interface MASTOrmmaSharedDataSource : NSObject <OrmmaDataSource>

+ (id)sharedInstance;

@end