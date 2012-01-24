//
//  CacheController.h
//  AdMobileSDK
//
//  Created by Constantine Mureev on 3/15/11.
//

#import <Foundation/Foundation.h>

#import "AdView.h"
#import "Utils.h"
#import "NotificationCenter.h"

@interface CacheController : NSObject {
}

- (void)loadLinks:(NSArray*)links forAdView:(AdView*)adView request:(NSURLRequest*)request origData:(NSData*)origData;

+ (NSData*)updateResponse:(NSData*)origData withNewData:(NSData*)newData request:(NSURLRequest*)request;

@end
