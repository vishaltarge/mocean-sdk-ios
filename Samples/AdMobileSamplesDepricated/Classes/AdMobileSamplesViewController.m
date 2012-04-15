//
//  AdMobileSamplesViewController.m
//  AdMobileSamples
//
//  Created by Ilya Rudometov on 8/2/10.
//

#import "AdMobileSamplesViewController.h"

@implementation AdMobileSamplesViewController

- (void)viewDidLoad {
    self.tableView = [[[UITableView alloc] initWithFrame:self.tableView.frame style:UITableViewStyleGrouped] autorelease];
    _sections = [NSMutableArray new];
    
    NSMutableArray* items = [NSMutableArray array];
    
    [items addObject:@"Simple banner"];
	//[items addObject:@"Video"];
	[items addObject:@"Rich JS Interstitial Ad"];
	[items addObject:@"Interstitial Ad"];
	[items addObject:@"OpenGL"];
    [items addObject:@"ORMMA"];
    //[items addObject:@"ORMMA example 2"];
    //[items addObject:@"ORMMA example 3"];
    [_sections addObject:items];
    
    items = [NSMutableArray array];
    
	//[items addObject:@"Banner frame animation"];
	[items addObject:@"Banner in list view"];
    [_sections addObject:items];
    
    items = [NSMutableArray array];
    
	[items addObject:@"One Thousend ads!"];
	[items addObject:@"Ad delegate (callback sample)"];
    [_sections addObject:items];
}

- (void)dealloc{
    [_sections release];
    [super dealloc];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	UIViewController* viewController = nil;
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0)
            viewController = [[SimpleBannerViewController alloc] init];
        else if (indexPath.row == 1)
            viewController = [[RichJSadViewController alloc] init];
		else if (indexPath.row == 2)
			viewController = [[InterstitialAdViewController alloc] init];
        else if (indexPath.row == 3)
            viewController = [[OpenGLViewController alloc] init];
		else if (indexPath.row == 4)
			viewController = [[ORMMAViewController alloc] init];
		/*else if (indexPath.row == 5)
			viewController = [[ORMMAViewController alloc] initWithZone:53920 site:17340];
		else if (indexPath.row == 6)
			viewController = [[ORMMAViewController alloc] initWithZone:53919 site:17340];*/
    }
    else if (indexPath.section == 1) {
        /*if (indexPath.row == 0)
            viewController = [[BannerAnimationViewController alloc] init];
        else */if (indexPath.row == 0)
            viewController = [[TableViewAnimationViewController alloc] init];
    }
    else if (indexPath.section == 2) {
        if (indexPath.row == 0)
            viewController = [[TableViewCellSampleViewController alloc] init];
        else if (indexPath.row == 1)
            viewController = [[DelegateViewController alloc] init];
    }
    
    if (!viewController) {
		return;
	}
    else {
        [self.navigationController pushViewController:viewController animated:YES];
        viewController.title = [(NSArray*)[_sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        [viewController release];
    }
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString* cellIdentifier = @"cellIdentifier";
	
	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell autorelease];
	}
    
    cell.textLabel.text = (NSString*)[(NSArray*)[_sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	
	return cell;
}

@end
