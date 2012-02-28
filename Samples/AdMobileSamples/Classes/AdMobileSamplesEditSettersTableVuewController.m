//
//  AdMobileSaplesEditSettersTableVuewController.m
//  AdMobileSamples
//
//  Created by Slava Budnikov on 2/24/12.
//  Copyright (c) 2012 Team Force. All rights reserved.
//

#import "AdMobileSamplesEditSettersTableVuewController.h"
#import "YXEditableCell.h"
#import "YXEditableViewCell.h"
#import "AdMobileSampleEditFrameView.h"

@implementation AdMobileSamplesEditSettersTableVuewController

- (id)initWithStyle:(UITableViewStyle)style banner:(MASTAdView*)adView
{
    self = [super initWithStyle:style];
    if (self)
	{
		_adView = adView;
		
		_site = [[UITextField alloc] init];
		[_site setPlaceholder:@"site"];
		[_site setText:[NSString stringWithFormat:@"%i",adView.site]];
		[_site setDelegate:self];
		
		_zone = [[UITextField alloc] init];
		[_zone setPlaceholder:@"zone"];
		[_zone setText:[NSString stringWithFormat:@"%i",adView.zone]];
		[_zone setDelegate:self];
    }
    return self;
}

-(void)dealloc
{
	[_site release];
	[_zone release];
	[super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
	[_adView update];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	[self.tableView reloadData];
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%i",indexPath.row];
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (indexPath.row == 0)
	{
		if (cell == nil)
		{
			cell = [[[AdMobileSampleEditFrameView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier banner:_adView] autorelease];
		}
		[(AdMobileSampleEditFrameView*)cell update];
	}
	else 
	{
		if (indexPath.row == 1)
		{
			if (cell == nil)
			{
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
				[cell.textLabel setText:@"site"];
				[_site setFrame:CGRectMake(70, 11, 240, 34)];
				[cell addSubview:_site];
			}
		}
		else if (indexPath.row == 2)
		{
			if (cell == nil)
			{
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
				[cell.textLabel setText:@"zone"];
				[_zone setFrame:CGRectMake(70, 11, 240, 34)];
				[cell addSubview:_zone];
			}
		}
	}

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{   
	if (indexPath.row == 0)
	{
		return 200;
	}
    return 44.0f;
}

- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
	NSCharacterSet *validCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
	
	BOOL shouldChange = 
	[string length] == 0 ||
	[string rangeOfCharacterFromSet:validCharacterSet].location != NSNotFound;
	
	if (!shouldChange)
	{
		return NO;// Tell the user they did something wrong.
	}
	NSString *str = [NSString stringWithFormat:@"%@%@",textField.text,string];	

	NSLog(@"%@",str);
	
	if (textField == _zone)
	{
		_adView.zone = [str intValue];
	}
	else if (textField == _site)
	{
		_adView.site = [str intValue];
	}	
	return YES;
}

@end
