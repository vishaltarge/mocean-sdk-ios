//
//  MASTDFlickr.h
//  FlickrViewer
//
//  Copyright (c) 2012 mOcean Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YAJL/YAJL.h>
#import "MASTDFlickrImage.h"

@class MASTDFlickr;

@protocol MASTDFlickrDelegate <NSObject>
@optional

// Implement to receive errors.
- (void)flickr:(MASTDFlickr *)flickr error:(NSError*)error;

// Implement to receive the image requested by the flickr's nextImage request.
- (void)flickr:(MASTDFlickr*)flickr nextImage:(MASTDFlickrImage*)image;

@end


@interface MASTDFlickr : NSObject <YAJLParserDelegate>
{   

}

@property (nonatomic, weak) id<MASTDFlickrDelegate> delegate;

// Requests the next image available from the Flickr service.  If an image object
// is ready to go then synchronusly calls the delegates nextImage method, else will
// asyncronusly fetch the next image and call the delegate when available.
//
// Does nothing if the delegate is not set.
//
- (void)nextImage;

@end


