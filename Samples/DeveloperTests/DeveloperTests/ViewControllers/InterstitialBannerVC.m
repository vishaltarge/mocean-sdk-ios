//
//  InterstitialBannerVC.m
//  DeveloperTests
//
//  Created by artem samalov on 1/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InterstitialBannerVC.h"

@implementation InterstitialBannerVC

@synthesize adView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.adView = [[AdInterstitialView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height) site:8061 zone:16112];
    self.adView.contentAlignment = YES;
    [self.adView setBackgroundColor:[UIColor whiteColor]];
    self.adView.minSize = CGSizeMake(320, 460);
	self.adView.showCloseButtonTime = 5;
	self.adView.autocloseInterstitialTime = 15;
    
    [self.view addSubview:self.adView];
    
    [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(closeBanner) userInfo:nil repeats:NO];
}

- (void)closeBanner {
    [self.adView stopEverythingAndNotfiyDelegateOnCleanup];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.adView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
