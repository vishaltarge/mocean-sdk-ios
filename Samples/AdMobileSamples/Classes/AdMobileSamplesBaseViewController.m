//
//  AdMobileSamplesBaseViewController.m
//  AdMobileSamples
//
//  Created by Slava Budnikov on 2/18/12.
//  Copyright (c) 2012 Team Force. All rights reserved.
//

#import "AdMobileSamplesBaseViewController.h"
#import "YXModelTableView.h"

@implementation AdMobileSamplesBaseViewController

#pragma mark -
#pragma mark Public functional

-(UIColor *)getViewBackgroundColor
{
	return [UIColor groupTableViewBackgroundColor];
}

-(UIImage *)getViewBackgroundImage
{
	return nil;//[UIImage imageNamed:@"Default.png"];
}

-(NSInteger)getBannerSite
{
	return 19829;
}

-(NSInteger)getBannerZone
{
	return 88269;
}

-(CGRect)getBannerFrame
{
	return  CGRectMake(0, 0, 320, 50);
}

-(UIViewAutoresizing)getBannerAutoresizing
{
	return UIViewAutoresizingFlexibleWidth;
}

#pragma mark -
#pragma mark Application lifecycle

- (void)viewDidLoad
{
	[super viewDidLoad];

	if ([self getViewBackgroundColor])
	{
		self.view.backgroundColor = [self getViewBackgroundColor];
	}
	
    UIImageView* imageView = [[UIImageView alloc] init];//WithImage:[UIImage imageNamed:@"Default.png"]];
    imageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
	[imageView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
	[imageView setContentMode:UIViewContentModeCenter];
	UIImage *img = [self getViewBackgroundImage];
	if ( img )
	{
		[imageView setImage:img];
		[self.view addSubview:imageView];		
	}
    [imageView release];
	
	_adView = [[MASTAdView alloc] initWithFrame:[self getBannerFrame]];
	[_adView setAutoresizingMask:[self getBannerAutoresizing]];
    _adView.site = [self getBannerSite];
    _adView.zone = [self getBannerZone];
	_adView.autoCollapse = YES;
    [self.view addSubview:_adView];
	
}

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	if (_buttonEdit == nil)
	{
		_buttonEdit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(buttonAction:)];
	}
	[self.navigationItem setRightBarButtonItem:_buttonEdit animated:animated];
}

-(void)buttonAction:(id)sender
{
	if (_actionSheet == nil)
	{
		_actionSheet = [[UIActionSheet alloc] initWithTitle:@"Action" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Edit params", @"Update", nil];
	}
	[_actionSheet showInView:self.view];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    //_adView.frame = CGRectMake(0, 0, self.view.frame.size.width, 50);
    [_adView update];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation
{	
	return YES;
}

-(void)addEtitParams:(YXSection *)section
{
	
}

-(void)showEditOption
{
	YXModelTableViewController* viewController = [[[YXModelTableViewController alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
	viewController.title = @"Setters";
	YXSection * section = [YXSection sectionWithHeader:nil footer:nil];
	
	[section addCell:[YXEditableCell cellWithTitle:@"x" placeholder:nil value:[NSString stringWithFormat:@"%.0f", _adView.frame.origin.x] onEdit:nil onFinish:^(id<YXModelCell> sender) {
		YXEditableCell* cell = (YXEditableCell*)sender;
		_adView.frame = CGRectMake([cell.value floatValue], _adView.frame.origin.y, _adView.frame.size.width, _adView.frame.size.height);
	} textFieldDelegate:nil]];
	
	[section addCell:[YXEditableCell cellWithTitle:@"y" placeholder:nil value:[NSString stringWithFormat:@"%.0f", _adView.frame.origin.y] onEdit:nil onFinish:^(id<YXModelCell> sender) {
		YXEditableCell* cell = (YXEditableCell*)sender;
		_adView.frame = CGRectMake(_adView.frame.origin.x, [cell.value floatValue], _adView.frame.size.width, _adView.frame.size.height);
	} textFieldDelegate:nil]];
	
	[section addCell:[YXEditableCell cellWithTitle:@"width" placeholder:nil value:[NSString stringWithFormat:@"%.0f", _adView.frame.size.width] onEdit:nil onFinish:^(id<YXModelCell> sender) {
		YXEditableCell* cell = (YXEditableCell*)sender;
		_adView.frame = CGRectMake(_adView.frame.origin.x, _adView.frame.origin.y, [cell.value floatValue], _adView.frame.size.height);
	} textFieldDelegate:nil]];
	
	[section addCell:[YXEditableCell cellWithTitle:@"height" placeholder:nil value:[NSString stringWithFormat:@"%.0f", _adView.frame.size.height] onEdit:nil onFinish:^(id<YXModelCell> sender) {
		YXEditableCell* cell = (YXEditableCell*)sender;
		_adView.frame = CGRectMake(_adView.frame.origin.x, _adView.frame.origin.y, _adView.frame.size.width, [cell.value floatValue]);
	} textFieldDelegate:nil]];
	
	//site
	[section addCell:[YXEditableCell cellWithTitle:@"site" placeholder:nil value:[NSString stringWithFormat:@"%i", _adView.site] onEdit:nil onFinish:^(id<YXModelCell> sender) {
		YXEditableCell* cell = (YXEditableCell*)sender;
		_adView.site = [cell.value intValue];
	} textFieldDelegate:nil]];
	//zone
	[section addCell:[YXEditableCell cellWithTitle:@"zone" placeholder:nil value:[NSString stringWithFormat:@"%i", _adView.zone] onEdit:nil onFinish:^(id<YXModelCell> sender) {
		YXEditableCell* cell = (YXEditableCell*)sender;
		_adView.zone = [cell.value intValue];
	} textFieldDelegate:nil]];	

	
	[section addCell:[YXEditableCell cellWithTitle:@"keywords" placeholder:nil value:_adView.keywords onEdit:nil onFinish:^(id<YXModelCell> sender) {
		YXEditableCell* cell = (YXEditableCell*)sender;
		_adView.keywords = cell.value;
	} textFieldDelegate:nil]];

	//minSize
	[section addCell:[YXEditableCell cellWithTitle:@"min height " placeholder:nil value:[NSString stringWithFormat:@"%.0f", _adView.minSize.height] onEdit:nil onFinish:^(id<YXModelCell> sender) {
		YXEditableCell* cell = (YXEditableCell*)sender;
		_adView.minSize = CGSizeMake(_adView.minSize.width, [cell.value floatValue]);
	} textFieldDelegate:nil]];
	
	[section addCell:[YXEditableCell cellWithTitle:@"min width" placeholder:nil value:[NSString stringWithFormat:@"%.0f", _adView.minSize.width] onEdit:nil onFinish:^(id<YXModelCell> sender) {
		YXEditableCell* cell = (YXEditableCell*)sender;
		_adView.minSize = CGSizeMake([cell.value floatValue], _adView.minSize.height);
	} textFieldDelegate:nil]];
	
	//maxSize
	[section addCell:[YXEditableCell cellWithTitle:@"max height " placeholder:nil value:[NSString stringWithFormat:@"%.0f", _adView.maxSize.height] onEdit:nil onFinish:^(id<YXModelCell> sender) {
		YXEditableCell* cell = (YXEditableCell*)sender;
		_adView.maxSize = CGSizeMake(_adView.maxSize.width, [cell.value floatValue]);
	} textFieldDelegate:nil]];
	
	[section addCell:[YXEditableCell cellWithTitle:@"max width" placeholder:nil value:[NSString stringWithFormat:@"%.0f", _adView.maxSize.width] onEdit:nil onFinish:^(id<YXModelCell> sender) {
		YXEditableCell* cell = (YXEditableCell*)sender;
		_adView.maxSize = CGSizeMake([cell.value floatValue], _adView.maxSize.height);
	} textFieldDelegate:nil]];
	
	//
	[section addCell:[YXEditableCell cellWithTitle:@"latitude" placeholder:nil value:_adView.latitude onEdit:nil onFinish:^(id<YXModelCell> sender) {
		YXEditableCell* cell = (YXEditableCell*)sender;
		_adView.latitude = cell.value;
	} textFieldDelegate:nil]];
	
	[section addCell:[YXEditableCell cellWithTitle:@"longitude" placeholder:nil value:_adView.longitude onEdit:nil onFinish:^(id<YXModelCell> sender) {
		YXEditableCell* cell = (YXEditableCell*)sender;
		_adView.longitude = cell.value;
	} textFieldDelegate:nil]];

	//
	[self addEtitParams:section];
	
	viewController.sections = [NSArray arrayWithObject:section];
	viewController.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
	viewController.tableView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
	[self.navigationController pushViewController:viewController animated:YES];	
}

#pragma mark -
#pragma mark Memory management

- (void) dealloc
{
	_adView.delegate = nil;
	[_adView release];
	[_buttonEdit release];
	[_actionSheet release];
	[super dealloc];
}

#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	switch (buttonIndex)
	{
		case 0:
			[self showEditOption];
			break;
		case 1:
			[_adView update];
			break;

		default:
			break;
	}
}

@end