//
//  MASTErrorResponse.h
//  MASTAdView
//
//  Created by Shrinivas Prabhu on 24/11/14.
//  Copyright (c) 2014 Mocean Mobile. All rights reserved.
//

#import "MASTResponse.h"

@interface MASTErrorResponse : MASTResponse

@property(nonatomic,strong) NSString *errorMessage;

@end
