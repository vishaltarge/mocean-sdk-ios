//
//  MURLRequestCallback.m
//
//  Created by Constantine Mureev on 8/1/11.
//  Copyright 2011 Team Force LLC. All rights reserved.
//

#import "MURLRequestCallback.h"

@interface MOperationCallback ()
@property (readwrite, nonatomic, copy) id successBlock;
@property (readwrite, nonatomic, copy) id errorBlock;
@property (readwrite, nonatomic, copy) id startBlock;
@end

@implementation MOperationCallback
@synthesize successBlock = _successBlock;
@synthesize errorBlock = _errorBlock;
@synthesize startBlock = _startBlock;

+ (id)callbackWithSuccess:(id)success {
	return [self callbackWithSuccess:success error:nil];
}

+ (id)callbackWithSuccess:(id)success error:(id)error {
	id callback = [[[self alloc] init] autorelease];
	[callback setSuccessBlock:success];
	[callback setErrorBlock:error];
	
	return callback;
}

+ (id)callbackWithSuccess:(id)success error:(id)error start:(id)start {
	id callback = [[[self alloc] init] autorelease];
	[callback setSuccessBlock:success];
	[callback setErrorBlock:error];
    [callback setStartBlock:start];
	
	return callback;
}

- (id)init {
	if ([self class] == [MOperationCallback class]) {
		[NSException raise:NSInternalInconsistencyException format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
	}
	
	return [super init];
}

- (void)dealloc {
	[_successBlock release];
	[_errorBlock release];
    [_startBlock release];
	[super dealloc];
}

@end


#pragma mark - AFHTTPOperationCallback


@implementation MURLRequestCallback
@dynamic successBlock, errorBlock, startBlock;
@end
