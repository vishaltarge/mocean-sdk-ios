//
//  AdInterstitialView.h
//  AdMobileSDK
//
//  Created by Constantine Mureev on 2/24/11.
//
//  version: 2.9.0
//

#import <UIKit/UIKit.h>

#import "AdView.h"


/** The AdInterstitialView class is subclassing of AdView with advanced customization parameters. An instance of AdInterstitialView  is a means for full-screen displaying ads with specific closing. 
 */
@interface AdInterstitialView : AdView {

}

/** @name Customizing AdInterstitialView Closing */


/** Close button.
 
 Set this value to customize close button appearance and behaviour.
 
 By default closed button set by SDK.
 
 @warning *Note:* If you set set UIButton then you need implement close logic too.
 */
@property (retain) UIButton*            closeButton;

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


/** @name Setting the Delegate */


/** The receiver's delegate.
 
 The AdInterstitialView is sent messages when content is processing. The delegate must adopt the AdViewDelegate protocol.
 The delegate is not retained.
 
 @warning *Important:* Before releasing an instance of AdInterstitialView for which you have set a delegate, you must first set its delegate property to nil. This can be done, for example, in your dealloc method.
 
 @see AdViewDelegate Protocol Reference for the optional methods this delegate may implement.
 */
@property (assign) id <AdViewDelegate>	delegate;


@end
