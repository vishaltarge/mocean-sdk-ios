//
//  UIAlertView+Blocks.h
//  Shibui
//
//  Created by Jiva DeVoe on 12/28/10.
//  Copyright 2010 Random Ideas, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MASTRIButtonItem.h"


// do nothing, just for make this catagory linked
void useCatagory5();

@interface UIAlertView (Blocks)

-(id)initWithTitle:(NSString *)inTitle message:(NSString *)inMessage cancelButtonItem:(MASTRIButtonItem *)inCancelButtonItem otherButtonItems:(MASTRIButtonItem *)inOtherButtonItems, ... NS_REQUIRES_NIL_TERMINATION;

- (void)addButtonItem:(MASTRIButtonItem *)item;

@end
