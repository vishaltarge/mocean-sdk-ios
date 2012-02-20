//
//  TableViewAnimationViewController.h
//  AdMobileSamplesiPad
//
//  Created by Constantine Mureev on 8/10/11.
//

#import <UIKit/UIKit.h>
#import "MASTAdView.h"
#import "MASTAdDelegate.h"

@interface TableViewAnimationViewController : UIViewController <UITableViewDataSource, MASTAdViewDelegate>
{
	MASTAdView* _adView;
	
	UITableView* _tableView;
}

- (id)initWithFrame:(CGRect)frame;

- (void) hideBanner;
- (void)bannerDidHide:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;

@end
