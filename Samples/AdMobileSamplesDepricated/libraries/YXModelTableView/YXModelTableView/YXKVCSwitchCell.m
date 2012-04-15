//
//  YXKVOSwitchCell.m
//  YXModelTableViews
//
//  Created by Mikhail Kalugin on 5/11/10.
//  Copyright 2010 Yandex. All rights reserved.
//

#import "YXKVCSwitchCell.h"

@implementation YXKVCSwitchCell

@synthesize object, key;

+ (id)cellWithTitle:(NSString *)title object:(id)object key:(NSString *)key {
	YXKVCSwitchCell *cell = [YXKVCSwitchCell new];
    
    cell.title = title;
	cell.object = object;
	cell.key = key;
    cell.initialValueGetter = ^BOOL(YXKVCSwitchCell *cell) {
        return [[object valueForKey:key] boolValue];
    };
    cell.handler = ^(YXKVCSwitchCell *cell, BOOL value){
        [object setValue:[NSNumber numberWithBool:value] forKey:key];
    };

	return cell;
}

@end
