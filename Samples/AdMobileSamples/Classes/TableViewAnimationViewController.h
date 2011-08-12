//
//  TableViewAnimationViewController.h
//  AdMobileSamples
//
//  Created by Ilya Rudometov on 8/4/10.
//

#import <UIKit/UIKit.h>
#import "AdView.h"
#import "AdDelegate.h"

@interface TableViewAnimationViewController : UIViewController <UITableViewDataSource, AdViewDelegate>
{
	AdView* _adView;
	
	UITableView* _tableView;
}

- (void) hideBanner;
- (void)bannerDidHide:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;

@end
