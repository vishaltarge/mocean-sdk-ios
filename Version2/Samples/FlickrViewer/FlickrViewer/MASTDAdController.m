//
//  MASTDAdController.m
//  FlickrViewer
//
//  Copyright (c) 2012 mOcean Mobile. All rights reserved.
//

#import "MASTDAdController.h"


@interface MASTDAdController ()

@end

@implementation MASTDAdController

@synthesize adFrame, campaignId, rootViewController, delegate;

- (void)dealloc
{
    self.delegate = nil;
}

- (id)initWithAdFrame:(CGRect)af campaignId:(NSString*)cid
{
    self = [super init];
    if (self)
    {
        adFrame = af;
        campaignId = cid;
    }
    return self;
}

- (void)close
{
    
}

- (void)update
{
    
}

- (NSString*)campaignId
{
    return campaignId;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
