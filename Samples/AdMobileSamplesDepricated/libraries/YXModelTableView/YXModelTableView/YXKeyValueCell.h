//
//  YXKeyValueCell.h
//  YXModelTableViews
//
//  Created by Mikhail Kalugin on 6/29/10.
//  Copyright 2010 Yandex. All rights reserved.
//

#import "YXDisclosureCell.h"

@interface YXKeyValueCell : YXDisclosureCell <YXModelCellWithEditing>

@property (nonatomic, retain) id object;
@property (nonatomic, copy) NSString *key;

+ (id)cellWithTitle:(NSString *)title object:(id)object key:(NSString *)key;

@end
