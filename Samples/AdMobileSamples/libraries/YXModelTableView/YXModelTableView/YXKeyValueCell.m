//
//  YXKeyValueCell.m
//  YXModelTableViews
//
//  Created by Mikhail Kalugin on 6/29/10.
//  Copyright 2010 Yandex. All rights reserved.
//

#import "YXKeyValueCell.h"

@implementation YXKeyValueCell

@synthesize title, object, key;
@synthesize image, editingAccessoryType, editHandler;

#pragma mark - NSObject

+ (id)cellWithTitle:(NSString*)title object:(id)object key:(NSString*)key {
	YXKeyValueCell *cell = [YXKeyValueCell new];
	cell.title = title;
	cell.object = object;
	cell.key = key;
	return cell;
}

#pragma mark - YXModelCell

- (UITableViewCell *)tableViewCellWithReusableCell:(UITableViewCell *)reusableCell {    
	UITableViewCell *cell = reusableCell;
	if (!cell)
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:self.reuseIdentifier];
    
	cell.textLabel.text = self.title;
	cell.detailTextLabel.text = [[self.object valueForKey:self.key] description];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = (self.handler) ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    cell.imageView.image = self.image;
    
	return cell;
}

- (NSString *)reuseIdentifier {
    return @"YXDetailCell";
}

@end
