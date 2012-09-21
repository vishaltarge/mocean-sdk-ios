//
//  MASTDFlickrImage.m
//  FlickrViewer
//
//  Copyright (c) 2012 mOcean Mobile. All rights reserved.
//

#import "MASTDFlickrImage.h"

@interface MASTDFlickrImage ()

@end

@implementation MASTDFlickrImage

@synthesize data;
@synthesize image;

static NSDateFormatter* dateTakenFormatter;
static NSDateFormatter* publishedFormatter;

- (void)dealloc
{
     [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithDictionary:(NSDictionary*)fid
{
    self = [super init];
    if (self)
    {
        if (dateTakenFormatter == nil)
        {
            NSLocale* enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
            
            dateTakenFormatter = [NSDateFormatter new];
            [dateTakenFormatter setLocale:enUSPOSIXLocale];
            [dateTakenFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ssZ"];
            
            publishedFormatter = [NSDateFormatter new];
            [publishedFormatter setLocale:enUSPOSIXLocale];
            [publishedFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"]; 
        }
        
        data = fid;
    }
    
    return self;
}

- (NSString*)title
{
    NSString* ret = [self.data objectForKey:@"title"];
    
    if ([ret length] == 0)
        ret = @"unknown";
    
    return ret;
}

- (NSString*)link
{
    NSString* link = [self.data objectForKey:@"link"];
    return link;
}

- (NSString*)media_m
{
    NSString* media_m = [[self.data objectForKey:@"media"] objectForKey:@"m"];
    return media_m;
}

- (NSDate*)date_taken
{
    NSDate* date_taken = nil;
    
    NSString* dateString = [self.data objectForKey:@"date_taken"];
    
    
    // NSDateFormatter is NOT fond of the ':' in the time zone
    dateString = [dateString stringByReplacingOccurrencesOfString:@":"
                                                       withString:@""
                                                          options:0
                                                            range:NSMakeRange(19, [dateString length] - 19)];
    
    if (dateString != nil)
        date_taken = [dateTakenFormatter dateFromString:dateString];
    
    return date_taken;
}

- (NSString*)desc
{
    NSString* desc = [self.data objectForKey:@"description"];
    return desc;
}

- (NSDate*)published
{
    NSDate* published = nil;
    
    NSString* dateString = [self.data objectForKey:@"published"];
    if (dateString != nil)
        published = [publishedFormatter dateFromString:dateString];
    
    return published;
}

- (NSString*)author
{
    static NSString* nobodyPrefix = @"nobody@flickr.com (";
    
    NSString* author = [self.data objectForKey:@"author"];
    
    if ([author hasPrefix:nobodyPrefix])
    {
        NSInteger length = [author length];
        NSRange trimmedRange = NSMakeRange(nobodyPrefix.length, length - nobodyPrefix.length - 1);
        NSString* trimmed = [author substringWithRange:trimmedRange];
        author = trimmed;
    }
    
    if ([author length] == 0)
        author = @"unknown";
    
    return author;
}

- (NSString*)author_id
{
    NSString* author_id = [self.data objectForKey:@"author_id"];
    return author_id;
}

- (NSString*)tags
{
    NSString* tags = [self.data objectForKey:@"tags"];
    return tags;
}

- (UIImage*)image
{
    if (image == nil)
    {
        NSURL* url = [NSURL URLWithString:self.media_m];
        NSData* imageData = [NSData dataWithContentsOfURL:url options:0 error:nil];
        image = [[UIImage alloc] initWithData:imageData];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(didReceiveMemoryWarning) 
                                                     name:UIApplicationDidReceiveMemoryWarningNotification 
                                                   object:nil];
    }
    
    return image;
}

- (void)didReceiveMemoryWarning
{
    image = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
