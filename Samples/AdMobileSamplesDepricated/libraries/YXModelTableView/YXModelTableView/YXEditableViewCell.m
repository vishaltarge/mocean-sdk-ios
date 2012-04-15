//
//  YXEditableViewCell.m
//  YXModelTableViews
//
//  Created by Roman Busyghin on 7/23/10.
//  Copyright 2010 Яндекс. All rights reserved.
//

#import "YXEditableViewCell.h"
#import "YXEditableCell.h"

@interface YXEditableViewCell()
@property (nonatomic, strong, readwrite) UITextField *textField;
@end

@implementation YXEditableViewCell

static const CGFloat kTextFieldMargin = 10.0f;

@synthesize textField, cell;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        UITextField *field = [UITextField new];
		field.font = [UIFont systemFontOfSize:17.0f];
		field.textColor = [UIColor blackColor];
		field.textAlignment = UITextAlignmentLeft;
        field.autocorrectionType = UITextAutocorrectionTypeNo;
		field.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		[self addSubview:field];
        self.textField = field;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self.textField removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    self.cell.value = self.textField.text;
}

- (void)layoutSubviews {
	[super layoutSubviews];
        
    CGFloat left = self.contentView.bounds.origin.x + kTextFieldMargin;
    
    if (self.imageView.image)
        left += self.imageView.image.size.width + 5;
    
    if (!self.textLabel.text)
        left += 30;
    else {
        CGRect myRect = self.contentView.bounds;
        myRect.size.width = 100;
        myRect.size.height -= 1;
        myRect.origin.x = kTextFieldMargin;
        self.textLabel.frame = myRect;
        left += 120 + kTextFieldMargin + kTextFieldMargin + 5;
    }
    
    textField.frame = CGRectMake(left, 0, self.contentView.bounds.size.width - left, self.contentView.bounds.size.height);
}

- (void)setPlaceholder:(NSString *)newPlaceholder {
	textField.placeholder = newPlaceholder;
}

- (NSString *)placeholder {
	return textField.placeholder;
}

@end

@implementation UITextField (YXEditableViewCell)

- (YXEditableCell *)cell {
    if (![self.superview respondsToSelector:@selector(cell)])
        return nil;
    
    return [(id)self.superview cell];
}

@end
