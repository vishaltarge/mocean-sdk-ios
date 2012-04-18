//
//  MASTSMenuController.m
//  MASTSamples
//
//  Created by Jason Dickert on 4/16/12.
//  Copyright (c) 2012 mOcean Mobile. All rights reserved.
//

#import "MASTSMenuController.h"

// Sample ad usage controllers:
#import "MASTSSimpleImage.h"
#import "MASTSSimpleInterstitial.h"
#import "MASTSSimpleRichMedia.h"
#import "MASTSSimpleText.h"
#import "MASTSAdvancedAnimation.h"
#import "MASTSAdvancedBottom.h"
#import "MASTSAdvancedTable.h"
#import "MASTSAdvancedTopAndBottom.h"
#import "MASTSAdvancedDelegate.h"
#import "MASTSCustom.h"


@interface MASTSMenuController ()

@end

@implementation MASTSMenuController

@synthesize delegate;

- (id)init
{
    self = [self initWithStyle:UITableViewStyleGrouped];
    if (self)
    {
        
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        self.title = @"Samples";
    }
    return self;
}

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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return 4;
        case 1:
            return 5;
        case 2:
            return 1;
    }
    return 0;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return @"Simple";
        case 1:
            return @"Advanced";
        case 2:
            return @"Custom";
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    NSString* label = nil;
    
    switch (indexPath.section)
    {
        case 0:
        {
            switch (indexPath.row)
            {
                case 0:
                    label = @"Image";
                    break;
                case 1:
                    label = @"Interstitial";
                    break;
                case 2:
                    label = @"Rich Media";
                    break;
                case 3:
                    label = @"Text";
                    break;
            }
            break;
        }
        case 1:
        {
            switch (indexPath.row)
            {
                case 0:
                    label = @"Animation";
                    break;
                case 1:
                    label = @"Bottom";
                    break;
                case 2:
                    label = @"Table";
                    break;
                case 3:
                    label = @"Top and Bottom";
                    break;
                case 4:
                    label = @"Delegate";
                    break;
            }
            break;
        }
        case 2:
        {
            label = @"Custom Ad Setup";
            break;
        }
    }
    
    cell.textLabel.text = label;

    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString* cellTitle = [[cell textLabel] text];
    
    UIViewController* testController = nil;
    
    switch (indexPath.section)
    {
        case 0:
        {
            switch (indexPath.row)
            {
                case 0:
                    testController = [[MASTSSimpleImage new] autorelease];
                    break;
                case 1:
                    testController = [[MASTSSimpleInterstitial new] autorelease];
                    break;
                case 2:
                    testController = [[MASTSSimpleRichMedia new] autorelease];
                    break;
                case 3:
                    testController = [[MASTSSimpleText new] autorelease];
                    break;
            }
            break;
        }
        case 1:
        {
            switch (indexPath.row)
            {
                case 0:
                    testController = [[MASTSAdvancedAnimation new] autorelease];
                    break;
                case 1:
                    testController = [[MASTSAdvancedBottom new] autorelease];
                    break;
                case 2:
                    testController = [[MASTSAdvancedTable new] autorelease];
                    break;
                case 3:
                    testController = [[MASTSAdvancedTopAndBottom new] autorelease];
                    break;
                case 4:
                    testController = [[MASTSAdvancedDelegate new] autorelease];
                    break;
            }
            break;
        }
        case 2:
        {
            switch (indexPath.row)
            {
                case 0:
                    testController = [[MASTSCustom new] autorelease];
                    break;
            }
        }
    }
    
    if (testController == nil)
        return;
    
    testController.title = cellTitle;
    
    if (self.delegate != nil)
    {
        [self.delegate menuController:self presentController:testController];
    }
    else
    {
        [self.navigationController pushViewController:testController animated:YES];
    }
}

@end
