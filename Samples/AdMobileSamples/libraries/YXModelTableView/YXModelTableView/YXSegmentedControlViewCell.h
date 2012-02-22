//
//  YXSegmentedControlCellView.h
//  YXModelTableViews
//
//  Created by Roman Busyghin on 7/20/10.
//  Copyright 2010 Яндекс. All rights reserved.
//

@interface YXSegmentedControlViewCell : UITableViewCell

@property (nonatomic, strong, readonly) UISegmentedControl *segmentedControl;

- (id)initWithSegmentedControlItems:(NSArray *)items reuseIdentifier:(NSString *)reuseIdentifier;
- (void)setItems:(NSArray *)items;

@end
