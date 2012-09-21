//
//  MASTDRootViewController.h
//  FlickrViewer
//
//  Copyright (c) 2012 mOcean Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MASTAdDelegate.h"
#import "MASTDAdController.h"
#import "GADBannerViewDelegate.h"


@interface MASTDRootViewController : UIViewController <UIPageViewControllerDelegate, UIActionSheetDelegate, MASTAdViewDelegate, MASTDAdControllerDelegate>

@property (strong, nonatomic) UIPageViewController *pageViewController;

@end
