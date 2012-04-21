//
//  MASTSDelegateOrmma.m
//  Samples
//
//  Created by Jason Dickert on 4/21/12.
//  Copyright (c) 2012 mOcean Mobile. All rights reserved.
//

#import "MASTSDelegateOrmma.h"

@interface MASTSDelegateOrmma ()

@end

@implementation MASTSDelegateOrmma

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSInteger site = 19829;
    NSInteger zone = 98463;
    
    super.adView.site = site;
    super.adView.zone = zone;
    
    super.adConfigController.site = site;
    super.adConfigController.zone = zone;
}

@end
