//
//  MASTDBookmarks.m
//  FlickrViewer
//
//  Copyright (c) 2012 mOcean Mobile. All rights reserved.
//

#import "MASTDBookmarks.h"
#import "MASTDFlickrImage.h"

static NSString* BOOKMARKS_FILE_NAME = @"bookmarks.plist";
static NSMutableArray* bookmarkData = nil;


@implementation MASTDBookmarks

+ (NSString*)bookmarkFile
{
    NSString* path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString* file = [path stringByAppendingPathComponent:BOOKMARKS_FILE_NAME];
    
    return file;
}

+ (void)loadBookmarkData
{
    if (bookmarkData != nil)
        return;
    
    NSString* file = [self bookmarkFile];
    
    bookmarkData = [[NSMutableArray alloc] initWithContentsOfFile:file];
    
    if (bookmarkData == nil)
        bookmarkData = [NSMutableArray new];
}

+ (void)saveBookmarkData
{
    if (bookmarkData == nil)
        return;
    
    NSString* file = [self bookmarkFile];
    
    [bookmarkData writeToFile:file atomically:YES];
}

+ (NSInteger)indexOfFlickrImage:(MASTDFlickrImage*)flickrImage
{
    for (NSInteger i = 0, c = [bookmarkData count]; i < c; ++i)
    {
        NSDictionary* data = [bookmarkData objectAtIndex:i];
        
        if ([[data valueForKey:@"link"] isEqualToString:[flickrImage link]])
            return i;
    }
    
    return NSNotFound;
}

+ (void)add:(MASTDFlickrImage*)flickrImage
{
    [self loadBookmarkData];
    
    [bookmarkData addObject:flickrImage.data];
    [self saveBookmarkData];
}

+ (void)remove:(MASTDFlickrImage*)flickrImage
{
    [self loadBookmarkData];
    
    NSInteger index = [self indexOfFlickrImage:flickrImage];
    if (index != NSNotFound)
    {
        [bookmarkData removeObjectAtIndex:index];
        [self saveBookmarkData];
    }        
}

+ (BOOL)contains:(MASTDFlickrImage*)flickrImage
{
    [self loadBookmarkData];
    
    NSInteger index = [self indexOfFlickrImage:flickrImage];
    if (index != NSNotFound)
        return YES;
    
    return NO;
}

+ (NSUInteger)count
{
    [self loadBookmarkData];
    
    NSUInteger count = [bookmarkData count];
    return count;
}

+ (MASTDFlickrImage*)bookmarkAtIndex:(NSUInteger)index
{
    [self loadBookmarkData];
    
    NSDictionary* data = [bookmarkData objectAtIndex:index];
    MASTDFlickrImage* flickrImage = [[MASTDFlickrImage alloc] initWithDictionary:data];
    return flickrImage;    
}

@end
