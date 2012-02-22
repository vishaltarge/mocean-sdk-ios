//
//  YXKVOCheckmarkCell.h
//  YXModelTableViews
//
//  Created by Mikhail Kalugin on 6/30/10.
//  Copyright 2010 Yandex. All rights reserved.
//

#import "YXCheckmarkCell.h"

@interface YXKVCCheckmarkCell : YXCheckmarkCell

@property (nonatomic, copy) YXBlock updateAction;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, strong) id object;

+ (id)cellWithTitle:(NSString *)title object:(id)object key:(NSString *)key;

@end
