//
//  DetailViewController.h
//  AdMobileSamplesiPad
//
//  Created by Constantine Mureev on 8/10/11.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate>

@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;

- (void)showView:(UIView*)view;

@end
