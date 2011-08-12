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


// Called when an ad using SAS service did load.
- (void)didDownloadSmartAdServerView:(SmartAdServerView *)smartAdServerView {
	if (self.adView && self.adView.superview) {        
        NSMutableDictionary* senfInfo = [NSMutableDictionary dictionary];
        [senfInfo setObject:self.adView.superview forKey:@"adView"];
        [senfInfo setObject:self.adView forKey:@"subView"];
        [[NotificationCenter sharedInstance] postNotificationName:kReadyAdDisplayNotification object:senfInfo];
    }
}

// Called when an ad using SAS service did fail to download.
// Your can return nil or a SmartAdServerDefaultAd if you want it to be shown instead of the expected ad.
- (SmartAdServerAd *)didFailDownloadingSmartAdServerView:(SmartAdServerView *)smartAdServerView
{
	// ad serving has failed, present a local ad
	/*SmartAdServerAd *defaultAd = [[SmartAdServerAd alloc] initWithPortraitImage:[UIImage imageNamed:@"sas.png"]
	 landscapeImage:[UIImage imageNamed:@"sas.png"]
	 clickURL:[NSURL URLWithString:@"http://www.smartadserver.com"]];
	 return defaultAd;*/
	//[smartAdServerView release];
    
    if (self.adView && self.adView.superview) {
        NSError* error = [[NSError alloc] initWithDomain:@"SAS ad request failed" code:235 userInfo:nil];
        NSMutableDictionary* info = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:error, self.adView.superview, nil]
                                                                       forKeys:[NSArray arrayWithObjects:@"error", @"adView", nil]];
        [error release];
        [[NotificationCenter sharedInstance] postNotificationName:kFailAdDownloadNotification object:info];
    }
    
	return nil;
}

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
        UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
        if (!vc) {
            vc = [self.adView.superview viewControllerForView];
        }
        
        [vc presentModalViewController:modalViewController animated:animated];
    }
}

- (void)dismissModalViewControllerAnimated:(BOOL)animated {
    if (self.adView && self.adView.superview) {
        UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
        if (!vc) {
            vc = [self.adView.superview viewControllerForView];
        }
        
        [vc dismissModalViewControllerAnimated:animated];
    }    
}

@end

#endif
