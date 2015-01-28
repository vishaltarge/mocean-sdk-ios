//
//  MPNativeAdView.h
//  MoPub
//
//  Copyright (c) 2014 MoPub. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPNativeAdRendering.h"

@interface MPNativeAdView : UIView <MPNativeAdRendering>

@property (strong, nonatomic) IBOutlet UILabel *ctaLabel;
@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
@property (strong, nonatomic) IBOutlet UIImageView *fullsizeImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *bodyLabel;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGesture;

- (void)clearAd;

@end
