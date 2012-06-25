//
//  MASTSCustom.m
//  AdMobileSamples
//
//  Created by Jason Dickert on 4/18/12.
//  Copyright (c) 2012 mOcean Mobile. All rights reserved.
//

#import "MASTSCustom.h"
#import "MASTSCustomConfigController.h"


@interface MASTSCustom ()
@property (nonatomic, retain) UIPopoverController* configPopoverController;
@end

@implementation MASTSCustom

@synthesize configPopoverController;

- (void)dealloc
{
    self.configPopoverController = nil;
    
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self)
    {
        UIBarButtonItem* menuButton = [[[UIBarButtonItem alloc] initWithTitle:@"Menu"
                                                                        style:UIBarButtonItemStyleBordered
                                                                       target:self
                                                                       action:@selector(menu:)] autorelease];
        self.navigationItem.rightBarButtonItem = menuButton;
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    // Adjust for the status bar, the navigation bar space will trigger an update layout.
    CGRect adjustedFrame = [[UIScreen mainScreen] bounds];
    CGRect adjustedBarFrame = [[UIApplication sharedApplication] statusBarFrame];
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]))
    {
        adjustedFrame = CGRectMake(adjustedFrame.origin.x, adjustedFrame.origin.y,
                                   adjustedFrame.size.height, adjustedFrame.size.width);
        
        adjustedBarFrame = CGRectMake(adjustedBarFrame.origin.x, adjustedBarFrame.origin.y,
                                      adjustedBarFrame.size.height, adjustedBarFrame.size.width);
        
    }
    //adjustedFrame.size.height -= [[UIApplication sharedApplication] statusBarFrame].size.height;
    adjustedFrame.size.height -= adjustedBarFrame.size.height;
    
    
    // Place the config view on the bottom.
    CGRect frame = super.adConfigController.view.frame;
    frame.origin.y = CGRectGetMaxY(adjustedFrame) - frame.size.height;
    super.adConfigController.view.frame = frame;
    
    // Update the autoresizing mask to include adjusting the top margin to cover 
    // the navigation bar and rotation.
    super.adConfigController.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | 
        UIViewAutoresizingFlexibleTopMargin;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSInteger site = 19829;
    NSInteger zone = 102238;
    
    super.adView.site = site;
    super.adView.zone = zone;
    
    super.adConfigController.site = site;
    super.adConfigController.zone = zone;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.configPopoverController dismissPopoverAnimated:NO];
}

#pragma mark -

- (void)keyboardWillHide:(id)notification
{
    // Place the config view on the bottom.
    CGRect frame = super.adConfigController.view.frame;
    frame.origin.y = CGRectGetMaxY(self.view.frame) - frame.size.height;
    super.adConfigController.view.frame = frame;
}

#pragma mark -

- (void)menu:(id)sender
{
    MASTSCustomConfigController* configController = [[MASTSCustomConfigController new] autorelease];
    configController.delegate = self;
    
    NSMutableDictionary* config = [NSMutableDictionary dictionary];
    [config setValue:[NSNumber numberWithInteger:self.adView.frame.origin.x] forKey:@"x"];
    [config setValue:[NSNumber numberWithInteger:self.adView.frame.origin.y] forKey:@"y"];
    [config setValue:[NSNumber numberWithInteger:self.adView.frame.size.width] forKey:@"width"];
    [config setValue:[NSNumber numberWithInteger:self.adView.frame.size.height] forKey:@"height"];
    [config setValue:[NSNumber numberWithInteger:self.adView.minSize.width] forKey:@"minWidth"];
    [config setValue:[NSNumber numberWithInteger:self.adView.minSize.height] forKey:@"minHeight"];
    [config setValue:[NSNumber numberWithInteger:self.adView.maxSize.width] forKey:@"maxWidth"];
    [config setValue:[NSNumber numberWithInteger:self.adView.maxSize.height] forKey:@"maxHeight"];
    [config setValue:[NSNumber numberWithBool:self.adView.internalOpenMode] forKey:@"internalOpenMode"];
    [config setValue:self.adView.injectionHeaderCode forKey:@"injectionHeaderCode"];
    [configController setConfig:config];
    
    UINavigationController* navController = [[[UINavigationController alloc] initWithRootViewController:configController] autorelease];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        [self presentModalViewController:navController animated:YES];
    }
    else
    {
        //self.configPopoverController = [[[UIPopoverController alloc] initWithContentViewController:navController] autorelease];
        self.configPopoverController = [[UIPopoverController alloc] initWithContentViewController:navController];
        [self.configPopoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

#pragma mark -

- (void)cancelCustomConfig:(MASTSCustomConfigController *)controller
{
    if (self.configPopoverController != nil)
    {
        [self.configPopoverController dismissPopoverAnimated:YES];
        [self.configPopoverController release];
    }
    else
    {
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (void)customConfig:(MASTSCustomConfigController *)controller updatedWithConfig:(NSDictionary *)settings
{
    if (self.configPopoverController != nil)
    {
        [self.configPopoverController dismissPopoverAnimated:YES];
        [self.configPopoverController release];
    }
    else
    {
        [self dismissModalViewControllerAnimated:YES];
    }
    
    CGRect frame = CGRectMake([[settings valueForKey:@"x"] integerValue],
                              [[settings valueForKey:@"y"] integerValue],
                              [[settings valueForKey:@"width"] integerValue],
                              [[settings valueForKey:@"height"] integerValue]);
    self.adView.frame = frame;
    
    CGSize size = CGSizeMake([[settings valueForKey:@"minWidth"] integerValue],
                             [[settings valueForKey:@"minHeight"] integerValue]);
    self.adView.minSize = size;
    
    size = CGSizeMake([[settings valueForKey:@"maxWidth"] integerValue],
                      [[settings valueForKey:@"maxHeight"] integerValue]);
    self.adView.maxSize = size;

    id value = [settings valueForKey:@"internalOpenMode"];
    self.adView.internalOpenMode = [value boolValue];
    
    value = [settings valueForKey:@"injectionHeaderCode"];
    self.adView.injectionHeaderCode = value;
    
    [self.adView update];
}

@end
