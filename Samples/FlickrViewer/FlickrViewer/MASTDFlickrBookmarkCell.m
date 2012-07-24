//
//  MASTDFlickrBookmarkCell.m
//  FlickrViewer
//
//  Copyright (c) 2012 mOcean Mobile. All rights reserved.
//

#import "MASTDFlickrBookmarkCell.h"

@interface MASTDFlickrBookmarkCell ()
@property (nonatomic, strong) IBOutlet UILabel* titleLabel;
@property (nonatomic, strong) IBOutlet UILabel* linkLabel;
@property (nonatomic, strong) IBOutlet UIImageView* imageView;
@end

@implementation MASTDFlickrBookmarkCell

@synthesize titleLabel, linkLabel, imageView;

- (NSString*)title
{
    return [self.titleLabel text];
}

- (void)setTitle:(NSString *)t
{
    [self.titleLabel setText:t];
}

- (NSString*)link
{
    return [self.linkLabel text];
}

- (void)setLink:(NSString *)l
{
    [self.linkLabel setText:l];
}

- (UIImage*)image
{
    return [self.imageView image];
}

- (void)setImage:(UIImage *)i
{
    [self.imageView setImage:i];
}

@end
