//
//  YXSegmentedControlCell.h
//  YXModelTableViews
//
//  Created by Roman Busyghin on 6/23/10.
//  Copyright 2010 Яндекс. All rights reserved.
//

#import "YXModelCell.h"

@interface YXSegmentedControlCell : NSObject <YXModelCell>

@property (nonatomic, copy) YXNumberSenderBlock handler;
@property (nonatomic, copy) YXNumberGetterBlock initialValueGetter;
@property (nonatomic, copy) NSArray *segmentedControlItems;

+ (id)cellWithItems:(NSArray *)items initialValue:(YXNumberGetterBlock)getter handler:(YXNumberSenderBlock)handler;
+ (id)cellWithItems:(NSArray *)items value:(NSUInteger)initialValue handler:(YXNumberSenderBlock)handler;

@end
