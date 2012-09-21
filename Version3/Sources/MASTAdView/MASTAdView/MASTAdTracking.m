//
//  MASTAdView
//
//  Created on 9/21/12.
//  Copyright (c) 2011, 2012 Mocean Mobile. All rights reserved.
//

#import "MASTAdTracking.h"


#define kMASTAdTrackingTimeout 5


@interface MASTAdTracking()
@property (nonatomic, strong) NSURLConnection* connection;
@end


@implementation MASTAdTracking

@synthesize connection;

- (void)dealloc
{
    self.connection = nil;
}

- (id)initWithURL:(NSURL*)url
{
    self = [super init];
    if (self)
    {
        NSURLRequest* request = [[NSURLRequest alloc] initWithURL:url
                                                      cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                  timeoutInterval:kMASTAdTrackingTimeout];
        
        // TODO: Add user agent header.
        // TODO: Add to redmine
        
        self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
    return self;
}

- (NSURLRequest *)connection:(NSURLConnection *)connection
             willSendRequest:(NSURLRequest *)request
            redirectResponse:(NSURLResponse *)redirectResponse
{
    return request;
}

@end
