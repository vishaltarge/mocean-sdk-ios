//
//  YXCheckmarkCell.h
//  YXModelTableViews
//
//  Created by Roman Busyghin on 5/17/10.
//  Copyright 2010 Яндекс. All rights reserved.
//

#import "YXModelCell.h"

@class YXCheckmarkCellGroup;

@interface YXCheckmarkCell : NSObject <YXModelCell>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) YXBoolGetterBlock initialValueGetter;
@property (nonatomic, copy) YXBoolSenderBlock handler;

+ (id)cellWithTitle:(NSString *)title group:(YXCheckmarkCellGroup *)group;
+ (id)cellWithTitle:(NSString *)title group:(YXCheckmarkCellGroup *)group selected:(BOOL)selected;
+ (id)cellWithTitle:(NSString *)title initialValue:(YXBoolGetterBlock)getter handler:(YXBoolSenderBlock)handler;
+ (id)cellWithTitle:(NSString *)title value:(BOOL)initialValue handler:(YXBoolSenderBlock)handler;

- (void)update;

@end
