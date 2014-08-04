//
//  MASTSViewController.m
//  InstallationFramework
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

#import "MASTSViewController.h"

// Import comes from the framework
#import <MASTAdView/MASTAdView.h>

@interface MASTSViewController ()

// Reference to the ad view (strong to keep it around if nothing else has references)
@property (nonatomic, strong) MASTAdView* adView;

// Using this to track when the ad view should update
@property (nonatomic, assign) BOOL updateAdView;

@end

@implementation MASTSViewController

- (void)dealloc
{
    // To be safe, always reset the delegate
    [self.adView setDelegate:nil];
    self.adView = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Now that the storyboard has loaded the view, add the ad to the top using
    // lazy creation and setup.  Reuse if already setup.
    if (self.adView == nil)
    {
        self.adView = [[MASTAdView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
        
        // Like a normal view setup autoresizing for autorotation changes
        self.adView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        // Set some obvious background color (MASTAdView is a UIView)
        self.adView.backgroundColor = [UIColor darkGrayColor];

        self.adView.zone = 98463;
        
        self.updateAdView = YES;
    }
    
    [self.view addSubview:self.adView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.updateAdView)
    {
        self.updateAdView = NO;
        
        // Update now and every 20 seconds.
        [self.adView updateWithTimeInterval:20];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    // Reset/stop the ad view from updating.
    // Reset the updateAdView flag so when the view appears again it will start updating again.
    [self.adView reset];
    self.updateAdView = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
