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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
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
    
    [self.adView reset];
    [self.adView removeFromSuperview];
    
    CGRect frame = self.view.bounds;
    frame.size.height = 50;
    self.adView = [[[MASTAdView alloc] initWithFrame:frame] autorelease];
    self.adView.backgroundColor = [UIColor lightGrayColor];
    self.adView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.adView];
    
    frame = self.adConfigController.view.bounds;
    frame.origin.y = 65;
    self.adConfigController.view.frame = frame;
    self.adConfigController.view.center = self.view.center;
    self.adConfigController.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];    
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

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{

}

#pragma mark -

- (void)keyboardDidShow:(id)notification
{
    NSDictionary* info = [notification userInfo];
    if (info == nil)
        return;
    
    CGRect windowKeyboardFrame = [[info valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect viewKeyboardFrame = [self.view.window convertRect:windowKeyboardFrame toView:self.view];

    CGRect frame = self.adConfigController.view.frame;
    if (CGRectGetMaxY(frame) > CGRectGetMinY(viewKeyboardFrame))
    {
        frame.origin.y -= CGRectGetMaxY(frame) - CGRectGetMinY(viewKeyboardFrame);
        self.adConfigController.view.frame = frame;
    }
}

- (void)keyboardWillHide:(id)notification
{
    self.adConfigController.view.center= self.view.center;
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
