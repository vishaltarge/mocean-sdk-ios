//
//  YXSwitchCell.h
//  YXModelTableViews
//
//  Created by Mikhail Kalugin on 5/11/10.
//  Copyright 2010 Yandex. All rights reserved.
//

#import "YXModelCell.h"

@interface YXSwitchCell : NSObject <YXModelCellWithEditing>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) YXBoolGetterBlock initialValueGetter;
@property (nonatomic, copy) YXBoolSenderBlock handler;
@property (nonatomic) BOOL togglesOnSelect;

+ (id)cellWithTitle:(NSString *)title initialValue:(YXBoolGetterBlock)getter handler:(YXBoolSenderBlock)handler;
+ (id)cellWithTitle:(NSString *)title value:(BOOL)initialValue handler:(YXBoolSenderBlock)handler;

@end
