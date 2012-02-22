//
//  YXEditableCell.m
//  YXModelTableViews
//
//  Created by Roman Busyghin on 7/23/10.
//  Copyright 2010 Яндекс. All rights reserved.
//

#import "YXEditableCell.h"
#import "YXEditableViewCell.h"

@interface YXEditableCell ()
@property (nonatomic, strong) UITextField *textField;
- (void)_didEndEditing:(UITextField *)aTextField;
- (void)_didChangeEditing:(UITextField *)aTextField;
@end

@implementation YXEditableCell

@synthesize placeholder, title, value, handler, textField;
@synthesize image, editingAccessoryType, editHandler;
@synthesize secure, textFieldDelegate;

#pragma mark - NSObject

+ (id)secureCellWithTitle:(NSString *)title placeholder:(NSString *)placeholder {
    YXEditableCell *cell = [self cellWithTitle:title placeholder:placeholder];
    cell.secure = YES;
    return cell;
}

+ (id)secureCellWithTitle:(NSString *)title placeholder:(NSString *)placeholder onEdit:(YXSenderBlock)editHandler {
    YXEditableCell *cell = [self cellWithTitle:title placeholder:placeholder onEdit:editHandler];
    cell.secure = YES;
    return cell;
}

+ (id)secureCellWithTitle:(NSString *)title placeholder:(NSString *)placeholder value:(NSString *)value {
    YXEditableCell *cell = [self cellWithTitle:title placeholder:placeholder value:value];
    cell.secure = YES;
    return cell;
}

+ (id)secureCellWithTitle:(NSString *)title placeholder:(NSString *)placeholder value:(NSString *)value onEdit:(YXSenderBlock)editHandler onFinish:(YXSenderBlock)handler textFieldDelegate:(id <UITextFieldDelegate>)delegate {
    YXEditableCell *cell = [self cellWithTitle:title placeholder:placeholder value:value onEdit:editHandler onFinish:handler textFieldDelegate:delegate];
    cell.secure = YES;
    return cell;
}

+ (id)cellWithTitle:(NSString *)title placeholder:(NSString *)placeholder {
    return [self cellWithTitle:title placeholder:placeholder value:nil onEdit:NULL onFinish:NULL textFieldDelegate:nil];
}

+ (id)cellWithTitle:(NSString *)title placeholder:(NSString *)placeholder onEdit:(YXSenderBlock)editHandler {
    return [self cellWithTitle:title placeholder:placeholder value:nil onEdit:editHandler onFinish:NULL textFieldDelegate:nil];
}

+ (id)cellWithTitle:(NSString *)title placeholder:(NSString *)placeholder value:(NSString *)value {
    return [self cellWithTitle:title placeholder:placeholder value:value onEdit:NULL onFinish:NULL textFieldDelegate:nil];
}

+ (id)cellWithTitle:(NSString *)title placeholder:(NSString *)placeholder value:(NSString *)value onEdit:(YXSenderBlock)editHandler onFinish:(YXSenderBlock)handler textFieldDelegate:(id <UITextFieldDelegate>)delegate {
    YXEditableCell * cell = [YXEditableCell new];

    cell.title = title;
    cell.placeholder = placeholder;
    cell.value = value;
    cell.editHandler = editHandler;
    
    if (editHandler && !handler)
        cell.handler = editHandler;
    else
        cell.handler = handler;
    cell.textFieldDelegate = delegate;
    
    return cell;
}

#pragma mark - YXModelCell

- (UITableViewCell *)tableViewCellWithReusableCell:(UITableViewCell *)reusableCell {
	YXEditableViewCell * cell = (YXEditableViewCell *)reusableCell;

	if (!cell)
		cell = [[YXEditableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.reuseIdentifier];

    if (self.title) {
        cell.textLabel.text = self.title;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:17];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.textAlignment = UITextAlignmentLeft;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.imageView.image = self.image;
    
	cell.placeholder = self.placeholder;
    cell.textField.text = self.value;

    cell.textField.secureTextEntry = self.secure;
    cell.textField.returnKeyType = UIReturnKeyNext;
    
    [cell.textField addTarget:self action:@selector(_didChangeEditing:) forControlEvents:UIControlEventEditingChanged];
    [cell.textField addTarget:self action:@selector(_didEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
    
    cell.textField.delegate = self.textFieldDelegate;
    
    self.textField = cell.textField;
    
    cell.cell = self;

	return cell;
}

- (NSString *)reuseIdentifier {
    return @"YXEditableCell";
}

#pragma mark - Delegates

- (void)_didEndEditing:(UITextField *)aTextField {
    YXSenderBlock block = self.handler;
    if (block) block(self);
}

- (void)_didChangeEditing:(UITextField *)aTextField {
    YXSenderBlock block = self.editHandler;
    if (block) block(self);
}

#pragma mark - Properties

- (NSString *)value {
    if (textField)
        return textField.text;
    return value;
}

- (void)resignFirstResponder {
    [textField resignFirstResponder];
}

- (void)becomeFirstResponder {
    [textField becomeFirstResponder];
}

@end
