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
    
    NSInteger site = 20564;
    NSInteger zone = 90375;
    
    super.adView.site = site;
    super.adView.zone = zone;
    
    super.adConfigController.site = site;
    super.adConfigController.zone = zone;
    
    super.adView.track = YES;
    
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef uuidString = CFUUIDCreateString(NULL, uuid);
    NSString* udid = [NSString stringWithString:(NSString*)uuidString];
    CFRelease(uuidString);
    CFRelease(uuid);
    
    super.adView.udid = udid;
    
    super.adView.showPreviousAdOnError = YES;
}

@end
