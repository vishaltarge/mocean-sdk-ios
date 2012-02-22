//
//  YXCheckmarkCellGroup.h
//  YXModelTableViews
//
//  Created by Mikhail Kalugin on 6/30/10.
//  Copyright 2010 Yandex. All rights reserved.
//

#import "YXCheckmarkCell.h"

typedef void(^YXCheckmarkBlock)(YXCheckmarkCell *selected, NSUInteger index);

@interface YXCheckmarkCellGroup : NSObject

@property (nonatomic, strong) YXCheckmarkCell *selectedCell;
@property (nonatomic) NSUInteger selectedIndex;
@property (nonatomic, copy, readonly) YXCheckmarkBlock handler;

+ (id)group;
+ (id)groupWithHandler:(YXCheckmarkBlock)handler;

- (void)addCell:(YXCheckmarkCell *)cell;
- (void)addCell:(YXCheckmarkCell *)cell setSelected:(BOOL)selected;
- (void)removeCell:(YXCheckmarkCell *)cell;

- (NSInteger)indexOfCell:(YXCheckmarkCell *)cell;

@end
