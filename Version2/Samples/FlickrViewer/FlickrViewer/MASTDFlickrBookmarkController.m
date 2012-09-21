//
//  MASTDFlickrBookmarkController.m
//  FlickrViewer
//
//  Copyright (c) 2012 mOcean Mobile. All rights reserved.
//

#import "MASTDFlickrBookmarkController.h"
#import "MASTDBookmarks.h"
#import "MASTDFlickrImage.h"
#import "MASTDFlickrBookmarkCell.h"
#import "MASTDFlickrDetailController.h"


@interface MASTDFlickrBookmarkController ()

@end

@implementation MASTDFlickrBookmarkController

- (void)viewDidLoad
{
    self.tableView.tableHeaderView = [UIView new];
    self.tableView.tableFooterView = [UIView new];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [MASTDBookmarks count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BookmarkCell";
    
    id cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    MASTDFlickrImage* flickrImage = [MASTDBookmarks bookmarkAtIndex:indexPath.row];
    
    [cell setTitle:flickrImage.title];
    [cell setLink:flickrImage.link];
    [cell setImage:flickrImage.image];
    
    // Set the tag to the index so it can be extracted during the segue (see below).
    [cell setTag:indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate

#pragma mark -

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([@"BookmarkDetailSegue" isEqualToString:segue.identifier])
    {
        // Covers the case of iPad having a Done button on the detail controller.
        // In this case we'd rather have a back button.
        MASTDFlickrDetailController* controller = (MASTDFlickrDetailController*)segue.destinationViewController;
        controller.navigationItem.leftBarButtonItem = nil;
        
        // The index comes from the cell's tag property.
        controller.flickrImage = [MASTDBookmarks bookmarkAtIndex:[sender tag]];
    
        controller.navigationItem.title = controller.flickrImage.title;
    }
}

@end
