//
//  AdMobileSamplesAppDelegate.h
//  AdMobileSamples
//
//  Created by Ilya Rudometov on 8/2/10.
//

#import <UIKit/UIKit.h>

@class AdMobileSamplesViewController;

@interface AdMobileSamplesAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

