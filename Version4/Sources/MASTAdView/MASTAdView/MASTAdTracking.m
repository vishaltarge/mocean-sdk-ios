/*
 
 * PubMatic Inc. ("PubMatic") CONFIDENTIAL
 
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
//  MASTAdView
//
//  Created on 9/21/12.

//

#import "MASTAdTracking.h"
#import "MASTDefaults.h"
#import "MASTConstants.h"


@interface MASTAdTracking()
@property (nonatomic, strong) NSURLConnection* connection;
@property (nonatomic, strong) NSString* userAgent;
@end


@implementation MASTAdTracking

@synthesize connection, userAgent;

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
                                                                timeoutInterval:MAST_DEFAULT_NETWORK_TIMEOUT];
        
        [request setValue:self.userAgent forHTTPHeaderField:MASTUserAgentHeader];
        
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
    
    [mutableRequest setValue:self.userAgent forHTTPHeaderField:MASTUserAgentHeader];
    
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
