//
//  YXDisclosureCell.m
//  YXModelTableViews
//
//  Created by Mikhail Kalugin on 5/11/10.
//  Copyright 2010 Yandex. All rights reserved.
//

#import "YXDisclosureCell.h"

@interface YXDisclosureCell() {
    BOOL subtitle;
}
@end

@implementation YXDisclosureCell

@synthesize height, image, title, description, handler;

#pragma mark - NSObject

+ (id)cellWithTitle:(NSString *)title {
    return [self cellWithTitle:title description:nil handler:NULL];
}

+ (id)cellWithTitle:(NSString *)title description:(NSString *)description {
    return [self cellWithTitle:title description:description handler:NULL];
}

+ (id)cellWithTitle:(NSString *)title handler:(YXSenderBlock)handler {
    return [self cellWithTitle:title description:nil handler:handler];
}

+ (id)cellWithTitle:(NSString *)title description:(NSString *)description handler:(YXSenderBlock)handler {
	YXDisclosureCell *cell = [YXDisclosureCell new];
    
	cell.title = title;
	cell.description = description;
	cell.handler = handler;
    
	return cell;
}

+ (id)cellWithTitle:(NSString *)title subtitle:(NSString *)subtitle handler:(YXSenderBlock)handler {
    YXDisclosureCell *cell = [self cellWithTitle:title description:subtitle handler:handler];
    cell->subtitle = YES;
    return cell;
}

#pragma mark - YXModelCell

- (UITableViewCell *)tableViewCellWithReusableCell:(UITableViewCell *)reusableCell {
	UITableViewCellStyle style = self.description ? (subtitle ? UITableViewCellStyleSubtitle : UITableViewCellStyleValue1) : UITableViewCellStyleDefault;

	UITableViewCell *cell = reusableCell;
	if (!cell)
		cell = [[UITableViewCell alloc] initWithStyle:style reuseIdentifier:self.reuseIdentifier];

	cell.textLabel.text = self.title;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:17];
 	cell.textLabel.textAlignment = UITextAlignmentLeft;
	cell.textLabel.textColor = [UIColor blackColor];
    
	cell.detailTextLabel.text = self.description;
    
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.accessoryType = (self.handler) ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    cell.imageView.image = self.image;

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YXSenderBlock block = self.handler;
    if (block) block(self);
}

- (NSString *)reuseIdentifier {
    if (self.description && !subtitle)
        return @"YXDetailCell";
    else if (subtitle)
        return @"YXSubtitleCell";
    return nil;
}

@end