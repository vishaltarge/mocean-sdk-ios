//
//  MASTDModelController.m
//  FlickrViewer
//
//  Copyright (c) 2012 mOcean Mobile. All rights reserved.
//

#import "MASTDModelController.h"
#import "MASTDDataViewController.h"
#import "MASTDFlickr.h"

/*
 A controller object that manages a simple model -- a collection of month names.
 
 The controller serves as the data source for the page view controller; it therefore implements pageViewController:viewControllerBeforeViewController: and pageViewController:viewControllerAfterViewController:.
 It also implements a custom method, viewControllerAtIndex: which is useful in the implementation of the data source methods, and in the initial configuration of the application.
 
 There is no need to actually create view controllers for each page in advance -- indeed doing so incurs unnecessary overhead. Given the data model, these methods create, configure, and return a new view controller on demand.
 */

@interface MASTDModelController()
@property (nonatomic, strong) MASTDFlickr* flickr;
@property (nonatomic, strong) NSMutableArray* flickrImages;
@property (nonatomic, strong) NSMutableDictionary* pendingControllers;
@end

@implementation MASTDModelController

@synthesize flickr, flickrImages, pendingControllers;

- (id)init
{
    self = [super init];
    if (self)
    {
        // Create the data model.
        self.flickr = [MASTDFlickr new];
        self.flickr.delegate = self;
        
        self.flickrImages = [NSMutableArray new];
        self.pendingControllers = [NSMutableDictionary new];
    }
    return self;
}

- (MASTDDataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard
{   
    // Create a new view controller and pass suitable data.
    MASTDDataViewController *dataViewController = [storyboard instantiateViewControllerWithIdentifier:@"MASTDDataViewController"];
    
    // Return the data view controller for the given index.
    if (index < [self.flickrImages count])
    {
        id image = [self.flickrImages objectAtIndex:index];
        if ([[image class] isSubclassOfClass:[NSNull class]])
            image = nil;
        
        dataViewController.flickrImage = image;
    }
    else
    {
        [self.flickrImages addObject:[NSNull null]];
        
        NSNumber* key = [NSNumber numberWithUnsignedInteger:index];
        [self.pendingControllers setObject:dataViewController forKey:key];
        
        [self.flickr nextImage];
    }
    
    dataViewController.index = index;
    return dataViewController;
}

- (NSUInteger)indexOfViewController:(MASTDDataViewController *)viewController
{   
    NSUInteger index = viewController.index;
    return index;
    /*
    id image = viewController.flickrImage;
    if (image == nil)
        image = [NSNull null];
    
    NSUInteger index = [self.flickrImages indexOfObject:image];
    
    //NSLog(@"%@, %i", image.title, index);

    return index;
     */
}

#pragma mark -

- (void)flickr:(MASTDFlickr *)flickr error:(NSError *)error
{
    
}

- (void)flickr:(MASTDFlickr *)flickr nextImage:(MASTDFlickrImage *)image
{
    NSUInteger index = [self.flickrImages indexOfObject:[NSNull null]];
    if (index != NSNotFound)
        [self.flickrImages replaceObjectAtIndex:index withObject:image];
    
    NSNumber* key = [NSNumber numberWithUnsignedInteger:index];
    
    MASTDDataViewController* dataViewController = [self.pendingControllers objectForKey:key];
    
    [dataViewController setFlickrImage:image];
    
    [self.pendingControllers removeObjectForKey:key];
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    MASTDDataViewController* dataViewController = (MASTDDataViewController *)viewController;
    
    NSUInteger index = [self indexOfViewController:dataViewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    --index;
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    MASTDDataViewController* dataViewController = (MASTDDataViewController *)viewController;
    
    NSUInteger index = [self indexOfViewController:dataViewController];
    if (index == NSNotFound) {
        return nil;
    }
    
    ++index;
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

@end
