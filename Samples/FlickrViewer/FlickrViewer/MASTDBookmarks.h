//
//  MASTDBookmarks.h
//  FlickrViewer
//
//  Copyright (c) 2012 mOcean Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MASTDFlickrImage.h"


@interface MASTDBookmarks : NSObject

+ (void)add:(MASTDFlickrImage*)flickrImage;
+ (void)remove:(MASTDFlickrImage*)flickrImage;
+ (BOOL)contains:(MASTDFlickrImage*)flickrImage;

+ (NSUInteger)count;
+ (MASTDFlickrImage*)bookmarkAtIndex:(NSUInteger)index;

@end


