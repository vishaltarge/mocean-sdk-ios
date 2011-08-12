//
//  TableViewAnimationViewController.h
//  AdMobileSamplesiPad
//
//  Created by Constantine Mureev on 8/10/11.
//

#import <UIKit/UIKit.h>
#import "AdView.h"
#import "AdDelegate.h"

@interface TableViewAnimationViewController : UIViewController <UITableViewDataSource, AdViewDelegate>
{
	AdView* _adView;
	
	UITableView* _tableView;
}

- (id)initWithFrame:(CGRect)frame;

- (void) hideBanner;
- (void)bannerDidHide:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;

@end
