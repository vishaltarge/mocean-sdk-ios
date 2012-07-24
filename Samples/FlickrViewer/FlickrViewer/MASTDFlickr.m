//
//  MASTDFlickr.m
//  FlickrViewer
//
//  Copyright (c) 2012 mOcean Mobile. All rights reserved.
//

#import "MASTDFlickr.h"
#import "MASTDFlickrImage.h"


@interface MASTDFlickr()
// Flickr connection
@property (nonatomic, strong) NSURLConnection* urlConnection;

// Parser generic
@property (nonatomic, strong) YAJLParser* parser;
@property (nonatomic, assign) YAJLParserStatus parserStatus;
@property (nonatomic, strong) NSString* parserKey;
@property (nonatomic, strong) NSString* parserValue;

// Parsing status
@property (nonatomic, assign) BOOL parsingItems;
@property (nonatomic, strong) NSMutableDictionary* parsingCurrentItem;
@property (nonatomic, strong) NSMutableDictionary* parsingCurrentItemMedia;

// Resulting image collection
@property (nonatomic, strong) NSMutableArray* images;

// Index in the collection for the current image requested
@property (nonatomic, assign) NSInteger imageIndex;

@property (nonatomic, assign) NSUInteger queuedNext;

@end

@implementation MASTDFlickr

@synthesize delegate;
@synthesize urlConnection;
@synthesize parser, parserStatus, parserKey, parserValue, parsingItems, parsingCurrentItem, parsingCurrentItemMedia;
@synthesize images, imageIndex;
@synthesize queuedNext;

- (BOOL)pushNextImage
{
    @synchronized(self)
    {
        ++queuedNext;
        
        while (queuedNext > 0)
        {
            if ((self.images != nil) && (imageIndex + 1 < [self.images count]))
            {
                --queuedNext;
                
                ++imageIndex;
                MASTDFlickrImage* image = [self.images objectAtIndex:imageIndex];
                
                if ([self.delegate respondsToSelector:@selector(flickr:nextImage:)])
                    [self.delegate flickr:self nextImage:image];
                
                continue;
            }
            
            break;
        }
        
        if (queuedNext == 0)
            return YES;
        
        return NO;
    }
}

- (void)nextImage
{
    if ([self pushNextImage])
        return;
    
    if (self.urlConnection != nil)
        return;
    
    imageIndex = -1;
    
    NSString* flickrURLSetting = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"FlickrURL"];
    NSURL* flickrURL = [NSURL URLWithString:flickrURLSetting];
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:flickrURL];
    
    self.urlConnection = [NSURLConnection connectionWithRequest:request delegate:self];
}

#pragma mark -

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.urlConnection = nil;
    
    [self.parser setDelegate:nil];
    self.parser = nil;
    
    if ([self.delegate respondsToSelector:@selector(flickr:error:)])
    {
        [self.delegate flickr:self error:error];
    }
}

- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response
{
    if (![[response class] isSubclassOfClass:[NSHTTPURLResponse class]])
    {
        // Asked for HTTP got something else.
        
        [connection cancel];
        self.urlConnection = nil;
        
        if ([self.delegate respondsToSelector:@selector(flickr:error:)])
        {
            NSError* error = [[NSError alloc] initWithDomain:@"Unexpected response from Flickr; not HTTP" 
                                                        code:0 
                                                    userInfo:nil];
            
            [self.delegate flickr:self error:error];
        }
        
        return;
    }
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    if (httpResponse.statusCode != 200)
    {
        // Only expect 200 and no reason to fish for details in the response body for any other result.
        
        [connection cancel];
        self.urlConnection = nil;
        
        if ([self.delegate respondsToSelector:@selector(flickr:error:)])
        {
            NSError* error = [[NSError alloc] initWithDomain:@"Unexpected response from Flickr, not OK" 
                                                        code:0 
                                                    userInfo:nil];
            
            [self.delegate flickr:self error:error];
        }
        
        return;
    }
}

- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData *)data
{
    if (self.parser == nil)
    {
        // Flickr wraps the JSON so find the starting { of the stream.
        // If not found, wait till the next chunk.
        NSData* openParen = [@"{" dataUsingEncoding:NSUTF8StringEncoding];
        NSRange range = [data rangeOfData:openParen options:0 range:NSMakeRange(0, [data length])];
        
        // If the { isn't found yet then ignore the entire chunk and wait for the next.
        if (range.location == NSNotFound)
            return;
        
        range.length = [data length] - range.location;
        data = [data subdataWithRange:range];
        
        // Reset the image cache
        self.images = [NSMutableArray new];
        
        // Setup the parser
        self.parser = [[YAJLParser alloc] initWithParserOptions:YAJLParserOptionsAllowComments];
        self.parser.delegate = self;
    }
    
    // Parse the chunk
    self.parserStatus = [self.parser parse:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    self.urlConnection = nil;
    
    [self.parser setDelegate:nil];
    self.parser = nil;
    
    [self pushNextImage];
}

#pragma mark -

- (void)parserDidStartDictionary:(YAJLParser *)parser 
{
    // Based on the format of the stream, the parser should be
    // looking for the items key, a new item or a new media item.
    
    if (!parsingItems)
        return;
    
    if (self.parsingCurrentItem == nil)
    {
        self.parsingCurrentItem = [NSMutableDictionary new];
        return;
    }
    
    if ([@"media" isEqualToString:self.parserKey] && (self.parsingCurrentItemMedia == nil))
    {
        self.parsingCurrentItemMedia = [NSMutableDictionary new];
        return;
    }
}

- (void)parserDidEndDictionary:(YAJLParser *)parser 
{
    if (self.parsingCurrentItemMedia != nil)
    {
        [self.parsingCurrentItem setObject:self.parsingCurrentItemMedia forKey:@"media"];
        self.parsingCurrentItemMedia = nil;
        return;
    }
    
    if (self.parsingCurrentItem != nil)
    {
        MASTDFlickrImage* image = [[MASTDFlickrImage alloc] initWithDictionary:self.parsingCurrentItem];
        [self.images addObject:image];
        self.parsingCurrentItem = nil;
        return;
    }
}

- (void)parserDidStartArray:(YAJLParser *)parser 
{
    if (parsingItems)
        return;
    
    if ([@"items" isEqualToString:self.parserKey])
        parsingItems = YES;
}

- (void)parserDidEndArray:(YAJLParser *)parser 
{ 
    if (parsingItems)
        parsingItems = NO;
}

- (void)parser:(YAJLParser *)parser didMapKey:(NSString *)key 
{ 
    self.parserKey = key;
}

- (void)parser:(YAJLParser *)parser didAdd:(id)value 
{
    if ((value != nil) && (self.parserKey != nil) && (self.parsingCurrentItem != nil))
    {
        if (self.parsingCurrentItemMedia != nil)
        {
            [self.parsingCurrentItemMedia setObject:value forKey:self.parserKey];
        }
        else
        {
            [self.parsingCurrentItem setObject:value forKey:self.parserKey];
        }
    }
}

@end
