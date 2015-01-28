//
//  MASTCommunicationManager.h
//  MASTAdView
//
//  Created by Shrinivas Prabhu on 21/07/14.
//  Copyright (c) 2014 Mocean Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MASTNativeAd;

@interface MASTCommunicationManager : NSObject

typedef void(^MPNativeAdRequestHandler)(MASTCommunicationManager *manager,
                                        MASTNativeAd *response,
                                        NSError *error);


- (void)requestWithCompletionHandler:(MPNativeAdRequestHandler)handler;

@end
