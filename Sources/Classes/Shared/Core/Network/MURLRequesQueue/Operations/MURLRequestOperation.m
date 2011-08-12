//
//  MURLRequestOperation.m
//
//  Created by Constantine Mureev on 8/1/11.
//  Copyright 2011 Team Force LLC. All rights reserved.
//

#import "MURLRequestOperation.h"

NSString* const MURLRequestDidStartNotification = @"http-operation.start";
NSString* const MURLRequestDidFinishNotification = @"http-operation.success";
NSString* const MURLRequestDidFailNotification = @"http-operation.failure";

@implementation MURLRequestOperation

@synthesize callback = _callback;

+ (id)operationWithRequest:(NSURLRequest *)urlRequest callback:(MURLRequestCallback *)callback {
    return [[[self alloc] initWithRequest:urlRequest callback:callback] autorelease];
}

- (id)initWithRequest:(NSURLRequest *)urlRequest callback:(MURLRequestCallback *)callback {
    self = [super initWithRequest:urlRequest];
    if (!self) {
		return nil;
    }
	
    self.acceptableStatusCodes = [NSIndexSet indexSetWithIndex:200];
	//self.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", nil];
	self.callback = callback;	
	
    return self;
}

- (void)dealloc {
	[_callback release];
	[super dealloc];
}

- (NSString *)responseString {
    return [[[NSString alloc] initWithData:self.responseBody encoding:NSUTF8StringEncoding] autorelease];
}

#pragma mark - QRunLoopOperation

- (void)operationDidStart {
	[super operationDidStart];
	[[NSNotificationCenter defaultCenter] postNotificationName:MURLRequestDidStartNotification object:self];
    
    if (self.callback.startBlock) {
        self.callback.startBlock(self.lastRequest);
    }
}

- (void)finishWithError:(NSError *)error {
	[super finishWithError:error];
    
    if (!error && self.statusCodeAcceptable && self.contentTypeAcceptable) {
        [[NSNotificationCenter defaultCenter] postNotificationName:MURLRequestDidFinishNotification object:self];
        
        if (self.callback.successBlock) {
            self.callback.successBlock(self.lastRequest, self.lastResponse, self.responseBody);
        }
    } else if (error) {
        if ([error code] != NSUserCancelledError) {
            [[NSNotificationCenter defaultCenter] postNotificationName:MURLRequestDidFailNotification object:self];
            
            if (self.callback.errorBlock) {
                self.callback.errorBlock(self.lastRequest, self.lastResponse, error);
            }
        }
    } else {
        error = [NSError errorWithDomain:@"unknown error" code:666 userInfo:nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MURLRequestDidFailNotification object:self];
        
        if (self.callback.errorBlock) {
            self.callback.errorBlock(self.lastRequest, self.lastResponse, error);
        }
    }
}

@end
