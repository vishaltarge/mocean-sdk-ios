//
//  MURLRequestQueue.h
//
//  Created by Constantine Mureev on 8/1/11.
//  Copyright 2011 Team Force LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MURLRequestCallback.h"

@protocol MURLRequestDelegate <NSObject>
@optional
- (void)requestDidStartLoad:(NSURLRequest*)request;
- (void)requestDidFinishLoad:(NSURLRequest*)request withResponse:(NSHTTPURLResponse*)response data:(NSData*)data ;
- (void)requestdidFailLoad:(NSURLRequest*)request withResponse:(NSHTTPURLResponse*)response error:(NSError*)error;
@end

@interface MURLRequestQueue : NSObject {
    NSOperationQueue*       _queue;
}

+ (MURLRequestQueue*)sharedInstance;

+ (void)loadAsync:(NSURLRequest*)request;
+ (void)loadAsync:(NSURLRequest*)request delegate:(id <MURLRequestDelegate>)delegate;
+ (void)loadAsync:(NSURLRequest*)request block:(MURLRequestCallback*)block;

+ (void)cancelAsync:(NSURLRequest*)request;
+ (void)cancelAll;

@end
