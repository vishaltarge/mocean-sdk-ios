//
//  MASTDDataViewController.m
//  FlickrViewer
//
//  Copyright (c) 2012 mOcean Mobile. All rights reserved.
//

#import "MASTDDataViewController.h"
#import "MASTDFlickrDetailController.h"


@interface MASTDDataViewController ()

@end

@implementation MASTDDataViewController

@synthesize index;
@synthesize titleLabel, authorLabel, dateLabel, imageView;
@synthesize flickrImage;

static NSDateFormatter* dateFormatter = nil;

- (void)update
{
    self.titleLabel.text = self.flickrImage.title;
    self.authorLabel.text = self.flickrImage.author;
    
    if (dateFormatter == nil)
    {
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateStyle = NSDateFormatterShortStyle;
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
    }
    
    self.dateLabel.text = [dateFormatter stringFromDate:self.flickrImage.date_taken];
    
    self.imageView.image = self.flickrImage.image;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    self.titleLabel = nil;
    self.authorLabel = nil;
    self.dateLabel = nil;
    self.imageView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self update];
    
    if (self.navigationController.navigationBarHidden == NO)
        [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void)setFlickrImage:(MASTDFlickrImage *)image
{
    flickrImage = image;
    [self update];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([@"DetailSegue" isEqualToString:segue.identifier])
    {
        MASTDFlickrDetailController* detailController = segue.destinationViewController;
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
            detailController = (id)[(id)(segue.destinationViewController) topViewController];
  
        detailController.flickrImage = self.flickrImage;
        detailController.navigationItem.title = self.flickrImage.title;
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            [self.navigationController setNavigationBarHidden:NO animated:NO];
    }
}

@end
