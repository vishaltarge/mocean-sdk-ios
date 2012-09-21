//
//  MASTDiAdController.m
//  FlickrViewer
//
//  Copyright (c) 2012 mOcean Mobile. All rights reserved.
//

#import "MASTDiAdController.h"

@interface MASTDiAdController ()

@property (nonatomic, strong) ADBannerView* bannerView;

@end

@implementation MASTDiAdController

@synthesize bannerView;

- (void)loadView
{
    if (self.bannerView == nil)
    {
        self.bannerView = [[ADBannerView alloc] initWithFrame:self.adFrame];
        self.bannerView.delegate = self;
    }
    
    self.view = self.bannerView;
}

#pragma mark - 

// This method is invoked when the banner has confirmation that an ad will be presented, but before the ad
// has loaded resources necessary for presentation.
- (void)bannerViewWillLoadAd:(ADBannerView *)banner
{

}

// This method is invoked each time a banner loads a new advertisement. Once a banner has loaded an ad,
// it will display that ad until another ad is available. The delegate might implement this method if
// it wished to defer placing the banner in a view hierarchy until the banner has content to display.
- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    if (self.delegate != nil)
        [self.delegate adControllerDidReceiveAd:self];
}

// This method will be invoked when an error has occurred attempting to get advertisement content.
// The ADError enum lists the possible error codes.
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    if (self.delegate != nil)
        [self.delegate adControllerDidFailToReceiveAd:self withError:error];
}

// This message will be sent when the user taps on the banner and some action is to be taken.
// Actions either display full screen content in a modal session or take the user to a different
// application. The delegate may return NO to block the action from taking place, but this
// should be avoided if possible because most advertisements pay significantly more when
// the action takes place and, over the longer term, repeatedly blocking actions will
// decrease the ad inventory available to the application. Applications may wish to pause video,
// audio, or other animated content while the advertisement's action executes.
- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    // iAd will reposition the ad back on the top so hide it up front and reposition it
    // when the user comes back into the app.
    banner.hidden = YES;
    
    if (self.delegate != nil)
        [self.delegate adControllerAdOpened:self];
    
    return YES;
}

// This message is sent when a modal action has completed and control is returned to the application.
// Games, media playback, and other activities that were paused in response to the beginning
// of the action should resume at this point.
- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
    // iAd is goofy and doesn't put the ad back where it belongs after the user closes it.
    banner.frame = self.adFrame;
    banner.hidden = NO;
    
    if (self.delegate != nil)
        [self.delegate adControllerAdClosed:self];
}

@end
