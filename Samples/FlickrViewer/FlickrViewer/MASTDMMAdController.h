//
//  MASTDMMAdController.h
//  FlickrViewer
//
//  Copyright (c) 2012 mOcean Mobile. All rights reserved.
//

#import "MASTDAdController.h"
#import "MMAdView.h"

@interface MASTDMMAdController :  MASTDAdController <MMAdDelegate>

- (id)initWithAdFrame:(CGRect)adFrame campaignId:(NSString *)campaignId appId:(NSString*)appId;

@end

