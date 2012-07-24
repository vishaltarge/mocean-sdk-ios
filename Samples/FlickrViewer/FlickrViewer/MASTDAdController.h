//
//  MASTDAdController.h
//  FlickrViewer
//
//  Copyright (c) 2012 mOcean Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MASTDAdController;

@protocol MASTDAdControllerDelegate <NSObject>
@required

// Sent when the ad works (fetches and renders an ad).
- (void)adControllerDidReceiveAd:(MASTDAdController*)controller;

// Sent when the ad fails (network probelems, no content, whatever).
- (void)adControllerDidFailToReceiveAd:(MASTDAdController*)controller withError:(NSError*)error;

// Sent when the user clicks or interacts with the ad.
// May terminate/suspend the application if opened with Safari (or other external app).
- (void)adControllerAdOpened:(MASTDAdController*)controller;

// Sent when the user is done interacting with the ad.
// May be invoked after the appliction resumes if interaction caused the application to suspend.
- (void)adControllerAdClosed:(MASTDAdController*)controller;

@end


// The view for the controller will be the third party ad view.

@interface MASTDAdController : UIViewController

// Initializes the controller with the desired ad frame (relative to whatever superview it will be added to).
// The campaignId is used to allow the calling implementation to track the campaign the controller represents.
- (id)initWithAdFrame:(CGRect)adFrame campaignId:(NSString*)campaignId;

@property (nonatomic, readonly) CGRect adFrame;

@property (nonatomic, readonly) NSString* campaignId;

@property (nonatomic, strong) UIViewController* rootViewController;

@property (nonatomic, weak) id<MASTDAdControllerDelegate> delegate;

// Called to destory/cleanup whatever ad resources.
// Does not remove self.view from it's superview, the calling logic is responsible for that.
- (void)close;

- (void)update;

@end
