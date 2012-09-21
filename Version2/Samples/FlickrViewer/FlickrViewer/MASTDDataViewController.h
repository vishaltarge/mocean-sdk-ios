//
//  MASTDDataViewController.h
//  FlickrViewer
//
//  Copyright (c) 2012 mOcean Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MASTDFlickrImage.h"


@interface MASTDDataViewController : UIViewController

@property (nonatomic, assign) NSUInteger index;

@property (nonatomic, strong) IBOutlet UILabel* titleLabel;
@property (nonatomic, strong) IBOutlet UILabel* authorLabel;
@property (nonatomic, strong) IBOutlet UILabel* dateLabel;
@property (nonatomic, strong) IBOutlet UIImageView* imageView;

@property (nonatomic, strong) MASTDFlickrImage* flickrImage;

@end
