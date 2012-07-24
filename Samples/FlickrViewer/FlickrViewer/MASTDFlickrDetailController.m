//
//  MASTDFlickrDetailController.m
//  FlickrViewer
//
//  Copyright (c) 2012 mOcean Mobile. All rights reserved.
//

#import "MASTDFlickrDetailController.h"
#import "MASTAdView.h"
#import "MASTDFlickrDescriptionCell.h"
#import "MASTDBookmarks.h"


@interface MASTDFlickrDetailController ()
@property (nonatomic, strong) MASTAdView* adView;
@property (nonatomic, strong) UIActionSheet* currentActionSheet;
@end

@implementation MASTDFlickrDetailController


@synthesize flickrImage;
@synthesize adView;
@synthesize currentActionSheet;
 

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.adView = [[MASTAdView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    self.adView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
    self.adView.backgroundColor = [UIColor blackColor];
    
    self.adView.site = 19829;
    self.adView.zone = 112075;
    
    self.adView.updateTimeInterval = 45;

    self.adView.logMode = AdLogModeAll;
    
    self.tableView.tableHeaderView = self.adView;
    
    [self.adView update];
    
    // Add an empty footer to remove extra table separators.
    self.tableView.tableFooterView = [UIView new];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
} 

#pragma mark - 

- (IBAction)doneButton:(id)sender
{
    [self.currentActionSheet dismissWithClickedButtonIndex:[self.currentActionSheet cancelButtonIndex]
                                                  animated:NO];
    
    [self.presentingViewController dismissModalViewControllerAnimated:YES];
}

- (IBAction)actionButton:(id)sender
{
    if ([self.currentActionSheet isVisible])
    {
        [self.currentActionSheet dismissWithClickedButtonIndex:[self.currentActionSheet cancelButtonIndex]
                                                      animated:YES];
        return;
    }
    
    NSString* title = @"Add to Bookmarks";
    NSInteger tag = 100;
    
    BOOL bookmarked = [MASTDBookmarks contains:self.flickrImage];
    
    if (bookmarked)
    {
        title = @"Remove Bookmark";
        tag = 200;
    }

    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:title, nil];
    actionSheet.tag = tag;
    [actionSheet showFromBarButtonItem:sender animated:YES];
}

#pragma mark -

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex)
        return;
    
    switch (actionSheet.tag)
    {
        case 100:
            [MASTDBookmarks add:self.flickrImage];
            break;
            
        case 200:
            [MASTDBookmarks remove:self.flickrImage];
            break;
    }
    
    self.currentActionSheet = nil;
}

- (void)didPresentActionSheet:(UIActionSheet *)actionSheet
{
    self.currentActionSheet = actionSheet;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // One for each MASTDFlickrImage property to display; and only the ones that make sense to display.
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
        return 320;
    
    return tableView.rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* CellIdentifier = @"DatapointCell";
    
    if (indexPath.row == 0)
    {
        CellIdentifier = @"DescriptionCell";
    }
    
    id cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    static NSDateFormatter* dateFormatter = nil;
    if (dateFormatter == nil)
    {
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateFormatter.timeStyle = NSDateFormatterShortStyle;
    }
    
    switch (indexPath.row)
    {
        case 0:
            [cell setDesc:self.flickrImage.desc];
            break;

        case 1:
            [[cell textLabel] setText:@"author"];
            [[cell detailTextLabel] setText:self.flickrImage.author];
            break;
            
        case 2:
            [[cell textLabel] setText:@"title"];
            [[cell detailTextLabel] setText:self.flickrImage.title];
            break;
            
        case 3:
            [[cell textLabel] setText:@"taken"];
            [[cell detailTextLabel] setText:[dateFormatter stringFromDate:self.flickrImage.date_taken]];
            break;
           
        case 4:
            [[cell textLabel] setText:@"published"];
            [[cell detailTextLabel] setText:[dateFormatter stringFromDate:self.flickrImage.published]];
            break;
        
        case 5:
            [[cell textLabel] setText:@"link"];
            [[cell detailTextLabel] setText:self.flickrImage.link];
            break;
        
        // TODO: Impelement other cell labels and values
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.row == 5) && ([self.flickrImage.link length] > 0))
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.flickrImage.link]];
}

@end
