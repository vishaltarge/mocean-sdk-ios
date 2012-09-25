//
//  MASTSSimpleRichMedia.m
//  MASTSamples
//
//  Created by Jason Dickert on 4/17/12.
//  Copyright (c) 2012 mOcean Mobile. All rights reserved.
//

#import "MASTSSimpleRichMedia.h"

@interface MASTSSimpleRichMedia ()

@end

@implementation MASTSSimpleRichMedia

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSInteger site = 19829;
    NSInteger zone = 98463;
    
    self.adView.site = [NSString stringWithFormat:@"%d", site];
    self.adView.zone = [NSString stringWithFormat:@"%d", zone];
    
    super.adConfigController.site = site;
    super.adConfigController.zone = zone;
}

@end
