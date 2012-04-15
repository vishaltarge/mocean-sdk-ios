//
//  YXKVOCheckmarkCell.m
//  YXModelTableViews
//
//  Created by Mikhail Kalugin on 6/30/10.
//  Copyright 2010 Yandex. All rights reserved.
//

#import "YXKVCCheckmarkCell.h"

@implementation YXKVCCheckmarkCell

@synthesize key, object, updateAction;

+ (id)cellWithTitle:(NSString *)title object:(id)object key:(NSString *)key {
	YXKVCCheckmarkCell * cell = [YXKVCCheckmarkCell new];
    
	cell.title = title;
	cell.object = object;
	cell.key = key;
    cell.initialValueGetter = ^BOOL(YXKVCCheckmarkCell *cell){
        return [[object valueForKey:key] boolValue];
    };
    cell.handler = ^(YXKVCCheckmarkCell *cell, BOOL value){
        [object setValue:[NSNumber numberWithBool:value] forKey:key];
        
        YXBlock block = cell.updateAction;
        if (block)
            block();
    };

	return cell;
}

@end
