//
//  YXModelTableViewController.h
//  YXModelTableViews
//
//  Created by Mikhail Kalugin on 5/11/10.
//  Copyright 2010 Yandex. All rights reserved.
//

#import "YXModelTableView.h"

@interface YXModelTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) NSArray *sections;
@property (nonatomic, strong) NSArray *accessoryGroup;
@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, strong, readonly) NSIndexPath *lastSelectedIndexPath;

- (id)initWithStyle:(UITableViewStyle)style;
- (UITableView *)createTableView;

@end
