//
//  YXCheckmarkCellGroup.m
//  YXModelTableViews
//
//  Created by Mikhail Kalugin on 6/30/10.
//  Copyright 2010 Yandex. All rights reserved.
//

#import "YXCheckmarkCellGroup.h"

@interface YXCheckmarkCell()
@property (nonatomic, copy) YXValidationBlock willChangeHandler;
@end

@interface YXCheckmarkCellGroup ()
@property (nonatomic, strong) NSMutableArray *cells;
@property (nonatomic, copy, readwrite) YXCheckmarkBlock handler;
@end

@implementation YXCheckmarkCellGroup

@synthesize handler, selectedCell, cells;

#pragma mark - NSObject

+ (id)group {
    return [self new];
}

+ (id)groupWithHandler:(YXCheckmarkBlock)aHandler {
    YXCheckmarkCellGroup *instance = [self new];
    instance.handler = aHandler;
    return instance;
}

#pragma mark - YXCheckmarkCellGroup

- (void)addCell:(YXCheckmarkCell *)cell {
    [self addCell:cell setSelected:NO];
}

- (void)addCell:(YXCheckmarkCell *)cell setSelected:(BOOL)selected {
	NSAssert(cell, @"");
	
	[self.cells addObject:cell];
	
	if (selected)
		self.selectedCell = cell;
    
    cell.initialValueGetter = ^BOOL(YXCheckmarkCell *cell){
        return (cell == self.selectedCell);
    };
    
    cell.handler = ^(YXCheckmarkCell *cell, BOOL value){
        if (value)
            self.selectedCell = cell;
    };
    
    cell.willChangeHandler = ^BOOL(YXCheckmarkCell *cell, BOOL value){
        return (self.selectedCell != cell);
    };
}

- (void)removeCell:(YXCheckmarkCell*)cell {
	NSAssert(cell, @"");
	
    cell.handler = NULL;
    cell.initialValueGetter = NULL;
    
    if (self.selectedCell == cell)
        self.selectedCell = nil;
	
	[self.cells removeObject:cell];
}

- (NSInteger)indexOfCell:(YXCheckmarkCell *)cell {
    return [self.cells indexOfObject:cell];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    if (selectedIndex >= self.cells.count)
        return;
    
    YXCheckmarkCell *cell = [self.cells objectAtIndex:selectedIndex];
    self.selectedCell = cell;
}

- (NSUInteger)selectedIndex {
    return [self indexOfCell:self.selectedCell];
}

#pragma mark - Private

- (void)setSelectedCell:(YXCheckmarkCell *)newCell {
    YXCheckmarkCell *previousCell = self.selectedCell;
    
    selectedCell = newCell;
    
	if (previousCell)
		[previousCell update];
    
    YXCheckmarkBlock block = self.handler;
    block(newCell, [self indexOfCell:newCell]);
}

- (NSMutableArray *)cells {
    if (!cells)
        cells = [[NSMutableArray alloc] initWithCapacity:10];
    return cells;
}

@end
