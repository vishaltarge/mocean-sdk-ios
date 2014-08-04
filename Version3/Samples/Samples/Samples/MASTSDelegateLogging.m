//
//  MASTSDelegateLogging.m
//  Samples
//
/*
 * PubMatic Inc. (“PubMatic”) CONFIDENTIAL
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

#import "MASTSDelegateLogging.h"

@interface MASTSDelegateLogging ()

@end

@implementation MASTSDelegateLogging

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSInteger zone = 88269;
    
    self.adView.zone = zone;
    self.adView.logLevel = MASTAdViewLogEventTypeDebug;
}

- (void)writeEntry:(NSString*)entry
{
    // Overridden to prevent writing other delegate output since this controller just shows log output.
}

#pragma mark MASTAdViewDelegate

static NSDateFormatter* dateFormatter = nil;

- (BOOL)MASTAdView:(MASTAdView *)adView shouldLogEvent:(NSString *)event ofType:(MASTAdViewLogEventType)type
{
    if (dateFormatter == nil)
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    }

    NSString* entry = [NSString stringWithFormat:@"%@\n%@", [dateFormatter stringFromDate:[NSDate date]], event];
    
    [super writeEntry:entry];
    
    // Returning YES to tell the MASTAdView instance to also send this event to the NSLog console.
    return YES;
}

@end
