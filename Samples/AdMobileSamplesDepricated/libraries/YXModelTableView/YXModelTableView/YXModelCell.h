//
//  YXModelCell.h
//  YXModelTableViews
//
//  Created by Mikhail Kalugin on 5/11/10.
//  Copyright 2010 Yandex. All rights reserved.
//

@protocol YXModelCell <NSObject>

- (UITableViewCell *)tableViewCellWithReusableCell:(UITableViewCell *)reusableCell;
@property (nonatomic, readonly) NSString *reuseIdentifier;

@optional
@property (nonatomic) CGFloat height;
@property (nonatomic, strong) UIImage *image;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath;

@end

typedef void      (^YXBlock)(void);
typedef void      (^YXSenderBlock)(id <YXModelCell> sender);
typedef void      (^YXNumberSenderBlock)(id <YXModelCell> sender, NSUInteger value);
typedef void      (^YXBoolSenderBlock)(id <YXModelCell> sender, BOOL value);
typedef BOOL      (^YXValidationBlock)(id <YXModelCell> sender, BOOL value);
typedef NSUInteger(^YXNumberGetterBlock)(id sender);
typedef BOOL      (^YXBoolGetterBlock)(id sender);

@protocol YXModelCellWithEditing <NSObject, YXModelCell>

@property (nonatomic) UITableViewCellAccessoryType editingAccessoryType;
@property (nonatomic, copy) YXSenderBlock editHandler;

@end