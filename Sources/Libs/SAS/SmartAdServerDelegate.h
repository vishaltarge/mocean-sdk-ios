/*
 *  SmartAdServerDelegate.h
 *  SmartAdServer
 *
 *  Created by Paul-Anatole CLAUDOT on 20/09/10.
 *  Copyright 2010 Haploid. All rights reserved.
 *
 */
@class SmartAdServerView, SmartAdServerAd;
 
@protocol SmartAdServerViewDelegate

@optional

// Called when an ad using SAS service did load.
- (void)didDownloadSmartAdServerView:(SmartAdServerView *)smartAdServerView;

// Called when an ad using SAS service did fail to download.
// Your can return nil or a SmartAdServerDefaultAd if you want it to be shown instead of the expected ad.
- (SmartAdServerAd *)didFailDownloadingSmartAdServerView:(SmartAdServerView *)smartAdServerView;

// Called when the user click on the ad (if a redirect url is provided).
- (void)didClicSmartAdServerView:(SmartAdServerView *)smartAdServerView;

// Called when an expandable ad did unexpand (duration time elapsed).
- (void)expandSASViewDidUnexpand:(SmartAdServerView *)smartAdServerView;

// Called when an intersticiel view did disappear (after duration time elapsed and animation)
// At this point, smartAdServerView received a retain if it had a superview and a removeFromSuperview
- (void)intersticielSASViewDidDisappear:(SmartAdServerView *)smartAdServerView;

// In case of a http redirection ad wich will be shown in a UIWeb view inside the application
// instead of leaving the application.
// Works only if a delegate has been set.
- (void)willPresentModalViewForSmartAdServerView:(SmartAdServerView *)smartAdServerView;
- (void)didDismissModalViewForSmartAdServerView:(SmartAdServerView *)smartAdServerView;

// When the redirect url has to be open by another app (i.e. youtube, iTunes,...) we ask the user if he wants to quit the application
// This method is called when the user made his choice, just before the application quits (or not).
// It sends the user choice (willQuitApp ?)
- (void)didMakeChoiceForAdAction:(BOOL)willQuitApp;


 
// Specify the UIViewController which will present the modalview when clic on the Ad. If Not implemented, try to present from delegate else jsut warm you in the console log
- (UIViewController*)viewControllerForSmartAdServerView:(SmartAdServerView*)smartAdServerView;

@end
