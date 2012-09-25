//
//  MASTSSimpleText.m
//  MASTSamples
//
//  Created by Jason Dickert on 4/17/12.
//  Copyright (c) 2012 mOcean Mobile. All rights reserved.
//

#import "MASTSSimpleText.h"

@interface MASTSSimpleText ()

@end

@implementation MASTSSimpleText

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSInteger site = 19829;
    NSInteger zone = 89888;
    
    self.adView.site = [NSString stringWithFormat:@"%d", site];
    self.adView.zone = [NSString stringWithFormat:@"%d", zone];
    
    super.adConfigController.site = site;
    super.adConfigController.zone = zone;
}

@end
