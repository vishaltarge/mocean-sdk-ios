//
//  MASTDFlickrImage.h
//  FlickrViewer
//
//  Copyright (c) 2012 mOcean Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MASTDFlickrImage : NSObject
{
    

}

- (id)initWithDictionary:(NSDictionary*)flickrImageData;

@property (nonatomic, readonly) NSDictionary* data;

@property (nonatomic, readonly) NSString* title;
@property (nonatomic, readonly) NSString* link;
@property (nonatomic, readonly) NSString* media_m;
@property (nonatomic, readonly) NSDate* date_taken;
@property (nonatomic, readonly) NSString* desc;
@property (nonatomic, readonly) NSDate* published;
@property (nonatomic, readonly) NSString* author;
@property (nonatomic, readonly) NSString* author_id;
@property (nonatomic, readonly) NSString* tags;

@property (nonatomic, readonly) UIImage* image;

@end
