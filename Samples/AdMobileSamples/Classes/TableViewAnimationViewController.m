//
//  TableViewAnimationViewController.m
//  AdMobileSamples
//
//  Created by Ilya Rudometov on 8/4/10.
//

#import "TableViewAnimationViewController.h"

#define AD_HEIGHT 50
#define ROWS_COUNT 20
#define AD_ROW 5

@implementation TableViewAnimationViewController

-(NSInteger)getBannerZone
{
	return 20249;
}

-(CGRect)getBannerFrame
{
	return CGRectMake(0, 0, self.view.bounds.size.width, AD_HEIGHT);
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	_adView.updateTimeInterval = 15;
	_adView.isAdChangeAnimated = NO;

	_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
	[_tableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
	_tableView.dataSource = self;
	_tableView.delegate = self;
	[self.view addSubview:_tableView];
}

- (void) dealloc
{
    [_tableView release];
	[super dealloc];
}

#pragma mark -
#pragma mark UITableViewDataSource Members

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return ROWS_COUNT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString* cellIdentifier = @"cellIdentifier";
	if ((indexPath.row % AD_ROW) == 0)
	{
		cellIdentifier = [NSString stringWithFormat:@"cellIdentifier_%i",indexPath.row];
	}

	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if (!cell)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell autorelease];
		
		if ((indexPath.row % AD_ROW) == 0)
		{
			MASTAdView* ad = [[MASTAdView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50) site:8061 zone:20249];
			ad.updateTimeInterval = 5 + indexPath.row;
			
			[cell.contentView addSubview:ad];
			[ad release];			
		}
	}
	if ((indexPath.row % AD_ROW) != 0)
	{
		cell.textLabel.text = [NSString stringWithFormat:@"Cell %d", indexPath.row];
	}
	return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate Members

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ((indexPath.row % AD_ROW) == 0 )
	{
		return AD_HEIGHT;
	}
	return 44.0f;
}

@end