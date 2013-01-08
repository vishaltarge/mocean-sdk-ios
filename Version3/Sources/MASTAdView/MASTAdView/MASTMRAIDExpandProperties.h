//
//  MASTAdView
//
//  Created on 9/21/12.
//  Copyright (c) 2011, 2012 Mocean Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MASTMRAIDExpandProperties : NSObject

+ (MASTMRAIDExpandProperties*)propertiesFromArgs:(NSDictionary*)args;

- (id)init;
- (id)initWithSize:(CGSize)size;

@property (nonatomic, assign) NSInteger width;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, assign) BOOL useCustomClose;
@property (nonatomic, assign) BOOL isModal;

@end
