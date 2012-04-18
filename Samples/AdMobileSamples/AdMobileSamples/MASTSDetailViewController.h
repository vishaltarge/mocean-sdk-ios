//
//  MASTSDetailViewController.h
//  AdMobileSamples
//
//  Created by Jason Dickert on 4/15/12.
//  Copyright (c) 2012 Network Coders. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MASTSDetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
