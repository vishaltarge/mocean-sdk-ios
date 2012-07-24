//
//  MASTDAdMobController.h
//  FlickrViewer
//
//  Copyright (c) 2012 mOcean Mobile. All rights reserved.
//

#import "MASTDAdController.h"
#import "GADBannerViewDelegate.h"


@interface MASTDAdMobController : MASTDAdController <GADBannerViewDelegate>

- (id)initWithAdFrame:(CGRect)adFrame campaignId:(NSString *)campaignId publisherId:(NSString*)pid;

@end
