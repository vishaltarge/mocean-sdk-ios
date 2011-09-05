//
//  AdInterstitialView.h
//  AdMobileSDK
//
//  Created by Constantine Mureev on 2/24/11.
//
//  version: 2.6.3
//

#import <UIKit/UIKit.h>

#import "AdView.h"


/** The AdInterstitialView class is subclassing of AdView with advanced customization parameters. An instance of AdInterstitialView  is a means for full-screen displaying ads with specific closing. 
 */
@interface AdInterstitialView : AdView {

}


/** @name Customizing AdInterstitialView Closing */


/** Show close button delay time interval, in seconds.
 
 Setting to 0 will show close button immediately.
 
 The default value is 0.
 */
@property NSTimeInterval showCloseButtonTime;

/** Auto close interstitial time interval, in seconds.
 
 Setting to 0 will disable auto closing interstitial.
 
 The default value is 0.
 */
@property NSTimeInterval autocloseInterstitialTime;

/** Interstitial close button.
 
 Set this value to customize close button appearance.
 */
@property (retain) UIButton* closeButton;


/** @name Setting the Delegate */


/** The receiver's delegate.
 
 The AdInterstitialView is sent messages when content is processing. The delegate must adopt the AdInterstitialViewDelegate protocol.
 The delegate is not retained.
 
 @warning *Important:* Before releasing an instance of AdInterstitialView for which you have set a delegate, you must first set its delegate property to nil. This can be done, for example, in your dealloc method.
 
 @see AdInterstitialViewDelegate Protocol Reference for the optional methods this delegate may implement.
 */
@property (assign) id <AdInterstitialViewDelegate>	delegate;


@end
