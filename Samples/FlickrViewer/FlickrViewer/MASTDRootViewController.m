//
//  MASTDRootViewController.m
//  FlickrViewer
//
//  Copyright (c) 2012 mOcean Mobile. All rights reserved.
// 

#import "MASTDRootViewController.h"
#import "MASTDModelController.h"
#import "MASTDDataViewController.h"
#import "MASTDBookmarks.h"
#import "MASTAdView.h"
#import "MASTDiAdController.h"
#import "MASTDAdMobController.h"
#import "MASTDMMAdController.h"
#import "MASTDiVdopiaController.h"


static const NSUInteger interstitialAdTriggerLimit = 10;

@interface MASTDRootViewController ()

@property (readonly, strong, nonatomic) MASTDModelController *modelController;
@property (nonatomic, strong) MASTAdView* adView;
@property (nonatomic, strong) MASTAdView* interstitialAdView;
@property (nonatomic, assign) NSInteger interstitialAdTriggerCount;

// This controller represents an active third party ad view.
// The mOcean adView is handled directly and not with this controller.
@property (nonatomic, strong) MASTDAdController* thirdPartyAdController;

// Holds campaign ids that fail.
@property (nonatomic, strong) NSMutableArray* excludedCampaignIds;

// Third party timer to kick the MAST ad view if there is no third party activity.
@property (nonatomic, strong) NSTimer* thirdPartyTimer;

@end

@implementation MASTDRootViewController

@synthesize pageViewController = _pageViewController;
@synthesize modelController = _modelController;
@synthesize adView, interstitialAdView, interstitialAdTriggerCount;
@synthesize thirdPartyAdController, excludedCampaignIds, thirdPartyTimer;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // Configure the page view controller and add it as a child view controller.
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.delegate = self;

    MASTDDataViewController *startingViewController = [self.modelController viewControllerAtIndex:0 storyboard:self.storyboard];
    NSArray *viewControllers = [NSArray arrayWithObject:startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:NULL];

    self.pageViewController.dataSource = self.modelController;

    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    
    
    // Set the page view controller's bounds using an inset rect so that self's view is visible
    // around the edges of the pages.
    // By default, make room for and display the banner ad on top.
    CGRect pageViewRect = self.view.bounds;
    pageViewRect.size.height -= 50;
    pageViewRect.origin.y += 50;
    
    CGRect adViewRect = self.view.bounds;
    adViewRect.size.height = 50;
    
    BOOL adViewTop = YES;
    if (arc4random() % 2 == 0)
    {
        adViewTop = NO;
        pageViewRect.origin.y -= 50;
        adViewRect.origin.y = CGRectGetMaxY(pageViewRect) + 1;
    }

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        pageViewRect = CGRectInset(pageViewRect, 40.0, 40.0);
    }
    self.pageViewController.view.frame = pageViewRect;

    [self.pageViewController didMoveToParentViewController:self];

    // Add the page view controller's gesture recognizers to the book view controller's view so that the gestures are started more easily.
    //self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;
    

    // Reset the adView delegate since it will get replaced below (if it was ever created).
    [self.adView setDelegate:nil];
    
    // Create the adView
    self.adView = [[MASTAdView alloc] initWithFrame:adViewRect];
    self.adView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
    
    if (adViewTop == NO) 
        self.adView.autoresizingMask = self.adView.autoresizingMask | UIViewAutoresizingFlexibleTopMargin;
    
    self.adView.backgroundColor = self.view.backgroundColor;
    
    self.adView.site = 19829;
    self.adView.zone = 112073;
    
    if (adViewTop == NO)
        self.adView.zone = 112067;
    
    self.adView.showPreviousAdOnError = YES;
    self.adView.updateTimeInterval = 45;
    self.adView.delegate = self;

    [self.view addSubview:self.adView];
    
    [self.adView update];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.navigationController.navigationBarHidden == NO)
        [self.navigationController setNavigationBarHidden:YES animated:NO];    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    // Allow the rotation to finish sizing everything then update the ad.
    if (self.adView.hidden = NO)
        [self.adView performSelector:@selector(update) withObject:nil afterDelay:0.5];
}

- (MASTDModelController *)modelController
{
     // Return the model controller object, creating it if necessary.
     // In more complex implementations, the model controller may be passed to the view controller.
    if (!_modelController) {
        _modelController = [[MASTDModelController alloc] init];
    }
    return _modelController;
}

- (void)addExcludedCampaignId:(NSString*)campaignId
{
    if ([campaignId length] == 0)
        return;
    
    if (self.excludedCampaignIds == nil)
        self.excludedCampaignIds = [NSMutableArray new];
    
    [self.excludedCampaignIds addObject:campaignId];
    
    NSString* property = [self.excludedCampaignIds componentsJoinedByString:@","];
    
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    if (self.adView.additionalParameters != nil)
        [params addEntriesFromDictionary:self.adView.additionalParameters];
    
    [params setValue:property forKey:@"excampaigns"];
    
    self.adView.additionalParameters = params;
}

#pragma mark - Toolbar

- (IBAction)showActions:(id)sender
{
    NSString* title = @"Add to Bookmarks";
    NSInteger tag = 100;
    
    MASTDFlickrImage* flickrImage = [[[self.pageViewController childViewControllers] objectAtIndex:0] flickrImage];
    
    BOOL bookmarked = [MASTDBookmarks contains:flickrImage];
    
    if (bookmarked)
    {
        title = @"Remove Bookmark";
        tag = 200;
    }
    
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:title, nil];
    
    actionSheet.tag = tag;
    [actionSheet showFromBarButtonItem:sender animated:YES];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([@"BookmarksSegue" isEqualToString:segue.identifier])
    {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex)
        return;
    
    switch (actionSheet.tag)
    {
        case 100:
        {
            MASTDFlickrImage* flickrImage = [[[self.pageViewController childViewControllers] objectAtIndex:0] flickrImage];
            [MASTDBookmarks add:flickrImage];
            break;
        }

        case 200:
        {
            MASTDFlickrImage* flickrImage = [[[self.pageViewController childViewControllers] objectAtIndex:0] flickrImage];
            [MASTDBookmarks remove:flickrImage];
            break;
        }
    }
}

#pragma mark - UIPageViewController delegate methods

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    
    if (self.interstitialAdView != nil)
        return;
    
    ++interstitialAdTriggerCount;
    
    if (interstitialAdTriggerCount < interstitialAdTriggerLimit)
        return;
    
    interstitialAdTriggerCount = 0;

    self.interstitialAdView = [[MASTAdView alloc] initWithFrame:self.navigationController.view.bounds];
    self.interstitialAdView.backgroundColor = [UIColor blackColor];

    self.interstitialAdView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | 
        UIViewAutoresizingFlexibleHeight;
    
    self.interstitialAdView.autocloseInterstitialTime = 20;
    self.interstitialAdView.showCloseButtonTime = 2;
    
    self.interstitialAdView.delegate = self;
    
    self.interstitialAdView.site = 19829;
    self.interstitialAdView.zone = 112074;
    
    [self.navigationController.view addSubview:self.interstitialAdView];
    
    [self.interstitialAdView update];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    if (UIInterfaceOrientationIsPortrait(orientation) || ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)) {
        // In portrait orientation or on iPhone: Set the spine position to "min" and the page view controller's view controllers array to contain just one view controller. Setting the spine position to 'UIPageViewControllerSpineLocationMid' in landscape orientation sets the doubleSided property to YES, so set it to NO here.
        
        UIViewController *currentViewController = [self.pageViewController.viewControllers objectAtIndex:0];
        NSArray *viewControllers = [NSArray arrayWithObject:currentViewController];
        [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
        
        self.pageViewController.doubleSided = NO;
        return UIPageViewControllerSpineLocationMin;
    }

    // In landscape orientation: Set set the spine location to "mid" and the page view controller's view controllers array to contain two view controllers. If the current page is even, set it to contain the current and next view controllers; if it is odd, set the array to contain the previous and current view controllers.
    MASTDDataViewController *currentViewController = [self.pageViewController.viewControllers objectAtIndex:0];
    NSArray *viewControllers = nil;

    NSUInteger indexOfCurrentViewController = [self.modelController indexOfViewController:currentViewController];
    if (indexOfCurrentViewController == 0 || indexOfCurrentViewController % 2 == 0) {
        UIViewController *nextViewController = [self.modelController pageViewController:self.pageViewController viewControllerAfterViewController:currentViewController];
        viewControllers = [NSArray arrayWithObjects:currentViewController, nextViewController, nil];
    } else {
        UIViewController *previousViewController = [self.modelController pageViewController:self.pageViewController viewControllerBeforeViewController:currentViewController];
        viewControllers = [NSArray arrayWithObjects:previousViewController, currentViewController, nil];
    }
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];


    return UIPageViewControllerSpineLocationMid;
}

#pragma mark - MASTAdViewDelegate

- (void)closeInterstitialAd
{
    [self.interstitialAdView removeFromSuperview];
    [self.interstitialAdView setDelegate:nil];
    self.interstitialAdView = nil;
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

- (void)didClosedAd:(id)sender usageTimeInterval:(NSTimeInterval)usageTimeInterval
{
    if (sender == self.interstitialAdView)
    {
        [self performSelectorOnMainThread:@selector(closeInterstitialAd) withObject:nil waitUntilDone:NO];
    }
}

- (void)removeThirdPartyAdController
{
    NSLog(@"removeThirdPartyAdController");
    
    [self.thirdPartyAdController close];
    
    if ([self.thirdPartyAdController isViewLoaded])
        [[self.thirdPartyAdController view] removeFromSuperview];
    
    [self.thirdPartyAdController setDelegate:nil];
    self.thirdPartyAdController = nil;
}

- (void)resetThirdPartyTimer
{
    [self.thirdPartyTimer invalidate];
    self.thirdPartyTimer = [NSTimer scheduledTimerWithTimeInterval:[self.adView updateTimeInterval]
                                                            target:self
                                                          selector:@selector(thirdPartyTimerTrigger:)
                                                          userInfo:nil
                                                           repeats:NO];
}

- (void)willReceiveAd:(id)sender
{
    // Dispatch on the main thread...
    // waitUntilDone to ensure the previous SDK is cleaned up, if not the Google
    // SDK may crash as it appears to listen for other activities other than it's own.
    [self performSelectorOnMainThread:@selector(removeThirdPartyAdController)
                           withObject:nil 
                        waitUntilDone:YES];
}

- (void)didReceiveAd:(id)sender
{
    NSLog(@"didReceiveAd");
    
    if ([self.adView isHidden])
        [self.adView setHidden:NO];
}

- (void)displayThirdPartyRequest:(NSArray*)args
{
    id sender = [args objectAtIndex:0];
    NSDictionary* content = [args objectAtIndex:1];
    
    [sender setHidden:YES];
    
    [self resetThirdPartyTimer];
    
    NSString* type = [content valueForKey:@"type"];
    NSString* campaign_id = [content valueForKey:@"campaign_id"];
    
        
    if ([@"iAds" isEqualToString:type])
    {
        self.thirdPartyAdController = [[MASTDiAdController alloc] initWithAdFrame:[sender frame]
                                                                       campaignId:campaign_id];
        self.thirdPartyAdController.rootViewController = self;
        self.thirdPartyAdController.delegate = self;
        
        [self.view addSubview:self.thirdPartyAdController.view];
        
        [self.thirdPartyAdController update];
        
        return;
    }
    else if ([@"admob" isEqualToString:type])
    {
        // Commenting out for now since the Google SDK crashes when some other UIWebView
        // loads "mraid.js" even though it has no business caring about it.
        // Others have this problem as well:
        // https://groups.google.com/forum/#!msg/google-admob-ads-sdk/UwP-91EQ1-0/80lkz0JdKtoJ
        //
        /*
        NSString* publisherId = [content valueForKey:@"publisherid"];
        
        self.thirdPartyAdController = [[MASTDAdMobController alloc] initWithAdFrame:[sender frame]
                                                                         campaignId:campaign_id 
                                                                        publisherId:publisherId];
        self.thirdPartyAdController.rootViewController = self;
        self.thirdPartyAdController.delegate = self;
        
        [self.view addSubview:self.thirdPartyAdController.view];
        
        [self.thirdPartyAdController update];
        
        return;
         */
    }
    else if ([@"Millennial" isEqualToString:type])
    {
        NSString* appId = [content valueForKey:@"id"];
        
        self.thirdPartyAdController = [[MASTDMMAdController alloc] initWithAdFrame:[sender frame]
                                                                       campaignId:campaign_id
                                                                             appId:appId];
        self.thirdPartyAdController.rootViewController = self;
        self.thirdPartyAdController.delegate = self;
        
        [self.view addSubview:self.thirdPartyAdController.view];
        
        [self.thirdPartyAdController update];
        
        return;
    }
    else if ([@"ivdopia" isEqualToString:type])
    {
        BOOL isTop = YES;
        if ([sender autoresizingMask] & UIViewAutoresizingFlexibleTopMargin)
            isTop = NO;
        
        // TODO: Should come from the third party notification info
        NSString* appKey = @"AX123";
        
        self.thirdPartyAdController = [[MASTDiVdopiaController alloc] initWithAdFrame:[sender frame]
                                                                           campaignId:campaign_id 
                                                                               appKey:appKey
                                                                                isTop:isTop];
        
        self.thirdPartyAdController.rootViewController = self;
        self.thirdPartyAdController.delegate = self;
        
        [self.view addSubview:self.thirdPartyAdController.view];
        
        [self.thirdPartyAdController update];
        
        return;
    }
    
    // Unknown type so add the campaign to the exclusion list and refresh the sending ad view.
    [self addExcludedCampaignId:campaign_id];
    
    [sender setHidden:NO];
    [sender update];
    
    [self.thirdPartyTimer invalidate];
}

- (void)didReceiveThirdPartyRequest:(id)sender content:(NSDictionary *)content
{
    if (sender == self.interstitialAdView)
        return;

    NSLog(@"didReceiveThirdPartyRequest:%@", content);
    
    // Dispatch on the main thread...
    NSArray* args = [NSArray arrayWithObjects:sender, content, nil];
    [self performSelectorOnMainThread:@selector(displayThirdPartyRequest:)
                           withObject:args 
                        waitUntilDone:NO];
}

#pragma mark -
#pragma mark MASTDAdControllerDelegate

- (void)updateAdView
{
    [self removeThirdPartyAdController];
    
    [self.thirdPartyTimer invalidate];
    self.thirdPartyTimer = nil;
    
    [self.adView update];
}

- (void)adControllerDidReceiveAd:(MASTDAdController*)controller
{
    // Give the ad time to display.
    [self resetThirdPartyTimer];
}

- (void)adControllerDidFailToReceiveAd:(MASTDAdController*)controller withError:(NSError*)error
{
    // Don't use this failed campaign again.
    [self addExcludedCampaignId:controller.campaignId];
    
    // Update and use the MAST ad view.
    [self performSelectorOnMainThread:@selector(updateAdView) withObject:nil waitUntilDone:NO];
}

- (void)adControllerAdOpened:(MASTDAdController*)controller
{
    // The user did something with the ad, cancel the update timer.
    [self.thirdPartyTimer invalidate];
    self.thirdPartyTimer = nil;
}

- (void)adControllerAdClosed:(MASTDAdController*)controller
{
    // The ad was closed, close the third party ad and update the MAST ad.
    [self performSelectorOnMainThread:@selector(updateAdView) withObject:nil waitUntilDone:NO];
}

#pragma mark - Timer

- (void)thirdPartyTimerTrigger:(id)sender
{
    [self performSelectorOnMainThread:@selector(updateAdView) withObject:nil waitUntilDone:NO];
}

@end
