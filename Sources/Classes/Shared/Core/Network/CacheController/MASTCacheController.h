//
//  CacheController.h
//  AdMobileSDK
//
//  Created by Constantine Mureev on 3/15/11.
//

#import <Foundation/Foundation.h>

#import "MASTAdView.h"
#import "MASTUtils.h"
#import "MASTNotificationCenter.h"

@interface MASTCacheController : NSObject {
}

- (void)loadLinks:(NSArray*)links forAdView:(MASTAdView*)adView request:(NSURLRequest*)request origData:(NSData*)origData;

+ (NSData*)updateResponse:(NSData*)origData withNewData:(NSData*)newData request:(NSURLRequest*)request;

@end
