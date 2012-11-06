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
@property (nonatomic, strong) NSString* userAgent;
@end


@implementation MASTAdTracking

@synthesize connection, userAgent;

static NSString* UserAgentHeader = @"User-Agent";

- (void)dealloc
{
    self.connection = nil;
}

- (id)initWithURL:(NSURL*)url userAgent:(NSString*)ua
{
    self = [super init];
    if (self)
    {
        self.userAgent = ua;
        
        NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url
                                                                    cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                                timeoutInterval:kMASTAdTrackingTimeout];
        
        [request setValue:self.userAgent forHTTPHeaderField:UserAgentHeader];
        
        self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        if (self.connection == nil)
        {
            self.userAgent = nil;
            return nil;
        }
    }
    return self;
}

- (void)connection:(NSURLConnection *)conn didFailWithError:(NSError *)error
{
    if (conn == self.connection)
    {
        self.connection = nil;
    }
}

- (NSURLRequest *)connection:(NSURLConnection *)connection
             willSendRequest:(NSURLRequest *)request
            redirectResponse:(NSURLResponse *)redirectResponse
{
    NSMutableURLRequest* mutableRequest = [request mutableCopy];
    
    [mutableRequest setValue:self.userAgent forHTTPHeaderField:UserAgentHeader];
    
    return mutableRequest;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)conn
{
    if (conn == self.connection)
    {
        self.connection = nil;
    }
}

@end
