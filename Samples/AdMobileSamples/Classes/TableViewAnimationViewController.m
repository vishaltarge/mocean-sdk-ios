//
//  TableViewAnimationViewController.m
//  AdMobileSamples
//
//  Created by Ilya Rudometov on 8/4/10.
//

#import "TableViewAnimationViewController.h"

#define AD_HEIGHT 50
#define ROWS_COUNT 20

@implementation TableViewAnimationViewController

-(NSInteger)getBannerZone
{
	return 20249;
}

-(CGRect)getBannerFrame
{
	return CGRectMake(0, -AD_HEIGHT, self.view.bounds.size.width, AD_HEIGHT);
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	_adView.updateTimeInterval = 15;
	_adView.animateMode = NO;
	_adView.delegate = self;

	_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - AD_HEIGHT)];
	[_tableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
	_tableView.dataSource = self;
	[self.view addSubview:_tableView];
}

- (void) dealloc
{
    [_tableView release];
	[super dealloc];
}

- (void) hideBanner
{
	CGRect adFrame = _adView.frame;
	adFrame.origin.y = -AD_HEIGHT;
	CGRect tableViewFrame = _tableView.frame;
	tableViewFrame.origin.y = 0;
	tableViewFrame.size.height = self.view.bounds.size.height;
	
    [UIView animateWithDuration:0.2 animations:^{
        _adView.frame = adFrame;
        _tableView.frame = tableViewFrame;
    }];
}

- (void)bannerDidHide:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	
}

#pragma mark -
#pragma mark AdViewDelegate Members

- (void) didReceiveAd:(id)sender
{
	CGRect adFrame = _adView.frame;
	CGRect tableViewFrame = _tableView.frame;
	
	if (adFrame.origin.y >= 0)
		return;
    
	adFrame.origin.y = 0;
	tableViewFrame.origin.y = AD_HEIGHT;
	tableViewFrame.size.height -= AD_HEIGHT;
    
    [UIView animateWithDuration:0.2 animations:^{
        _adView.frame = adFrame;
        _tableView.frame = tableViewFrame;
    } completion:^(BOOL finished) {
        [self performSelector:@selector(hideBanner) withObject:nil afterDelay:5];
    }];
}

#pragma mark -
#pragma mark UITableViewDataSource Members

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return ROWS_COUNT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString* cellIdentifier = @"cellIdentifier";
	
	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if (!cell)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	}
	
	cell.textLabel.text = [NSString stringWithFormat:@"Cell %d", indexPath.row];
	
	return cell;
}

@end
