//
//  RootViewController.m
//  AdMobileSamplesiPad
//
//  Created by Constantine Mureev on 8/10/11.
//

#import "RootViewController.h"

#import "DetailViewController.h"

@implementation RootViewController
		
@synthesize detailViewController;

- (void)viewDidLoad
{
    _sections = [NSMutableArray new];
    
    NSMutableArray* items = [NSMutableArray array];
    
    [items addObject:@"Simple banner"];
	[items addObject:@"Interstitial"];
	[items addObject:@"Video"];
	[items addObject:@"Rich JS Interstitial Ad"];
	[items addObject:@"OpenGL"];
    [_sections addObject:items];
    
    items = [NSMutableArray array];
    
	[items addObject:@"Banner frame animation"];
	[items addObject:@"UITableView animation"];
    [_sections addObject:items];
    
    items = [NSMutableArray array];
    
	[items addObject:@"One Thousend ads!"];
	[items addObject:@"Video with Interstitial"];
    [items addObject:@"ORMMA"];
    [_sections addObject:items];
    
    items = [NSMutableArray array];
    
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [(NSArray*)[_sections objectAtIndex:section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Simple";
    }
    else if (section == 1) {
        return @"Animation examples";
    }
    else if (section == 2) {
        return @"Advanced";
    }
    else if (section == 3) {
        return @"3rd Party";
    }
    else {
        return nil;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	UIViewController* viewController = nil;
    
    CGRect newFrame = CGRectMake(0, 44, detailViewController.view.frame.size.width, detailViewController.view.frame.size.height-44);
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0)
            viewController = [[SimpleBannerViewController alloc] initWithFrame:newFrame];
        else if (indexPath.row == 1)
            viewController = [[InterstitialViewController alloc] initWithFrame:newFrame];
        else if (indexPath.row == 2)
            viewController = [[VideoViewController alloc] initWithFrame:newFrame];
        else if (indexPath.row == 3)
            viewController = [[RichJSadViewController alloc] initWithFrame:newFrame];
        else if (indexPath.row == 4)
            viewController = [[OpenGLViewController alloc] initWithFrame:newFrame];
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 0)
            viewController = [[BannerAnimationViewController alloc] initWithFrame:newFrame];
        else if (indexPath.row == 1)
            viewController = [[TableViewAnimationViewController alloc] initWithFrame:newFrame];
    }
    else if (indexPath.section == 2) {
        if (indexPath.row == 0)
            viewController = [[TableViewCellSampleViewController alloc] initWithFrame:newFrame];
        else if (indexPath.row == 1)
            viewController = [[VideoWithInterstitilaViewController alloc] initWithFrame:newFrame];
        else if (indexPath.row == 2)
            viewController = [[ORMMAViewController alloc] initWithFrame:newFrame];
    }
    
    if (!viewController) {
		return;
	}
    else {        
        [detailViewController showView:viewController.view];
    }
}

		
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.text = (NSString*)[(NSArray*)[_sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    		
    return cell;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (void)dealloc
{
    [detailViewController release];
    [super dealloc];
}

@end
