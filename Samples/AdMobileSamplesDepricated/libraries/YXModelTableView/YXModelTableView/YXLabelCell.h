//
//  YXLabelCell.h
//  YXModelTableViews
//
//  Created by Zachary Waldowski on 4/22/11.
//  Copyright 2011 Dizzy Technology. All rights reserved.
//

#import "YXModelCell.h"

@interface YXLabelCell : NSObject <YXModelCellWithEditing>

@property (nonatomic, copy) NSString *text;
@property (nonatomic, retain) UIFont *font;
@property (nonatomic, retain) UIColor *color;
@property (nonatomic) UITextAlignment alignment;

+ (id)cellWithText:(NSString *)text;
+ (id)cellWithText:(NSString *)text font:(UIFont *)font color:(UIColor *)color alignment:(UITextAlignment)align;

@end
