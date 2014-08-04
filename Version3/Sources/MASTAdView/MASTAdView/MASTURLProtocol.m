//
//  MASTURLProtocol.m
//  MASTAdView
//
/*
 * PubMatic Inc. (“PubMatic”) CONFIDENTIAL
 * Unpublished Copyright (c) 2006-2014 PubMatic, All Rights Reserved.
 *
 * NOTICE:  All information contained herein is, and remains the property of PubMatic. The intellectual and technical concepts contained
 * herein are proprietary to PubMatic and may be covered by U.S. and Foreign Patents, patents in process, and are protected by trade secret or copyright law.
 * Dissemination of this information or reproduction of this material is strictly forbidden unless prior written permission is obtained
 * from PubMatic.  Access to the source code contained herein is hereby forbidden to anyone except current PubMatic employees, managers or contractors who have executed
 * Confidentiality and Non-disclosure agreements explicitly covering such access.
 *
 * The copyright notice above does not evidence any actual or intended publication or disclosure  of  this source code, which includes
 * information that is confidential and/or proprietary, and is a trade secret, of  PubMatic.   ANY REPRODUCTION, MODIFICATION, DISTRIBUTION, PUBLIC  PERFORMANCE,
 * OR PUBLIC DISPLAY OF OR THROUGH USE  OF THIS  SOURCE CODE  WITHOUT  THE EXPRESS WRITTEN CONSENT OF PubMatic IS STRICTLY PROHIBITED, AND IN VIOLATION OF APPLICABLE
 * LAWS AND INTERNATIONAL TREATIES.  THE RECEIPT OR POSSESSION OF  THIS SOURCE CODE AND/OR RELATED INFORMATION DOES NOT CONVEY OR IMPLY ANY RIGHTS
 * TO REPRODUCE, DISCLOSE OR DISTRIBUTE ITS CONTENTS, OR TO MANUFACTURE, USE, OR SELL ANYTHING THAT IT  MAY DESCRIBE, IN WHOLE OR IN PART.
 */
//

#import "MASTURLProtocol.h"
#import "MASTMRAIDControllerJS.h"

@implementation MASTURLProtocol

static NSData* mraidScriptData = nil;

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    NSURL* url = [request URL];
    NSString* scheme = [url scheme];
    
    if ([scheme isEqualToString:@"applewebdata"] || [scheme hasPrefix:@"http"])
    {
        if ([[url absoluteString] hasSuffix:@"mraid.js"])
        {
            return YES;
        }
    }
    
    return NO;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    return request;
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b
{
    return NO;
}

- (id)initWithRequest:(NSURLRequest *)request cachedResponse:(NSCachedURLResponse *)cachedResponse client:(id<NSURLProtocolClient>)client
{
    self = [super initWithRequest:request cachedResponse:cachedResponse client:client];
    if (self)
    {
        
    }
    return self;
}

- (void)startLoading
{
    if (mraidScriptData == nil)
    {
        mraidScriptData = [NSData dataWithBytesNoCopy:MASTMRAIDController_js
                                               length:MASTMRAIDController_js_len
                                         freeWhenDone:NO];
    }
    
    NSURLResponse* response = [[NSURLResponse alloc] initWithURL:[[self request] URL]
                                                        MIMEType:@"application/javascript"
                                           expectedContentLength:[mraidScriptData length]
                                                textEncodingName:@"UTF-8"];
    
    id<NSURLProtocolClient> client = [self client];
    
    [client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    [client URLProtocol:self didLoadData:mraidScriptData];
    [client URLProtocolDidFinishLoading:self];
}

- (void)stopLoading
{
    
}

@end
