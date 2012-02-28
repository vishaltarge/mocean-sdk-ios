//
//  AdMobileSamplesViewController.h
//  AdMobileSamples
//
//  Created by Constantine Mureev on 8/2/10.
//

#import <UIKit/UIKit.h>

// simple
#import "SimpleBannerViewController.h"
//#import "SimpleBannerRetinaViewController.h"
//#import "InterstitialViewController.h"
#import "VideoViewController.h"
#import "OpenGLViewController.h"
#import "RichJSadViewController.h"
#import "InterstitialAdViewController.h"
#import "ORMMAViewController.h"

// animation
#import "BannerAnimationViewController.h"
#import "TableViewAnimationViewController.h"

// advanced
#import "TableViewCellSampleViewController.h"
#import "VideoWithInterstitilaViewController.h"
#import "RotationAdViewController.h"
#import "DelegateViewController.h"
#import "TestingViewController.h"

@interface AdMobileSamplesViewController : UITableViewController {
    NSMutableArray*         _sections;
}

@end

