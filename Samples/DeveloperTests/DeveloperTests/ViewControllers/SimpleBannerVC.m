//
//  SimpleBannerVC.m
//  DeveloperTests
//
//  Created by artem samalov on 1/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SimpleBannerVC.h"

@implementation SimpleBannerVC

@synthesize adView, btnStartTimer, btnTheWorldMethod;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Simple banner";
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
    
    self.adView = [[AdView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, 100.0) site:8061 zone:20001];
    self.adView.backgroundColor = [UIColor whiteColor];
    self.adView.adServerUrl = @"http://192.168.1.162/new_mcn/request.php";
    self.adView.logMode = AdLogModeAll;
    [self.view addSubview:self.adView];
    
    self.btnStartTimer = [[UIButton alloc] initWithFrame:CGRectMake(20.0, 200.0, 100.0, 45.0)];
    self.btnStartTimer.backgroundColor = [UIColor grayColor];
    [self.btnStartTimer setTitle:@"Start timer" forState:UIControlStateNormal];
    [self.btnStartTimer addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnStartTimer];
    
    self.btnTheWorldMethod = [[UIButton alloc] initWithFrame:CGRectMake(160.0, 200.0, 200.0, 45.0)];
    self.btnTheWorldMethod.backgroundColor = [UIColor grayColor];
    [self.btnTheWorldMethod setTitle:@"The world method" forState:UIControlStateNormal];
    [self.btnTheWorldMethod addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnTheWorldMethod];
}

- (void)buttonClick:(id)sender {
    if (sender == self.btnStartTimer) {
        //start timer
        [NSTimer scheduledTimerWithTimeInterval:20.0 target:self.adView selector:@selector(stopEverythingAndNotfiyDelegateOnCleanup) userInfo:nil repeats:NO];
    } else if (sender == self.btnTheWorldMethod) {
        [self.adView stopEverythingAndNotfiyDelegateOnCleanup];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.adView = nil;
    self.btnStartTimer = nil;
    self.btnTheWorldMethod = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
