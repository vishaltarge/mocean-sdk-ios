//
//  SharedModel.h
//  AdMobileSDK
//
//  Created by Constantine Mureev on 3/1/11.
//

#import <Foundation/Foundation.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

#import "AdView.h"

#import "AdView.h"
#import "Constants.h"
#import "Reachability.h"

#import "LocationManager.h"
#import "WebKitInfo.h"
#import "LocationManager.h"
#import "Utils.h"


@interface SharedModel : NSObject {
    NSString*       _udidMd5;
}

@property (retain, nonatomic) NSString*     udidMd5;
@property (retain) NSString*                ua;
@property (retain) NSString*                latitude;
@property (retain) NSString*                longitude;

+ (SharedModel*)sharedInstance;
+ (void)releaseSharedInstance;

- (NSString*)sharedUrlPart;

@end
