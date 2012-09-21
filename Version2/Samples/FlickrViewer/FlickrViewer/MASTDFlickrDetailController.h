//
//  MASTDFlickrDetailController.h
//  FlickrViewer
//
//  Copyright (c) 2012 mOcean Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MASTDFlickrImage.h"
#import "MASTAdDelegate.h"


@interface MASTDFlickrDetailController : UITableViewController <UIActionSheetDelegate,MASTAdViewDelegate>

@property (nonatomic, strong) MASTDFlickrImage* flickrImage;

@end
