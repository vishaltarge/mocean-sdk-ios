//
//  YXButtonCell.h
//  YXModelTableViews
//
//  Created by Mikhail Kalugin on 5/11/10.
//  Copyright 2010 Yandex. All rights reserved.
//

#import "YXModelCell.h"

@interface YXButtonCell : NSObject <YXModelCellWithEditing>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) YXBlock handler;

+ (id)cellWithTitle:(NSString *)title handler:(YXBlock)handler;

@end
