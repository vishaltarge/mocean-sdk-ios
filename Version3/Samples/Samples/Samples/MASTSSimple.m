//
//  MASTSSimple.m
//  MASTSamples
//
/*
 * PubMatic Inc. (“PubMatic”) CONFIDENTIAL
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

#import "MASTSSimple.h"


@interface MASTSSimple () 
@property (nonatomic, assign) BOOL firstAppear;
@end


@implementation MASTSSimple

@synthesize adView;
@synthesize firstAppear;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self.adView reset];
    [self.adView setDelegate:nil];
    self.adView = nil;
    
    [super dealloc];
}

- (id)init
{
    self = [self initWithNibName:nil bundle:nil];
    if (self)
    {
        self.firstAppear = YES;
        
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh:)] autorelease];
    }
    return self;
}

- (void)refresh:(id)sender
{
    MASTSAdConfigPrompt* prompt = [[[MASTSAdConfigPrompt alloc] initWithDelegate:self
                                                                           zone:self.adView.zone] autorelease];
    [prompt show];
}

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    self.view.autoresizesSubviews = YES;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight |
        UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        
    // Setup (or possibly resetup) the ad view.
    
    [self.adView reset];
    [self.adView removeFromSuperview];
    
    CGRect frame = self.view.bounds;
    frame.size.height = 50;
    self.adView = [[[MASTAdView alloc] initWithFrame:frame] autorelease];
    self.adView.backgroundColor = [UIColor lightGrayColor];
    self.adView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    self.adView.logLevel = MASTAdViewLogEventTypeDebug;
    [self.view addSubview:self.adView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];  
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.firstAppear)
    {
        self.firstAppear = NO;
        
        if (self.adView.zone > 0)
        {
            [self.adView update];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{

}

#pragma mark -

- (void)configPrompt:(MASTSAdConfigPrompt *)prompt refreshWithZone:(NSInteger)zone
{
    self.adView.zone = zone;
    
    [self.adView update];
}

- (void)configPromptCancel:(MASTSAdConfigPrompt *)prompt
{
    
}

@end
