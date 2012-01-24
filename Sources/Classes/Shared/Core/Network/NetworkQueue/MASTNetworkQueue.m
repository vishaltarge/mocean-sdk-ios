//
//  NetworkQueue.m
//
//  Created by Constantine on 10/5/11.
//

#import "NetworkQueue.h"
#import "RequestOperation.h"
#import "NetworkActivityIndicatorManager.h"

@implementation NetworkQueue

static NSOperationQueue* get_network_operations_io_queue() {
    static NSOperationQueue* _networkIOQueue;
    static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_networkIOQueue = [NSOperationQueue new];
        [NetworkActivityIndicatorManager sharedManager];
	});
	return _networkIOQueue;
}

+ (void)loadWithRequest:(NSURLRequest *)urlRequest 
             completion:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSData *data, NSError *error))completion {
    if (![NSThread isMainThread]) {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[urlRequest URL]];
        [(NSMutableDictionary*)[request allHTTPHeaderFields] removeObjectForKey:@"Keep-Alive"];
        
        urlRequest = (NSURLRequest*)[request retain];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            RequestOperation* operation = [RequestOperation operationWithRequest:urlRequest completion:completion];
            [get_network_operations_io_queue() addOperation:operation];
        });
    } else {
        RequestOperation* operation = [RequestOperation operationWithRequest:urlRequest completion:completion];
        [get_network_operations_io_queue() addOperation:operation];
    }
}

+ (void)cancelAll {
    [get_network_operations_io_queue() cancelAllOperations];
}

@end
