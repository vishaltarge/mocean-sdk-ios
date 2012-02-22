//
//  YXCheckmarkCell.m
//  YXModelTableViews
//
//  Created by Roman Busyghin on 5/17/10.
//  Copyright 2010 Яндекс. All rights reserved.
//

#import "YXCheckmarkCell.h"
#import "YXCheckmarkCellGroup.h"

@interface YXCheckmarkCell ()

- (UITableViewCellAccessoryType)_accessoryTypeForBool:(BOOL)flag;
- (BOOL)_boolForAccessoryType:(UITableViewCellAccessoryType)accessoryType;
- (BOOL)_allowsToChangeTo:(BOOL)newValue;

@property (nonatomic, strong) UITableViewCell *lastCreatedTableCell;
@property (nonatomic, copy) YXValidationBlock willChangeHandler;

@end

@implementation YXCheckmarkCell

@synthesize image, title, initialValueGetter, handler, willChangeHandler, lastCreatedTableCell;

#pragma mark - NSObject

+ (id)cellWithTitle:(NSString *)title group:(YXCheckmarkCellGroup *)group {
	return [self cellWithTitle:title group:group selected:NO];
}

+ (id)cellWithTitle:(NSString *)title group:(YXCheckmarkCellGroup *)group selected:(BOOL)selected {
	YXCheckmarkCell * cell = [YXCheckmarkCell new];
    
	cell.title = title;	
	[group addCell:cell setSelected:selected];
	
	return cell;
}

+ (id)cellWithTitle:(NSString *)title initialValue:(YXBoolGetterBlock)getter handler:(YXBoolSenderBlock)handler {
    YXCheckmarkCell *cell = [self new];
    
    cell.title = title;
    cell.initialValueGetter = getter;
    cell.handler = handler;
    
    return cell;
}

+ (id)cellWithTitle:(NSString *)title value:(BOOL)initialValue handler:(YXBoolSenderBlock)handler {
    return [self cellWithTitle:title initialValue:^BOOL(id sender) {
        return initialValue;
    } handler:handler];
}

#pragma mark - YXModelCell

- (UITableViewCell *)tableViewCellWithReusableCell:(UITableViewCell*)reusableCell {
	UITableViewCell *cell = reusableCell;
    
	if (!cell)
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.reuseIdentifier];
    lastCreatedTableCell = cell;
    
	cell.textLabel.text = title;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:17];
 	cell.textLabel.textAlignment = UITextAlignmentLeft;
	cell.textLabel.textColor = [UIColor blackColor];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    [self update];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	BOOL newValue = ![self _boolForAccessoryType:cell.accessoryType];
	
	if ([self _allowsToChangeTo:newValue]) {	
		cell.accessoryType = [self _accessoryTypeForBool:newValue];
        
        YXBoolSenderBlock block = handler;
        if (block)
            block(self, newValue);
	}
}

- (NSString *)reuseIdentifier {
    return @"YXCheckmarkCell";
}

- (void)update {
	if (!lastCreatedTableCell)
		return;
    
    BOOL selected = NO;
    YXBoolGetterBlock block = initialValueGetter;
    if (block)
        selected = block(self);
    
	lastCreatedTableCell.accessoryType = [self _accessoryTypeForBool:selected];
}

#pragma mark - Private

- (UITableViewCellAccessoryType)_accessoryTypeForBool:(BOOL)flag {
    return (flag) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
}

- (BOOL)_boolForAccessoryType:(UITableViewCellAccessoryType)accessoryType {
	return (accessoryType == UITableViewCellAccessoryCheckmark);
}

- (BOOL)_allowsToChangeTo:(BOOL)newValue {
    YXValidationBlock block = willChangeHandler;
    if (!block)
        return YES;
    
    return block(self, newValue);
}

@end
