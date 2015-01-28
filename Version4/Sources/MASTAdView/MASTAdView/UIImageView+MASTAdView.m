/*
 
 * PubMatic Inc. ("PubMatic") CONFIDENTIAL
 
 * Unpublished Copyright (c) 2006-2014 PubMatic, All Rights Reserved.
 
 *
 
 * NOTICE:  All information contained herein is, and remains the property of PubMatic. The intellectual and technical concepts contained
 
 * herein are proprietary to PubMatic and may be covered by U.S. and Foreign Patents, patents in process, and are protected by trade secret or copyright law.
 
 * Dissemination of this information or reproduction of this material is strictly forbidden unless prior written permission is obtained
 
 * from PubMatic.  Access to the source code contained herein is hereby forbidden to anyone except current PubMatic employees, managers or contractors who have executed
 
 * Confidentiality and Non-disclosure agreements explicitly covering such access.
 
 *
 
 * The copyright notice above does not evidence any actual or intended publication or disclosure  of  this source code, which includes
 
 * information that is confidential and/or proprietary, and is a trade secret, of  PubMatic.   ANY REPRODUCTION, MODIFICATION, DISTRIBUTION, PUBLIC  PERFORMANCE,
 
 * OR PUBLIC DISPLAY OF OR THROUGH USE  OF THIS  SOURCE CODE  WITHOUT  THE EXPRESS WRITTEN CONSENT OF PubMatic IS STRICTLY PROHIBITED, AND IN VIOLATION OF APPLICABLE
 
 * LAWS AND INTERNATIONAL TREATIES.  THE RECEIPT OR POSSESSION OF  THIS SOURCE CODE AND/OR RELATED INFORMATION DOES NOT CONVEY OR IMPLY ANY RIGHTS
 
 * TO REPRODUCE, DISCLOSE OR DISTRIBUTE ITS CONTENTS, OR TO MANUFACTURE, USE, OR SELL ANYTHING THAT IT  MAY DESCRIBE, IN WHOLE OR IN PART.
 
 */

//
//  UIImageView+MASTAdView.m
//  MASTAdView
//
//  Created on 10/22/12.


#import "UIImageView+MASTAdView.h"
#import <objc/runtime.h>

static const char* DelayIndexKey = "DelayIndexKey";
static const char* DelayImagesKey = "DelayImagesKey";
static const char* DelayIntervalsKey = "DelayIntervalsKey";
static const char* DelayTimerKey = "DelayTimerKey";

@interface UIImageView()
@property (nonatomic, assign) NSInteger delayIndex;
@property (nonatomic, strong) NSArray* delayImages;
@property (nonatomic, strong) NSArray* delayIntervals;
@property (nonatomic, strong) NSTimer* delayTimer;
@end

@implementation UIImageView (MASTAdView)

- (NSInteger)delayIndex
{
    id obj = objc_getAssociatedObject(self, DelayIndexKey);
    return [obj integerValue];
}

- (void)setDelayIndex:(NSInteger)delayIndex
{
    objc_setAssociatedObject(self, DelayIndexKey, [NSNumber numberWithInteger:delayIndex], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray*)delayImages
{
    id obj = objc_getAssociatedObject(self, DelayImagesKey);
    return obj;
}

- (void)setDelayImages:(NSArray *)delayImages
{
    objc_setAssociatedObject(self, DelayImagesKey, delayImages, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray*)delayIntervals
{
    id obj = objc_getAssociatedObject(self, DelayIntervalsKey);
    return obj;
}

- (void)setDelayIntervals:(NSArray *)delayIntervals
{
    objc_setAssociatedObject(self, DelayIntervalsKey, delayIntervals, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray*)delayTimer
{
    id obj = objc_getAssociatedObject(self, DelayTimerKey);
    return obj;
}

- (void)setDelayTimer:(NSTimer *)delayTimer
{
    objc_setAssociatedObject(self, DelayTimerKey, delayTimer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setImages:(NSArray *)images withDurations:(NSArray *)durations
{
    [self.delayTimer invalidate];
    
    self.delayImages = images;
    self.delayIntervals = durations;
    self.delayIndex = 0;
    
    [self nextDelayImage];
    
    if (([self.delayImages count] == 0) || ([self.delayIntervals count] == 0))
        self.image = nil;
}

- (void)nextDelayImage
{
    if (([self.delayImages count] == 0) || ([self.delayIntervals count] == 0))
        return;
    
    UIImage* image = [self.delayImages objectAtIndex:self.delayIndex];
    NSTimeInterval interval = [[self.delayIntervals objectAtIndex:self.delayIndex] floatValue];
    
    self.image = image;
    
    ++self.delayIndex;
    if (self.delayIndex == [self.delayImages count])
        self.delayIndex = 0;
    
    self.delayTimer = [NSTimer scheduledTimerWithTimeInterval:interval
                                     target:self
                                   selector:@selector(nextDelayImage)
                                   userInfo:nil
                                    repeats:NO];
}

@end
