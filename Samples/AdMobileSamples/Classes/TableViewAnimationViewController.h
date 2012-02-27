//
//  TableViewAnimationViewController.h
//  AdMobileSamples
//
//  Created by Ilya Rudometov on 8/4/10.
//

#import <UIKit/UIKit.h>
#import "AdMobileSamplesBaseViewController.h"

@interface TableViewAnimationViewController : AdMobileSamplesBaseViewController <UITableViewDataSource, UITableViewDelegate, MASTAdViewDelegate>
{
	UITableView* _tableView;
}

@end