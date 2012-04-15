//
//  YXEditableCell.h
//  YXModelTableViews
//
//  Created by Roman Busyghin on 7/23/10.
//  Copyright 2010 Яндекс. All rights reserved.
//

#import "YXModelCell.h"

@interface YXEditableCell : NSObject <YXModelCellWithEditing>

@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) YXSenderBlock handler;
@property (nonatomic, getter = isSecure) BOOL secure;
@property (nonatomic, assign) id <UITextFieldDelegate> textFieldDelegate;

+ (id)secureCellWithTitle:(NSString *)title placeholder:(NSString *)placeholder;
+ (id)secureCellWithTitle:(NSString *)title placeholder:(NSString *)placeholder onEdit:(YXSenderBlock)editHandler;
+ (id)secureCellWithTitle:(NSString *)title placeholder:(NSString *)placeholder value:(NSString *)value;
+ (id)secureCellWithTitle:(NSString *)title placeholder:(NSString *)placeholder value:(NSString *)value onEdit:(YXSenderBlock)editHandler onFinish:(YXSenderBlock)handler textFieldDelegate:(id <UITextFieldDelegate>)delegate;


+ (id)cellWithTitle:(NSString *)title placeholder:(NSString *)placeholder;
+ (id)cellWithTitle:(NSString *)title placeholder:(NSString *)placeholder onEdit:(YXSenderBlock)editHandler;
+ (id)cellWithTitle:(NSString *)title placeholder:(NSString *)placeholder value:(NSString *)value;
+ (id)cellWithTitle:(NSString *)title placeholder:(NSString *)placeholder value:(NSString *)value onEdit:(YXSenderBlock)editHandler onFinish:(YXSenderBlock)handler textFieldDelegate:(id <UITextFieldDelegate>)delegate;

- (void)resignFirstResponder;
- (void)becomeFirstResponder;

@end

@interface UITextField (YXEditableViewCell)

@property (nonatomic, readonly) YXEditableCell *cell;

@end