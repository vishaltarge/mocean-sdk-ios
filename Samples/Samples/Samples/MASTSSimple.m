//
//  MASTSSimple.m
//  MASTSamples
//
//  Created by Jason Dickert on 4/16/12.
//  Copyright (c) 2012 mOcean Mobile. All rights reserved.
//

#import "MASTSSimple.h"

@interface MASTSSimple ()
@property (nonatomic, assign) BOOL firstAppear;
@end


@implementation MASTSSimple

@synthesize adView, adConfigController;
@synthesize firstAppear;

- (void)dealloc
{
    self.adView.delegate = nil;
    self.adView = nil;
    
    self.adConfigController.delegate = nil;
    self.adConfigController = nil;
    
    [super dealloc];
}

- (id)init
{
    self = [self initWithNibName:nil bundle:nil];
    if (self)
    {
        self.firstAppear = YES;
        self.adConfigController = [[MASTSAdConfigController new] autorelease];
        self.adConfigController.delegate = self;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    self.view.autoresizesSubviews = YES;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight |
        UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        
    // Setup (or possibly resetup) the ad view.
    
    [self.adView stopEverythingAndNotfiyDelegateOnCleanup];
    [self.adView removeFromSuperview];
    
    CGRect frame = self.view.bounds;
    frame.size.height = 50;
    self.adView = [[[MASTAdView alloc] initWithFrame:frame] autorelease];
    self.adView.backgroundColor = [UIColor lightGrayColor];
    self.adView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.adView];
 
    self.adView.showPreviousAdOnError = YES;
    self.adView.logMode = AdLogModeAll;
    
    frame = self.adConfigController.view.bounds;
    frame.origin.y = 65;
    self.adConfigController.view.frame = frame;
    self.adConfigController.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | 
        UIViewAutoresizingFlexibleRightMargin;
    [self.view addSubview:self.adConfigController.view];
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.firstAppear)
    {
        self.firstAppear = NO;
        [self.adView update];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.adView update];
}

#pragma mark -

- (void)updateAdWithConfig:(MASTSAdConfigController *)configController
{
    NSInteger site = configController.site;
    NSInteger zone = configController.zone;
    
    self.adView.site = site;
    self.adView.zone = zone;
    
    [self.adView update];
}

@end
