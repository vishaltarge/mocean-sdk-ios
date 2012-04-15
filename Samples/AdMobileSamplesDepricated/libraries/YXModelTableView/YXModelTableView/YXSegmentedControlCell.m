//
//  YXSegmentedControlCell.m
//  YXModelTableViews
//
//  Created by Roman Busyghin on 6/23/10.
//  Copyright 2010 Яндекс. All rights reserved.
//

#import "YXSegmentedControlCell.h"
#import "YXSegmentedControlViewCell.h"

@interface YXSegmentedControlCell()
- (void)_segmentedControlDidChangeValue:(UISegmentedControl *)segmentedControl;
@end

@implementation YXSegmentedControlCell

@synthesize image, segmentedControlItems, handler, initialValueGetter;

#pragma mark - Object lifecycle

+ (id)cellWithItems:(NSArray *)items initialValue:(YXNumberGetterBlock)getter handler:(YXNumberSenderBlock)handler {
    YXSegmentedControlCell *cell = [YXSegmentedControlCell new];
    
	cell.segmentedControlItems = items;
	cell.handler = handler;
	cell.initialValueGetter = getter;
    
	return cell;
}

+ (id)cellWithItems:(NSArray *)items value:(NSUInteger)initialValue handler:(YXNumberSenderBlock)handler {
    return [self cellWithItems:items initialValue:^NSUInteger(id sender) {
        return initialValue;
    } handler:handler];
}

#pragma mark - YXModelCell

- (UITableViewCell *)tableViewCellWithReusableCell:(UITableViewCell *)reusableCell {
	YXSegmentedControlViewCell *cell = (YXSegmentedControlViewCell *)reusableCell;

	if (!cell)
        cell = [[YXSegmentedControlViewCell alloc] initWithSegmentedControlItems:segmentedControlItems reuseIdentifier:self.reuseIdentifier];
    else
		[cell setItems:segmentedControlItems];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;

    [cell.segmentedControl addTarget:self action:@selector(_segmentedControlDidChangeValue:) forControlEvents:UIControlEventValueChanged];
    
    YXNumberGetterBlock block = initialValueGetter;
    if (block)
        cell.segmentedControl.selectedSegmentIndex = block(self);
    
	return cell;
}

- (NSString *)reuseIdentifier {
    return @"YXSegmentedControlCell";
}

#pragma mark - Private

- (void)_segmentedControlDidChangeValue:(UISegmentedControl *)segmentedControl {
    YXNumberSenderBlock block = self.handler;
    if (block)
        block(self, segmentedControl.selectedSegmentIndex);
}

@end
