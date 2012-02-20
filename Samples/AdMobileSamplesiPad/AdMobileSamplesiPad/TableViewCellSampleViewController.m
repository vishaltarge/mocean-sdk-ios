//
//  TableViewCellSampleViewController.m
//  AdMobileSamplesiPad
//
//  Created by Constantine Mureev on 8/10/11.
//

#import "TableViewCellSampleViewController.h"
#import "MASTAdView.h"

#define ADS_COUNT 1000

@implementation TableViewCellSampleViewController

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.tableView.frame = frame;
    }
    
    return self;
}

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
		
        MASTAdView* ad = [[MASTAdView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50) site:8061 zone:20249];
		ad.updateTimeInterval = 5;
        ad.contentAlignment = YES;
        
        [cell.contentView addSubview:ad];
        [ad release];
	}
	
	return cell;
}

@end