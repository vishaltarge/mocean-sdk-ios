//
//  MASTSAppDelegate.m
//  AdMobileSamples
//
//  Created by Jason Dickert on 4/15/12.
//  Copyright (c) 2012 mOcean Mobile. All rights reserved.
//

#import "MASTSAppDelegate.h"
#import "MASTSMenuController.h"
#import "MASTSDetailController.h"
#import "MASTSSplitViewController.h"
#import "MASTAdView.h"


@interface MASTSAppDelegate()
@property (nonatomic, retain) UIViewController* rootController;
@property (nonatomic, retain) UINavigationController* menuNavController;
@property (nonatomic, retain) MASTSDetailController* detailController;
@property (nonatomic, retain) UIViewController* subDetailController;
@property (nonatomic, retain) UIPopoverController* popoverController;
@property (nonatomic, assign) BOOL useLocation;
@end


@implementation MASTSAppDelegate

@synthesize window = _window;
@synthesize rootController, menuNavController, detailController, subDetailController, popoverController, useLocation;


- (void)dealloc
{
    self.rootController = nil;
    self.menuNavController = nil;
    self.detailController = nil;
    self.subDetailController = nil;
    self.popoverController = nil;
    
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    MASTSMenuController* mastsMenuController = [[MASTSMenuController new] autorelease];
    mastsMenuController.delegate = self;
    self.menuNavController = [[[UINavigationController alloc] initWithRootViewController:mastsMenuController] autorelease];

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        self.rootController = self.menuNavController;
    }
    else
    {
        self.detailController = [[MASTSDetailController new] autorelease];
        self.detailController.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
        
        UISplitViewController* splitViewController = [[MASTSSplitViewController new] autorelease];
        splitViewController.delegate = self;
        splitViewController.viewControllers = [NSArray arrayWithObjects:self.menuNavController, self.detailController, nil];
        
        self.rootController = splitViewController;
    }
    
    [self.window setRootViewController:self.rootController];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    // This should be done here to prevent location updates while the application is inactive.
    [MASTAdView setLocationDetectionEnabled:NO];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    if (self.useLocation)
        [MASTAdView setLocationDetectionEnabled:YES];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - 

- (void)splitViewController:(UISplitViewController *)svc
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)pc
{
    [barButtonItem setTitle:@"Samples"];
    
    if (aViewController == menuNavController)
        self.detailController.menuButton = barButtonItem;
    
    self.popoverController = pc;
}

- (void)splitViewController:(UISplitViewController *)svc
     willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    if (aViewController == menuNavController)
        self.detailController.menuButton = nil;
    
    self.popoverController = nil;
}

- (void)splitViewController:(UISplitViewController *)svc
          popoverController:(UIPopoverController *)pc
  willPresentViewController:(UIViewController *)aViewController
{
    self.popoverController = pc;
}

#pragma mark -

- (void)menuController:(MASTSMenuController*)menuController presentController:(UIViewController*)controller
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        [self.menuNavController pushViewController:controller animated:YES];
    }
    else
    {
        if (self.subDetailController == controller)
            return;
        
        CGRect frame = self.detailController.view.bounds;
        frame.origin.y += 44;
        frame.size.height -= 44;
        controller.view.frame = frame;
        
        self.detailController.title = controller.title;
        
        self.detailController.rightButton = controller.navigationItem.rightBarButtonItem;
        
        [self.subDetailController.view removeFromSuperview];
        
        [self.detailController.view addSubview:controller.view];
        [self.detailController.view sendSubviewToBack:controller.view];
        
        [self.popoverController dismissPopoverAnimated:YES];
        
        self.subDetailController = controller;
    }
}

- (void)menuController:(MASTSMenuController *)menuController setLocationUsage:(BOOL)usage
{
    self.useLocation = usage;
    [MASTAdView setLocationDetectionEnabled:usage];
}

@end
