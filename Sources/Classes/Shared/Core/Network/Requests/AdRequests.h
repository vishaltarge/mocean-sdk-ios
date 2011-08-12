//
//  AdRequests.h
//  AdMobileSDK
//
//  Created by Constantine Mureev on 3/3/11.
//

#import <Foundation/Foundation.h>

#import "AdView.h"

@interface AdRequests : NSObject {
	NSMutableArray*			_ads;
	NSMutableArray*			_requestListsForAds;
}

- (BOOL)containsRequest:(NSURLRequest*)request;
- (void)addRequest:(NSURLRequest*)request forAd:(AdView*)adView;
- (void)removeRequest:(NSURLRequest*)request;
- (void)removeAd:(AdView*)adView;
- (AdView*)adForRequest:(NSURLRequest*)request;
- (NSArray*)allRequestsForAd:(AdView*)adView;

@end
