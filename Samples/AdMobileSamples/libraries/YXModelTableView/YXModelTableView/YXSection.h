//
//  YXSection.h
//  YXModelTableViews
//
//  Created by Mikhail Kalugin on 5/11/10.
//  Copyright 2010 Yandex. All rights reserved.
//

#import "YXModelCell.h"

@interface YXSection : NSObject <NSFastEnumeration>

@property (nonatomic, copy) NSString *header;
@property (nonatomic, copy) NSString *footer;

@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) NSMutableArray *cells;

@property (nonatomic, readonly) id <YXModelCell> lastCell;
@property (nonatomic, readonly, getter=cellCount) NSInteger count;

+ (id)section;
+ (id)sectionWithHeader:(NSString *)header;
+ (id)sectionWithHeader:(NSString *)header footer:(NSString *)footer;

- (void)addCell:(id <YXModelCell>)cell;
- (void)removeCell:(id <YXModelCell>)cell;

- (id)cellAtIndex:(NSInteger)index;
- (NSInteger)indexOfCell:(id <YXModelCell>)cell;
- (void)removeAllCells;


@end
