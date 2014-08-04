//
//  MASTSAdvancedTable.m
//  AdMobileSamples
//
/*
 * PubMatic Inc. (“PubMatic”) CONFIDENTIAL
 * Unpublished Copyright (c) 2006-2014 PubMatic, All Rights Reserved.
 *
 * NOTICE:  All information contained herein is, and remains the property of PubMatic. The intellectual and technical concepts contained
 * herein are proprietary to PubMatic and may be covered by U.S. and Foreign Patents, patents in process, and are protected by trade secret or copyright law.
 * Dissemination of this information or reproduction of this material is strictly forbidden unless prior written permission is obtained
 * from PubMatic.  Access to the source code contained herein is hereby forbidden to anyone except current PubMatic employees, managers or contractors who have executed
 * Confidentiality and Non-disclosure agreements explicitly covering such access.
 *
 * The copyright notice above does not evidence any actual or intended publication or disclosure  of  this source code, which includes
 * information that is confidential and/or proprietary, and is a trade secret, of  PubMatic.   ANY REPRODUCTION, MODIFICATION, DISTRIBUTION, PUBLIC  PERFORMANCE,
 * OR PUBLIC DISPLAY OF OR THROUGH USE  OF THIS  SOURCE CODE  WITHOUT  THE EXPRESS WRITTEN CONSENT OF PubMatic IS STRICTLY PROHIBITED, AND IN VIOLATION OF APPLICABLE
 * LAWS AND INTERNATIONAL TREATIES.  THE RECEIPT OR POSSESSION OF  THIS SOURCE CODE AND/OR RELATED INFORMATION DOES NOT CONVEY OR IMPLY ANY RIGHTS
 * TO REPRODUCE, DISCLOSE OR DISTRIBUTE ITS CONTENTS, OR TO MANUFACTURE, USE, OR SELL ANYTHING THAT IT  MAY DESCRIBE, IN WHOLE OR IN PART.
 */
//

#import "MASTSAdvancedTable.h"
#import "MASTAdView.h"


@interface MASTSAdvancedTable ()
@property (nonatomic, assign) NSInteger tableZone;
@end

@implementation MASTSAdvancedTable

@synthesize tableZone;

- (id)init
{
    self = [self initWithStyle:UITableViewStylePlain];
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
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh:)] autorelease];
    }
    return self;
}

- (void)refresh:(id)sender
{
    MASTSAdConfigPrompt* prompt = [[[MASTSAdConfigPrompt alloc] initWithDelegate:self
                                                                            zone:self.tableZone] autorelease];
    [prompt show];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableZone = 102238;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

#pragma mark -

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.row > 0) && (indexPath.row % 5 == 0))
        return 50;
    
    return 44;
}

static NSString *CellIdentifier = @"Cell";
static NSString *AdCellIdentifier = @"AdCell";
static NSInteger AdViewTag = 123;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellId = CellIdentifier;
    
    if ((indexPath.row > 0) && (indexPath.row % 5 == 0))
        cellId = AdCellIdentifier;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:cellId] autorelease];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (cellId == AdCellIdentifier)
        {
            CGRect frame = CGRectMake(0, 0, tableView.bounds.size.width, 50);
            MASTAdView* adView = [[[MASTAdView alloc] initWithFrame:frame] autorelease];
            adView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
            adView.backgroundColor = [UIColor darkGrayColor];
            adView.logLevel = MASTAdViewLogEventTypeDebug;
            adView.tag = AdViewTag;
            [cell.contentView addSubview:adView];
        }
    }
    
    if (cellId == CellIdentifier)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    }
    else
    {
        MASTAdView* adView = (MASTAdView*)[cell.contentView viewWithTag:AdViewTag];
        adView.zone = self.tableZone;
        [adView update];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

#pragma mark -

- (void)configPromptCancel:(MASTSAdConfigPrompt *)prompt
{
    
}

- (void)configPrompt:(MASTSAdConfigPrompt*)prompt refreshWithZone:(NSInteger)zone
{
    self.tableZone = zone;
    
    NSArray* cells = [self.tableView visibleCells];
    
    for (UITableViewCell* cell in cells)
    {
        if (cell.reuseIdentifier == AdCellIdentifier)
        {
            MASTAdView* adView = (MASTAdView*)[cell.contentView viewWithTag:AdViewTag];
            adView.zone = zone;
            [adView update];
        }
    }
}

@end
