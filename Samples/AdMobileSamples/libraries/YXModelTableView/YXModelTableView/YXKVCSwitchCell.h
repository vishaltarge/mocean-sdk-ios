//
//  YXKVOSwitchCell.h
//  YXModelTableViews
//
//  Created by Mikhail Kalugin on 5/11/10.
//  Copyright 2010 Yandex. All rights reserved.
//

#import "YXSwitchCell.h"

@interface YXKVCSwitchCell : YXSwitchCell

@property (nonatomic, strong) id object;
@property (nonatomic, copy) NSString *key;

+ (id)cellWithTitle:(NSString *)title object:(id)object key:(NSString *)key;

@end
