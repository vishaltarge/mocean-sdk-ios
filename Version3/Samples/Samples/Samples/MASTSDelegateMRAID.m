//
//  MASTSDelegateMRAID.m
//  Samples
//
//  Created by Jason Dickert on 4/21/12.
//  Copyright (c) 2012 mOcean Mobile. All rights reserved.
//

#import "MASTSDelegateMRAID.h"

@interface MASTSDelegateMRAID ()

@end

@implementation MASTSDelegateMRAID

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSInteger site = 19829;
    NSInteger zone = 98463;
    
    self.adView.site = site;
    self.adView.zone = zone;
    
    super.adConfigController.site = site;
    super.adConfigController.zone = zone;
}

@end
