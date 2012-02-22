//
//  YXCell.m
//  YXModelTableViews
//
//  Created by Mikhail Kalugin on 5/11/10.
//  Copyright 2010 Yandex. All rights reserved.
//

#import "YXCustomizableCell.h"

@implementation YXCustomizableCell

@synthesize customReuseIdentifier, buildingHandler, selectionHandler;
@synthesize editingAccessoryType, editHandler;
@synthesize image;

#pragma mark - NSObject

+ (id)cellWithReuseIdentifier:(NSString *)reuseIdentifier buildingHandler:(YXCustomizableBuildingBlock)buildingHandler selectionHandler:(YXSenderBlock)selectionHandler {
    YXCustomizableCell *cell = [YXCustomizableCell new];
    
    cell.customReuseIdentifier = reuseIdentifier;
    cell.buildingHandler = buildingHandler;
    cell.selectionHandler = selectionHandler;
    
    return cell;
}

#pragma mark - YXModelCell

- (UITableViewCell *)tableViewCellWithReusableCell:(UITableViewCell *)reusableCell {
    YXCustomizableBuildingBlock block = self.buildingHandler;
    if (block) return block(self, reusableCell);
	return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {    
    YXSenderBlock block = self.selectionHandler;
    if (block) block(self);
}

- (NSString *)reuseIdentifier {
    return self.customReuseIdentifier;
}

@end