/*
 
 * PubMatic Inc. ("PubMatic") CONFIDENTIAL
 
 * Unpublished Copyright (c) 2006-2014 PubMatic, All Rights Reserved.
 
 *
 
 * NOTICE:  All information contained herein is, and remains the property of PubMatic. The intellectual and technical concepts contained
 
 * herein are proprietary to PubMatic and may be covered by U.S. and Foreign Patents, patents in process, and are protected by trade secret or copyright law.
 
 * Dissemination of this information or reproduction of this material is strictly forbidden unless prior written permission is obtained
 
 * from PubMatic.  Access to the source code contained herein is hereby forbidden to anyone except current PubMatic employees, managers or contractors who have executed
 
 * Confidentiality and Non-disclosure agreements explicitly covering such access.
 
 *
 
 * The copyright notice above does not evidence any actual or intended publication or disclosure  of  this source code, which includes
 
 * information that is confidential and/or proprietary, and is a trade secret, of  PubMatic.   ANY REPRODUCTION, MODIFICATION, DISTRIBUTION, PUBLIC  PERFORMANCE,
 
 * OR PUBLIC DISPLAY OF OR THROUGH USE  OF THIS  SOURCE CODE  WITHOUT  THE EXPRESS WRITTEN CONSENT OF PubMatic IS STRICTLY PROHIBITED, AND IN VIOLATION OF APPLICABLE
 
 * LAWS AND INTERNATIONAL TREATIES.  THE RECEIPT OR POSSESSION OF  THIS SOURCE CODE AND/OR RELATED INFORMATION DOES NOT CONVEY OR IMPLY ANY RIGHTS
 
 * TO REPRODUCE, DISCLOSE OR DISTRIBUTE ITS CONTENTS, OR TO MANUFACTURE, USE, OR SELL ANYTHING THAT IT  MAY DESCRIBE, IN WHOLE OR IN PART.
 
 */

//
//  MASTSAdvancedTopAndBottom.m
//  AdMobileSamples
//
//  Created on 4/18/12.

//

#import "MASTSAdvancedTopAndBottom.h"

@interface MASTSAdvancedTopAndBottom ()
@property (nonatomic, retain) MASTAdView* bottomAdView;
@property (nonatomic, assign) BOOL bottomFirstAppear;
@end

@implementation MASTSAdvancedTopAndBottom

@synthesize bottomAdView, bottomFirstAppear;

- (id)init
{
    self = [super init];
    if (self)
    {
        self.bottomFirstAppear = YES;
        
        UISegmentedControl* seg = [[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Top", @"Bottom", nil]] autorelease];
        seg.segmentedControlStyle = UISegmentedControlStyleBar;
        seg.momentary = YES;
        [seg addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
        
        UIBarButtonItem* segButton = [[[UIBarButtonItem alloc] initWithCustomView:seg] autorelease];
        
        self.navigationItem.rightBarButtonItem = segButton;
    }
    return self;
}

- (void)refresh:(UISegmentedControl*)seg
{
    MASTAdView* adViewToConfigure = nil;
    
    switch (seg.selectedSegmentIndex)
    {
        case 0: // top
            adViewToConfigure = self.adView;
            break;
        case 1: // bottom
            adViewToConfigure = self.bottomAdView;
            break;
    }
    
    MASTSAdConfigPrompt* prompt = [[[MASTSAdConfigPrompt alloc] initWithDelegate:self
                                                                            zone:adViewToConfigure.zone] autorelease];
    // use the tag to pass the top/bottom notion to the prompt handler
    prompt.tag = seg.selectedSegmentIndex;
    
    [prompt show];
}

- (void)loadView
{
    [super loadView];
    
    CGRect frame = super.adView.frame;
    super.adView.frame = frame;
    super.adView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    
    // Setup (or possibly resetup) the BOTTOM ad view (super covers the adView)
    [self.bottomAdView reset];
    [self.bottomAdView removeFromSuperview];
    
    frame = super.adView.frame;
    frame.size.width = CGRectGetWidth(super.view.bounds);
    frame.origin.y = CGRectGetMaxY(super.view.bounds) - frame.size.height;
    
    self.bottomAdView = [[[MASTAdView alloc] initWithFrame:frame] autorelease];
    self.bottomAdView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | 
        UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    self.bottomAdView.backgroundColor = self.adView.backgroundColor;
    self.bottomAdView.logLevel = MASTAdViewLogEventTypeDebug;
    [self.view addSubview:self.bottomAdView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSInteger topZone = 102238;
    NSInteger bottomZone = 88269;
    
    super.adView.zone = topZone;
    self.bottomAdView.zone = bottomZone;
    
    super.adView.backgroundColor = [UIColor clearColor];
    self.bottomAdView.backgroundColor = [UIColor clearColor];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.bottomFirstAppear)
    {
        self.bottomFirstAppear = NO;
        [self.bottomAdView update];
    }
}

#pragma mark -

- (void)configPrompt:(MASTSAdConfigPrompt *)prompt refreshWithZone:(NSInteger)zone
{
    if (prompt.tag == 0)
    {
        [super configPrompt:prompt refreshWithZone:zone];
        return;
    }

    self.bottomAdView.zone = zone;
    
    [self.bottomAdView update];
}

@end
