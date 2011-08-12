//
//  SASUIViewControllerAdaptor.m
//  AdMobileSDK
//
//  Created by Constantine Mureev on 4/20/11.
//

#import "SASUIViewControllerAdaptor.h"

#ifdef INCLUDE_SAS


@implementation SASUIViewControllerAdaptor

@synthesize adView;

- (void)dealloc
{
    [super dealloc];
}


#pragma mark -
#pragma mark SmartAdServerViewDelegate methods 


// Called when the user click on the ad (if a redirect url is provided).
- (void)didClicSmartAdServerView:(SmartAdServerView *)smartAdServerView
{
    if (self.adView && self.adView.superview) {
        // track url        
        [[NotificationCenter sharedInstance] postNotificationName:kTrackUrlNotification object:self.adView.superview];
    }
}

// Called when an expandable ad did unexpand (duration time elapsed).
- (void)expandSASViewDidUnexpand:(SmartAdServerView *)smartAdServerView
{
    if (self.adView && self.adView.superview) {
        // track url      
        [[NotificationCenter sharedInstance] postNotificationName:kTrackUrlNotification object:self.adView.superview];
        
        // send callback
        NSMutableDictionary* sendInfo = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:self.adView.superview, nil]
                                                                           forKeys:[NSArray arrayWithObjects:@"adView", nil]];
        
        [[NotificationCenter sharedInstance] postNotificationName:kOpenInternalBrowserNotification object:sendInfo];
    }
}

// Called when an intersticiel view did disappear (after duration time elapsed and animation)
// At this point, smartAdServerView received a retain if it had a superview and a removeFromSuperview
- (void)intersticielSASViewDidDisappear:(SmartAdServerView *)smartAdServerView 
{
	if (self.adView && self.adView.superview) {
        [[NotificationCenter sharedInstance] postNotificationName:kCloseInternalBrowserNotification object:self.adView.superview];
    }
}

// In case of a http redirection ad wich will be shown in a UIWeb view inside the application
// instead of leaving the application.
// Works only if a delegate has been set.
- (void)willPresentModalViewForSmartAdServerView:(SmartAdServerView *)smartAdServerView
{
    if (self.adView && self.adView.superview) {        
        // send callback
        NSMutableDictionary* sendInfo = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:self.adView.superview, nil]
                                                                           forKeys:[NSArray arrayWithObjects:@"adView", nil]];
        
        [[NotificationCenter sharedInstance] postNotificationName:kOpenInternalBrowserNotification object:sendInfo];
    }
}

- (void)didDismissModalViewForSmartAdServerView:(SmartAdServerView *)smartAdServerView
{
	if (self.adView && self.adView.superview) {
        [[NotificationCenter sharedInstance] postNotificationName:kCloseInternalBrowserNotification object:self.adView.superview];
    }
}

// override
- (void)presentModalViewController:(UIViewController *)modalViewController animated:(BOOL)animated {
    if (self.adView && self.adView.superview) {
        [[self.adView.superview viewControllerForView] presentModalViewController:modalViewController animated:animated];
    }
}

- (void)dismissModalViewControllerAnimated:(BOOL)animated {
    if (self.adView && self.adView.superview) {
        [[self.adView.superview viewControllerForView] dismissModalViewControllerAnimated:animated];
    }    
}




/** Tells the delegate that the ad data has been fetched, and will try to be displayed
 
 It lets you know what the ad data is, so you can adapt your ad behavior. See the SmartAdServerAd Class Reference for more information.
 
 @param adView The ad view informing the delegate about the ad beeing fetched
 @param adInfo is a copy of the SmartAdServerAd object
 
 */


//-(void)sasView:(SmartAdServerView *)adView didDownloadAdInfo:(SmartAdServerAd *)adInfo;


/** Tells the delegate that the creative from the current ad has been loaded and displayed
 
 @param adView An ad view object informing the delegate about the creative beeing loaded
 @warning This method  is not only called the first time an ad creative is displayed, but also when the user turns the device, and in a browsable HTML creative, when a new page is loaded
 
 */

-(void)sasViewDidLoadAd:(SmartAdServerView *)adView {
    if (self.adView && self.adView.superview) {        
        NSMutableDictionary* senfInfo = [NSMutableDictionary dictionary];
        [senfInfo setObject:self.adView.superview forKey:@"adView"];
        [senfInfo setObject:self.adView forKey:@"subView"];
        [[NotificationCenter sharedInstance] postNotificationName:kReadyAdDisplayNotification object:senfInfo];
    }
}


/* Tells the delegate that the SmartAdServerView failed to download the ad
 
 This can happen when the user's connection is interrupted before downloading the ad.
 In this case you might want to 
 
 - display a custom SmartAdServerAd : see [SmartAdServerView displayThisAd:]
 - refresh the ad view : see [SmartAdServerView refresh]
 - dismiss the ad view 
 
 [adView dismiss];
 
 if it's unlimited or remove it 
 
 [adView removeFromSuperView];
 
 @param adView An ad view object informing the delegate about the failure 
 
 */

- (void)sasViewDidFailToLoadAd:(SmartAdServerView *)adView {
    if (self.adView && self.adView.superview) {
        NSError* error = [[NSError alloc] initWithDomain:@"SAS ad request failed" code:235 userInfo:nil];
        NSMutableDictionary* info = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:error, self.adView.superview, nil]
                                                                       forKeys:[NSArray arrayWithObjects:@"error", @"adView", nil]];
        [error release];
        [[NotificationCenter sharedInstance] postNotificationName:kFailAdDownloadNotification object:info];
    }
}

/** Asks the delegate wether to execute ad action
 
 Implement this method if you want to process some urls yourself.
 
 @param url The url that will be called 
 
 @return Wether the Smart AdServer SDK should handle the URL
 
 @bug Returning NO means that the URL won't be processed by the SDK.
 
 @warning Please note that a click will be counted, even if you return "NO" (you are supposed to handle the URL in this case).
 
 */

-(BOOL)sasView:(SmartAdServerView *)adView shouldHandleUrl:(NSURL *)URL {
    if (self.adView && self.adView.superview) {
        // track url        
        [[NotificationCenter sharedInstance] postNotificationName:kTrackUrlNotification object:self.adView.superview];
        
        // send callback
        NSMutableDictionary* info = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSURLRequest requestWithURL:URL], self.adView.superview, nil]
                                                                       forKeys:[NSArray arrayWithObjects:@"request", @"adView", nil]];
        
        [[NotificationCenter sharedInstance] postNotificationName:kOpenURLNotification object:info];
    }
    return NO;
}

@end

#endif
