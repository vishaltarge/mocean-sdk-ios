//
//  YXSection.m
//  YXModelTableViews
//
//  Created by Mikhail Kalugin on 5/11/10.
//  Copyright 2010 Yandex. All rights reserved.
//

#import "YXSection.h"

@implementation YXSection

@synthesize header, footer, headerView, footerView, cells;

#pragma mark - NSObject

+ (id)section {
	return [self sectionWithHeader:nil footer:nil];
}

+ (id)sectionWithHeader:(NSString *)header {
	return [self sectionWithHeader:header footer:nil];
}

+ (id)sectionWithHeader:(NSString *)header footer:(NSString *)footer {
    YXSection *section = [self new];
    section.header = header;
    section.footer = footer;
    return section;
}

- (id)init {
    if ((self = [super init])) {
        self.cells = [NSMutableArray array];
    }
	return self;
}

#pragma mark -

- (void)addCell:(id <YXModelCell>)cell {
	[self.cells addObject:cell];
}

- (void)removeCell:(id <YXModelCell>)cell {
	[self.cells removeObject:cell];
}

- (id)cellAtIndex:(NSInteger)index {
    return [self.cells objectAtIndex:index];
}

- (NSInteger)indexOfCell:(id <YXModelCell>)cell {
    return [self.cells indexOfObject:cell];
}

- (NSInteger)cellCount {
    return self.cells.count;
}

- (void)removeAllCells {
    [self.cells removeAllObjects];
}

- (id <YXModelCell>)lastCell {
    return [self.cells lastObject];
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id [])buffer count:(NSUInteger)len {
    return [self.cells countByEnumeratingWithState:state objects:buffer count:len];
}

@end
