//
//  RootViewController.h
//  AdMobileSamplesiPad
//
//  Created by Constantine Mureev on 8/10/11.
//

#import <UIKit/UIKit.h>

// Simple
#import "SimpleBannerViewController.h"
#import "InterstitialViewController.h"
#import "VideoViewController.h"
#import "OpenGLViewController.h"
#import "RichJSadViewController.h"

// Animation
#import "BannerAnimationViewController.h"
#import "TableViewAnimationViewController.h"

// Advanced
#import "TableViewCellSampleViewController.h"
#import "VideoWithInterstitilaViewController.h"
#import "ORMMAViewController.h"

@class DetailViewController;

@interface RootViewController : UITableViewController {
    NSMutableArray*         _sections;
}

@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;

@end
