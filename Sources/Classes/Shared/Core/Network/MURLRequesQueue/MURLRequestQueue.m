//
//  MURLRequestQueue.m
//
//  Created by Constantine Mureev on 8/1/11.
//  Copyright 2011 Team Force LLC. All rights reserved.
//

#import "MURLRequestQueue.h"
#import "MURLRequestOperation.h"

@interface MURLRequestQueue ()
- (void)didReceiveMemoryWarning:(NSNotification*)notification;
- (void)load:(NSURLRequest*)request delegate:(id <MURLRequestDelegate>)delegate;
- (void)load:(NSURLRequest*)request block:(MURLRequestCallback*)block;

- (void)cancel:(NSURLRequest*)request;
- (void)cancelAllOperations;

@end

@implementation MURLRequestQueue

static MURLRequestQueue* sharedInstance = nil;



#pragma mark -
#pragma mark Singleton


- (id)init {
    self = [super init];
    if (self) {
        _queue = [NSOperationQueue new];
        [_queue setMaxConcurrentOperationCount:NSOperationQueueDefaultMaxConcurrentOperationCount];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReceiveMemoryWarning:)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object:nil];
    }
    
    return self;
}
+ (id)sharedInstance {
    if (nil == sharedInstance) {
        sharedInstance = [[self alloc] init];
	}
	return sharedInstance;
}

- (oneway void)superRelease {
	[super release];
}

+ (void)releaseSharedInstance {
	@synchronized(self) {
        [[NSNotificationCenter defaultCenter] removeObserver:sharedInstance];
		[sharedInstance superRelease];
		sharedInstance = nil;
	}
}

+ (id)allocWithZone:(NSZone*)zone {
	@synchronized(self) {
		if (nil == sharedInstance) {
			sharedInstance = [super allocWithZone:zone];
		}
	}
	
	return sharedInstance;
}

- (id)copyWithZone:(NSZone *)zone {
	return sharedInstance;
}

- (id)retain {
	return sharedInstance;
}

- (unsigned)retainCount {
	return NSUIntegerMax;
}

- (oneway void)release {
	// Do nothing.
}

- (id)autorelease {
	return sharedInstance;
}


#pragma mark - Public


+ (void)loadAsync:(NSURLRequest*)request {
    [[MURLRequestQueue sharedInstance] load:request delegate:nil];
}

+ (void)loadAsync:(NSURLRequest*)request delegate:(id <MURLRequestDelegate>)delegate {
    [[MURLRequestQueue sharedInstance] load:request delegate:delegate];
}

+ (void)loadAsync:(NSURLRequest*)request block:(MURLRequestCallback*)block {
    [[MURLRequestQueue sharedInstance] load:request block:block];
}

+ (void)cancelAsync:(NSURLRequest*)request {
    [[MURLRequestQueue sharedInstance] cancel:request];
}

+ (void)cancelAll {
    [[MURLRequestQueue sharedInstance] cancelAllOperations];
}


#pragma mark - Private


- (void)load:(NSURLRequest*)request delegate:(id <MURLRequestDelegate>)delegate {
    MURLRequestOperation* op = [MURLRequestOperation operationWithRequest:request callback:
                                [MURLRequestCallback callbackWithSuccess:
                                 ^(NSURLRequest *req, NSHTTPURLResponse *response, NSData *data) {
                                     if (delegate && [delegate respondsToSelector:@selector(requestDidFinishLoad:withResponse:data:)]) {
                                         [delegate requestDidFinishLoad:request withResponse:response data:data];
                                     }
                                 }
                                                                   error:
                                 ^(NSURLRequest *req, NSHTTPURLResponse *response, NSError *error) {
                                     if (delegate && [delegate respondsToSelector:@selector(requestdidFailLoad:withResponse:error:)]) {
                                         [delegate requestdidFailLoad:request withResponse:response error:error];
                                     }
                                 }
                                                                   start:
                                 ^(NSURLRequest *req) {
                                     if (delegate && [delegate respondsToSelector:@selector(requestDidStartLoad:)]) {
                                         [delegate requestDidStartLoad:request];
                                     }
                                 }
                                 ]];
    [_queue addOperation:op];
}

- (void)load:(NSURLRequest*)request block:(MURLRequestCallback*)block {
    MURLRequestOperation* op = [MURLRequestOperation operationWithRequest:request callback:block];
    [_queue addOperation:op];
}

- (void)cancel:(NSURLRequest*)request {
    NSArray* operations = [_queue operations];
    for (MURLRequestOperation* op in operations) {
        if ([[op.request.URL absoluteString] isEqualToString:[request.URL absoluteString]]) {
            [op cancel];
            break;
        }
    }
}

- (void)cancelAllOperations {
    [_queue cancelAllOperations];
}

- (void)didReceiveMemoryWarning:(NSNotification*)notification {
    
}

@end
