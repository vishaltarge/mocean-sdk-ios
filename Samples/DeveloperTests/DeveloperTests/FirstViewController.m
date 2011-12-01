//
//  FirstViewController.m
//  DeveloperTests
//
//  Created by Константин Муреев on 12/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "FirstViewController.h"

@implementation FirstViewController

@synthesize tableView, sections;

							
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    self.title = NSLocalizedString(@"Lab", @"Lab");
    
    [super viewDidLoad];
    
    self.sections = [NSMutableArray array];
    
    NSMutableArray* items = [NSMutableArray array];
    
    [items addObject:@"Test 1"];
    [items addObject:@"Test 2"];
    [self.sections addObject:items];
    
    items = [NSMutableArray array];
    
	[items addObject:@"Test 3"];
    [self.sections addObject:items];
    
    items = [NSMutableArray array];
    
	[items addObject:@"Test 4"];
    [self.sections addObject:items];
    
    self.tableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain] autorelease];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.tableView = nil;
    self.sections = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	UIViewController* viewController = nil;
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0)
            viewController = [[Test1 alloc] init];
        else if (indexPath.row == 1)
            viewController = [[Test2 alloc] init];
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0)
            viewController = [[Test3 alloc] init];
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0)
            viewController = [[Test4 alloc] init];
    }
    
    if (!viewController) {
		return;
	} else {
        [self.navigationController pushViewController:viewController animated:YES];
        viewController.title = [(NSArray*)[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        [viewController release];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [(NSArray*)[self.sections objectAtIndex:section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Group 1";
    } else if (section == 1) {
        return @"Group 2";
    } else if (section == 2) {
        return @"Group 3";
    } else {
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString* cellIdentifier = @"cellIdentifier";
	
	UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	}
    
    cell.textLabel.text = (NSString*)[(NSArray*)[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	
	return cell;
}

@end
