//
//  MURLRequestCallback.h
//
//  Created by Constantine Mureev on 8/1/11.
//  Copyright 2011 Team Force LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MOperationCallback <NSObject>
+ (id)callbackWithSuccess:(id)success;
+ (id)callbackWithSuccess:(id)success error:(id)error;
+ (id)callbackWithSuccess:(id)success error:(id)error start:(id)start;
@end

@interface MOperationCallback : NSObject <MOperationCallback> {
@private
	id _successBlock;
	id _errorBlock;
	id _startBlock;
}

@end

typedef void (^MURLRequestSuccessBlock)(NSURLRequest *request, NSHTTPURLResponse *response, NSData *data);
typedef void (^MURLRequestErrorBlock)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error);
typedef void (^MURLRequestStartBlock)(NSURLRequest *request);

#pragma mark - MURLRequestCallback

@protocol MURLRequestCallback <NSObject>
@optional
+ (id)callbackWithSuccess:(MURLRequestSuccessBlock)success;
+ (id)callbackWithSuccess:(MURLRequestSuccessBlock)success error:(MURLRequestErrorBlock)error;
+ (id)callbackWithSuccess:(MURLRequestSuccessBlock)success error:(MURLRequestErrorBlock)error start:(MURLRequestStartBlock)start;
@end

@interface MURLRequestCallback : MOperationCallback <MURLRequestCallback>
@property (readwrite, nonatomic, copy) MURLRequestSuccessBlock successBlock;
@property (readwrite, nonatomic, copy) MURLRequestErrorBlock errorBlock;
@property (readwrite, nonatomic, copy) MURLRequestStartBlock startBlock;
@end
