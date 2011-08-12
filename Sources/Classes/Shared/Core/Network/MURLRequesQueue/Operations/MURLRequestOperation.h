//
//  MURLRequestOperation.h
//
//  Created by Constantine Mureev on 8/1/11.
//  Copyright 2011 Team Force LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QHTTPOperation.h"
#import "MURLRequestCallback.h"

extern NSString* const MURLRequestDidStartNotification;
extern NSString* const MURLRequestDidFinishNotification;
extern NSString* const MURLRequestDidFailNotification;

@class MURLRequestCallback;

@interface MURLRequestOperation : QHTTPOperation {
@private
	MURLRequestCallback *_callback;
}

@property (nonatomic, retain) MURLRequestCallback *callback;
@property (readonly) NSString *responseString;

+ (id)operationWithRequest:(NSURLRequest *)urlRequest callback:(MURLRequestCallback *)callback;
- (id)initWithRequest:(NSURLRequest *)urlRequest callback:(MURLRequestCallback *)callback;

@end
