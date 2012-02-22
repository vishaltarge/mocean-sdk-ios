//
//  YMSwitchCell.m
//  YXModelTableViews
//
//  Created by Mikhail Kalugin on 5/11/10.
//  Copyright 2010 Yandex. All rights reserved.
//

#import "YXSwitchCell.h"

@interface YXSwitchCell()
- (void)_switchControlChanged:(UISwitch *)switchControl;
@end

@implementation YXSwitchCell

@synthesize title, initialValueGetter, handler, togglesOnSelect;
@synthesize image, editingAccessoryType, editHandler;

#pragma mark - NSObject

+ (id)cellWithTitle:(NSString *)title initialValue:(YXBoolGetterBlock)getter handler:(YXBoolSenderBlock)handler {
    YXSwitchCell *cell = [YXSwitchCell new];
    
	cell.title = title;
	cell.initialValueGetter = getter;
	cell.handler = handler;
    cell.togglesOnSelect = YES;
    
	return cell;
}

+ (id)cellWithTitle:(NSString *)title value:(BOOL)initialValue handler:(YXBoolSenderBlock)handler {
    return [self cellWithTitle:title initialValue:^BOOL(id sender) {
        return initialValue;
    } handler:handler];
}

#pragma mark -
- (UITableViewCell *)tableViewCellWithReusableCell:(UITableViewCell *)reusableCell {
	UITableViewCell *cell = reusableCell;

	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.reuseIdentifier];
		cell.accessoryView = [UISwitch new];
	}
    
    UISwitch *switchControl = (UISwitch *)[cell accessoryView];
    [switchControl removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];

	cell.textLabel.text = self.title;
    cell.selectionStyle = (self.togglesOnSelect) ? UITableViewCellSelectionStyleBlue : UITableViewCellSelectionStyleNone;
    
    cell.imageView.image = self.image;
    
    YXBoolGetterBlock block = self.initialValueGetter;
    if (block)
        switchControl.on = block(self);
    else
        switchControl.on = NO;
    
	[switchControl addTarget:self action:@selector(_switchControlChanged:) forControlEvents:UIControlEventValueChanged];

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.togglesOnSelect) {
        UITableViewCell *theCell = [tableView cellForRowAtIndexPath:indexPath];
        UISwitch *theSwitch = (UISwitch *)theCell.accessoryView;
        BOOL set = !theSwitch.on;
        [theSwitch setOn:set animated:YES];
        [self performSelector:@selector(_switchControlChanged:) withObject:theSwitch];
	}
}

- (NSString *)reuseIdentifier {
    return @"YXSwitchCell";
}

#pragma mark - Private

- (void)_switchControlChanged:(UISwitch *)switchControl {
    YXBoolSenderBlock block = self.handler;
    if (block)
        block(self, switchControl.on);
}


@end
