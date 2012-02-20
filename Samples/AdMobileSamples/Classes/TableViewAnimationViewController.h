//
//  TableViewAnimationViewController.h
//  AdMobileSamples
//
//  Created by Ilya Rudometov on 8/4/10.
//

#import <UIKit/UIKit.h>
#import "AdMobileSamplesBaseViewController.h"

@interface TableViewAnimationViewController : AdMobileSamplesBaseViewController <UITableViewDataSource, AdViewDelegate>
{
	UITableView* _tableView;
}

- (void) hideBanner;
- (void)bannerDidHide:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;

@end
