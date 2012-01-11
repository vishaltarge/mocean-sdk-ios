//
//  TheWorldMethodTest.m
//  DeveloperTests
//
//  Created by artem samalov on 1/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TheWorldMethodTest.h"
#import "SimpleBannerVC.h"
#import "VideoBannerVC.h"

@implementation TheWorldMethodTest

@synthesize tableView, rows;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.rows = [NSMutableArray array];
    
    [self.rows addObject:@"Simple banner"];
    [self.rows addObject:@"Video view"];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    self.tableView = nil;
    self.rows = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        SimpleBannerVC *controller = [[SimpleBannerVC alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    } else if (indexPath.row == 1) {
        VideoBannerVC *controller = [[VideoBannerVC alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
}

#pragma mark - UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.rows count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellIdentifier = @"cellIdentifier";
	
	UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	}
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [self.rows objectAtIndex:indexPath.row]];
	
	return cell;
}

@end
