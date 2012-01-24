//
//  UIActionSheet+Blocks.h
//  Shibui
//
//  Created by Jiva DeVoe on 1/5/11.
//  Copyright 2011 Random Ideas, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MASTRIButtonItem.h"


// do nothing, just for make this catagory linked
void useCatagory6();

@interface UIActionSheet (Blocks) <UIActionSheetDelegate>

-(id)initWithTitle:(NSString *)inTitle cancelButtonItem:(MASTRIButtonItem *)inCancelButtonItem destructiveButtonItem:(MASTRIButtonItem *)inDestructiveItem otherButtonItems:(MASTRIButtonItem *)inOtherButtonItems, ... NS_REQUIRES_NIL_TERMINATION;

- (void)addButtonItem:(MASTRIButtonItem *)item;

@end
