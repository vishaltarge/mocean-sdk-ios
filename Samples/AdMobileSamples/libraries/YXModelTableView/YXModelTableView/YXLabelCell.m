//
//  YXLabelCell.m
//  YXModelTableViews
//
//  Created by Zachary Waldowski on 4/22/11.
//  Copyright 2011 Dizzy Technology. All rights reserved.
//

#import "YXLabelCell.h"

@implementation YXLabelCell

@synthesize text, font, color, alignment;
@synthesize image, editingAccessoryType, editHandler;

#pragma mark - NSObject

+ (id)cellWithText:(NSString *)text {
	return [self cellWithText:text font:nil color:nil alignment:UITextAlignmentLeft];
}

+ (id)cellWithText:(NSString *)text font:(UIFont *)font color:(UIColor *)color alignment:(UITextAlignment)align {
	YXLabelCell * cell = [YXLabelCell new];

	cell.text = text;
    cell.font = (font) ? font : [UIFont boldSystemFontOfSize:17];
    cell.color = (color) ? color : [UIColor blackColor];
    cell.alignment = (align) ? align : UITextAlignmentLeft;
    
	return cell;
}

#pragma mark - YXModelCell

- (UITableViewCell *)tableViewCellWithReusableCell:(UITableViewCell *)reusableCell {
	UITableViewCell * cell = reusableCell;
    
	if (!cell)
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.reuseIdentifier];
    
	cell.textLabel.text = self.text;
    cell.textLabel.font = self.font;
    cell.textLabel.textColor = self.color;
    cell.textLabel.textAlignment = self.alignment;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.imageView.image = self.image;
    
	return cell;	
}

- (CGFloat)height {
    return [self.text sizeWithFont:self.font].height + 10.0f;
}

- (NSString *)reuseIdentifier {
    return @"YXLabelCell";
}

@end
