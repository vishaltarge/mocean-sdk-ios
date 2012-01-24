//
//  TableViewAnimationViewController.h
//  AdMobileSamples
//
//  Created by Ilya Rudometov on 8/4/10.
//

#import <UIKit/UIKit.h>
#import "MASTAdView.h"
#import "MASTAdDelegate.h"

@interface TableViewAnimationViewController : UIViewController <UITableViewDataSource, MASTAdViewDelegate>
{
	MASTAdView* _adView;
	
	UITableView* _tableView;
}

- (void) hideBanner;
- (void)bannerDidHide:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;

@end
