//
//  TableViewAnimationViewController.h
//  AdMobileSamples
//
//  Created by Ilya Rudometov on 8/4/10.
//

#import <UIKit/UIKit.h>
#import "MASTAdView.h"
#import "MASTAdDelegate.h"

@interface TableViewAnimationViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MASTAdViewDelegate>
{
	UITableView		*_tableView;
	NSMutableArray 	*_banners;
}

@end