//
//  MASTSDelegateGeneric.m
//  Samples
//
//  Created by Jason Dickert on 4/21/12.
//  Copyright (c) 2012 mOcean Mobile. All rights reserved.
//

#import "MASTSDelegateGeneric.h"

@interface MASTSDelegateGeneric ()

@end

@implementation MASTSDelegateGeneric

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSInteger site = 19829;
    NSInteger zone = 88269;
    
    self.adView.site = [NSString stringWithFormat:@"%d", site];
    self.adView.zone = [NSString stringWithFormat:@"%d", zone];
    
    super.adConfigController.site = site;
    super.adConfigController.zone = zone;
}

@end
