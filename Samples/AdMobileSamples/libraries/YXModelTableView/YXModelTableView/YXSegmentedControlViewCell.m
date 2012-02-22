//
//  YXSegmentedControlCellView.m
//  YXModelTableViews
//
//  Created by Roman Busyghin on 7/20/10.
//  Copyright 2010 Яндекс. All rights reserved.
//

#import "YXSegmentedControlViewCell.h"

@interface YXSegmentedControlViewCell()
@property (nonatomic, strong, readwrite) UISegmentedControl *segmentedControl;
@end

@implementation YXSegmentedControlViewCell

@synthesize segmentedControl;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	return [self initWithSegmentedControlItems:nil reuseIdentifier:reuseIdentifier];
}

- (id)initWithSegmentedControlItems:(NSArray *)items reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
	if (self) {
        self.segmentedControl = [[UISegmentedControl alloc] initWithItems:items];
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		[self.contentView addSubview:self.segmentedControl];
    }
    return self;
}

- (void)prepareForReuse {
	[super prepareForReuse];

	[self.segmentedControl removeAllSegments];
	[self.segmentedControl removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
}

- (void)setItems:(NSArray *)items {
	id lastItem = [items lastObject];
    BOOL isImage;

	if ([lastItem isKindOfClass:[NSString class]])
		isImage = NO;
	else if ([lastItem isKindOfClass:[UIImage class]])
        isImage = YES;
	else
		return;
    
    for (id item in items) {
        NSUInteger i = [items indexOfObject:item];
        NSUInteger count = self.segmentedControl.numberOfSegments;
        if (i >= count) {
            NSUInteger pos = (count) ? count - 1 : 0;
            if (isImage)
                [self.segmentedControl insertSegmentWithImage:item atIndex:pos animated:NO];
            else
                [self.segmentedControl insertSegmentWithTitle:item atIndex:pos animated:NO];
        } else {
            if (isImage)
                [self.segmentedControl setImage:item forSegmentAtIndex:i];
            else
                [self.segmentedControl setTitle:item forSegmentAtIndex:i];
        }
    }

	[self setNeedsLayout];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	self.segmentedControl.frame = CGRectInset(self.contentView.bounds, -1.0f, -2.0f);
}

@end
