//
//  YXCustomizableCell.h
//  YXModelTableViews
//
//  Created by Mikhail Kalugin on 5/11/10.
//  Copyright 2010 Yandex. All rights reserved.
//

#import "YXModelCell.h"

typedef UITableViewCell *(^YXCustomizableBuildingBlock)(id <YXModelCell> cell, UITableViewCell *reusable);

@interface YXCustomizableCell : NSObject <YXModelCellWithEditing>

@property (nonatomic, copy) NSString *customReuseIdentifier;
@property (nonatomic, copy) YXSenderBlock selectionHandler;
@property (nonatomic, copy) YXCustomizableBuildingBlock buildingHandler;

+ (id)cellWithReuseIdentifier:(NSString *)reuseIdentifier buildingHandler:(YXCustomizableBuildingBlock)buildingHandler selectionHandler:(YXSenderBlock)selectionHandler;

@end
