//
//  FirstViewController.h
//  DeveloperTests
//
//  Created by Константин Муреев on 12/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Test1.h"
#import "Test2.h"
#import "Test3.h"
#import "Test4.h"

@interface FirstViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (retain) UITableView*         tableView;
@property (retain) NSMutableArray*      sections;

@end
