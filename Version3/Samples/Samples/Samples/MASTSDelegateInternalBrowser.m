//
//  MASTSDelegateInternalBrowser.m
//  Samples
//
//  Created on 6/13/13.
//  Copyright (c) 2013 mOcean Mobile. All rights reserved.
//

#import "MASTSDelegateInternalBrowser.h"

@interface MASTSDelegateInternalBrowser ()

@end

@implementation MASTSDelegateInternalBrowser

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSInteger site = 19829;
    NSInteger zone = 88269;
    
    self.adView.test = NO;
    
    self.adView.site = site;
    self.adView.zone = zone;
    
    self.adView.useInternalBrowser = YES;
}

@end
