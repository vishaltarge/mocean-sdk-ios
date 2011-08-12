//
//  TableViewCellSampleViewController.m
//  AdMobileSamples
//
//  Created by Ilya Rudometov on 8/4/10.
//

#import "TableViewCellSampleViewController.h"
#import "AdView.h"

#define ADS_COUNT 1000

@implementation TableViewCellSampleViewController


- (void) dealloc
{
	[super dealloc];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return ADS_COUNT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString* cellIdentifier = @"cellIdentifier";
	
	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if (!cell)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
		
        AdView* ad = [[AdView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50) site:8061 zone:20249];
		ad.updateTimeInterval = 15;
        
        [cell.contentView addSubview:ad];
        [ad release];
	}
	
	return cell;
}

@end