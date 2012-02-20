//
//  TheWorldMethodTest.h
//  DeveloperTests
//
//  Created by artem samalov on 1/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TheWorldMethodTest : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (retain) UITableView*         tableView;
@property (retain) NSMutableArray*      rows;

@end
