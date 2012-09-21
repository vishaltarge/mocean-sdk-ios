//
//  MASTDiVdopiaController.h
//  FlickrViewer
//
//  Copyright (c) 2012 mOcean Mobile. All rights reserved.
//

#import "MASTDAdController.h"
#import "VDOAds.h"


@interface MASTDiVdopiaController : MASTDAdController <VDOAdsDelegate>

- (id)initWithAdFrame:(CGRect)adFrame campaignId:(NSString *)campaignId appKey:(NSString*)appKey isTop:(BOOL)top;

@end
