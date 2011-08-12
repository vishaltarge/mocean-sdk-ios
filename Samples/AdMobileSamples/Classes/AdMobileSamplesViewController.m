//
//  AdMobileSamplesViewController.m
//  AdMobileSamples
//
//  Created by Ilya Rudometov on 8/2/10.
//

#import "AdMobileSamplesViewController.h"

@implementation AdMobileSamplesViewController

- (void)viewDidLoad {
    self.tableView = [[UITableView alloc] initWithFrame:self.tableView.frame style:UITableViewStyleGrouped];
    _sections = [NSMutableArray new];
    
    NSMutableArray* items = [NSMutableArray array];
    
    [items addObject:@"Simple banner"];
	[items addObject:@"Interstitial"];
	[items addObject:@"Video"];
	[items addObject:@"Rich JS Interstitial Ad"];
	[items addObject:@"OpenGL"];
    [items addObject:@"ORMMA"];
    [_sections addObject:items];
    
    items = [NSMutableArray array];
    
	[items addObject:@"Banner frame animation"];
	[items addObject:@"UITableView animation"];
    [_sections addObject:items];
    
    items = [NSMutableArray array];
    
	[items addObject:@"One Thousend ads!"];
	[items addObject:@"Video with Interstitial"];
	[items addObject:@"Orientations support"];
	[items addObject:@"Test custom site/zone"];
	[items addObject:@"Ad delegate (callback sample)"];
	[items addObject:@"Debug"];
    [_sections addObject:items];
    
    items = [NSMutableArray array];
    
	[items addObject:@"iAd"];
	[items addObject:@"Millennial"];
	[items addObject:@"iVdopia"];
	[items addObject:@"AdMob"];
	[items addObject:@"Greystripe"];
	[items addObject:@"Rhythm"];
	[items addObject:@"SmartAdServer"];
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
            viewController = [[InterstitialViewController alloc] init];
        else if (indexPath.row == 2)
            viewController = [[VideoViewController alloc] init];
        else if (indexPath.row == 3)
            viewController = [[RichJSadViewController alloc] init];
        else if (indexPath.row == 4)
            viewController = [[OpenGLViewController alloc] init];
		else if (indexPath.row == 5)
            viewController = [[ORMMAViewController alloc] init];
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 0)
            viewController = [[BannerAnimationViewController alloc] init];
        else if (indexPath.row == 1)
            viewController = [[TableViewAnimationViewController alloc] init];
    }
    else if (indexPath.section == 2) {
        if (indexPath.row == 0)
            viewController = [[TableViewCellSampleViewController alloc] init];
        else if (indexPath.row == 1)
            viewController = [[VideoWithInterstitilaViewController alloc] init];
        else if (indexPath.row == 2)
            viewController = [[RotationAdViewController alloc] init];
        else if (indexPath.row == 3)
            viewController = [[TestingViewController alloc] init];
        else if (indexPath.row == 4)
            viewController = [[DelegateViewController alloc] init];
        else if (indexPath.row == 5)
            viewController = [[DebugViewController alloc] init];
    }
    else if (indexPath.section == 3) {
        if (indexPath.row == 0)
            viewController = [[IAdViewController alloc] init];
        else if (indexPath.row == 1)
            viewController = [[MillennialViewController alloc] init];
        else if (indexPath.row == 2)
            viewController = [[IVdopiaViewController alloc] init];
        else if (indexPath.row == 3)
            viewController = [[AdMobViewController alloc] init];
        else if (indexPath.row == 4)
            viewController = [[GreystripeViewController alloc] init];
        else if (indexPath.row == 5)
            viewController = [[RhythmViewController alloc] init];
        else if (indexPath.row == 6)
            viewController = [[SASViewController alloc] init];
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
	}
    
    cell.textLabel.text = (NSString*)[(NSArray*)[_sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	
	return cell;
}

@end
