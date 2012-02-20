//
//  TableViewCellSampleViewController.m
//  AdMobileSamples
//
//  Created by Ilya Rudometov on 8/4/10.
//

#import "TableViewCellSampleViewController.h"
#import "MASTAdView.h"

#define ADS_COUNT 1000

@implementation TableViewCellSampleViewController


- (void)viewDidLoad {
    _ads = [NSMutableArray new];
    
    [super viewDidLoad];
}

- (void) dealloc
{
    for (MASTAdView* ad in _ads) {
        [ad removeFromSuperview];
    }
    [_ads release];
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
	
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
		
        MASTAdView* ad = [[MASTAdView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50) site:8061 zone:20249];
		ad.updateTimeInterval = 15;
        [_ads addObject:ad];
        
        [cell.contentView addSubview:ad];
        [ad release];
	}
	
	return cell;
}

@end
