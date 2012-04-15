//
//  YXDisclosureCell.h
//  YXModelTableViews
//
//  Created by Mikhail Kalugin on 5/11/10.
//  Copyright 2010 Yandex. All rights reserved.
//

#import "YXModelCell.h"

@interface YXDisclosureCell : NSObject <YXModelCell>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) YXSenderBlock handler;

+ (id)cellWithTitle:(NSString *)title;
+ (id)cellWithTitle:(NSString *)title description:(NSString *)description;
+ (id)cellWithTitle:(NSString *)title handler:(YXSenderBlock)handler;
+ (id)cellWithTitle:(NSString *)title description:(NSString *)description handler:(YXSenderBlock)handler;
+ (id)cellWithTitle:(NSString *)title subtitle:(NSString *)subtitle handler:(YXSenderBlock)handler;

@end
