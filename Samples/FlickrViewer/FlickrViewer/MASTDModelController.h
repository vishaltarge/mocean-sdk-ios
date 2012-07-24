//
//  MASTDModelController.h
//  FlickrViewer
//
//  Copyright (c) 2012 mOcean Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MASTDFlickr.h"


@class MASTDDataViewController;

@interface MASTDModelController : NSObject <UIPageViewControllerDataSource, MASTDFlickrDelegate>

- (MASTDDataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(MASTDDataViewController *)viewController;

@end
