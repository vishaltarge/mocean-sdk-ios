/*
 *  AdView_Private.h
 *  AdMobileSDK
 *
 *  Created by Constantine Mureev on 3/1/11.
 *
 */

#import "AdView.h"
#import "AdModel.h"
#import "InstallManager.h"
#import "UIViewAdditions.h"

@interface AdView ()

- (void)buttonsAction:(id)sender;
- (void)prepareResources;

@property (readonly) AdModel*   adModel;
@property (readonly) NSString*  uid;

- (void)setDefaultValues;
- (void)registerObserver;

- (void)adDownloaded:(NSNotification*)notification;
- (void)addDefaultImage:(NSNotification*)notification;
- (void)dislpayAd:(NSNotification*)notification;

- (void)startAdDownload:(NSNotification*)notification;
- (void)adDisplayd:(NSNotification*)notification;
- (void)updateAd:(NSNotification*)notification;
- (void)openInternalBrowser:(NSNotification*)notification;
- (void)closeInternalBrowser:(NSNotification*)notification;
- (void)failToReceiveAd:(NSNotification*)notification;
- (void)ormmaEvent:(NSNotification*)notification;
- (void)adShouldOpenBrowser:(NSNotification*)notification;
- (void)adShouldOpenExternalApp:(NSNotification*)notification;
- (void)visibleAd:(NSNotification*)notification;
- (void)invisibleAd:(NSNotification*)notification;
- (void)deviceOrientationDidChange:(NSNotification*)notification;
- (void)receiveThirdParty:(NSNotification*)notification;

@end

