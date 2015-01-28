//
//  MASTSMainViewController.m
//  InstallationDirect
//
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

#import "MASTSMainViewController.h"

#import "MASTAdView.h"

@interface MASTSMainViewController () <MASTAdViewDelegate>

// Reference to the ad view
// Using a property for easy reference management
@property (nonatomic, retain) MASTAdView* adView;

// Using this to track when the ad view should update
@property (nonatomic, assign) BOOL updateAdView;

@end

@implementation MASTSMainViewController

- (void)dealloc
{
    // Always reset the delegate and release the ad view.
    // This guarantees that even if something else is still holding on to the
    //  ad view that this controller will no longer be the delegate since it's
    //  being deallocated.
    // Note that even if adView is nil it can be sent messages.
    [self.adView setDelegate:nil];
    self.adView = nil;
    
    
    [_flipsidePopoverController release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Now that the storyboard has loaded the view, add the ad to the top using
    // lazy creation and setup.  Reuse if already setup.
    if (self.adView == nil)
    {
        // Note that the autorelease is here becuase assigning to the retain property will retain the
        // ad view.  After the event loop purges the autorelease pool the retain count will be one
        // plus any retaining addSubview will do later.
        self.adView = [[[MASTAdView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)] autorelease];
        
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

#pragma mark - MASTAdViewDelegate

- (void)MASTAdViewDidRecieveAd:(MASTAdView *)adView
{
    NSLog(@"MASTAdViewDidRecieveAd");
}

- (void)MASTAdView:(MASTAdView *)adView didFailToReceiveAdWithError:(NSError *)error
{
    NSLog(@"MASTAdView:didFailToReceiveAdWithError:%@", error);
}

#pragma mark - Flipside View Controller

- (void)flipsideViewControllerDidFinish:(MASTSFlipsideViewController *)controller
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
        self.flipsidePopoverController = nil;
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.flipsidePopoverController = nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            UIPopoverController *popoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
            self.flipsidePopoverController = popoverController;
            popoverController.delegate = self;
        }
    }
}

- (IBAction)togglePopover:(id)sender
{
    if (self.flipsidePopoverController) {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
        self.flipsidePopoverController = nil;
    } else {
        [self performSegueWithIdentifier:@"showAlternate" sender:sender];
    }
}

@end
