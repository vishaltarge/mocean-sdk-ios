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
//  MASTAdView
//
//  Created on 9/21/12.


#import "NSDate+MASTAdView.h"
#import <time.h>
#import <xlocale.h>


@implementation NSDate (MASTAdView)

static NSCharacterSet* tzMarkerCharacterSet = nil;

// Expects something like: 2012-12-21T10:30:15-0500
+ (id)dateFromW3CCalendarDate:(NSString*)dateString
{
    if (tzMarkerCharacterSet == nil)
        tzMarkerCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"+-"];
    
    if ([dateString length] == 0)
        return nil;
    
    // Needs to have a date and time.
    NSArray* dateAndTime = [dateString componentsSeparatedByString:@"T"];
    if ([dateAndTime count] != 2)
        return nil;
    
    NSString* time = [dateAndTime objectAtIndex:1];
    if ([time hasSuffix:@"Z"])
    {
        // Swap Z for the GMT offset.
        time = [time stringByReplacingOccurrencesOfString:@"Z" withString:@"+0000"];
    }
    else
    {
        NSRange tzMarker = [time rangeOfCharacterFromSet:tzMarkerCharacterSet];
        if (tzMarker.location != NSNotFound)
        {
            // Remove the : from the zone offset.
            NSString* zone = [time substringFromIndex:tzMarker.location];
            NSString* fixedZone = [zone stringByReplacingOccurrencesOfString:@":" withString:@""];
            
            time = [time stringByReplacingOccurrencesOfString:zone withString:fixedZone];
            
            // Add in zero'd seconds if seconds are missing.
            if ([[time componentsSeparatedByString:@":"] count] < 3)
            {
                tzMarker.length = 0;
                time = [time stringByReplacingCharactersInRange:tzMarker withString:@":00"];
            }
        }
        else
        {
            // Add a GMT offset so "something" is there.
            time = [time stringByAppendingString:@"+0000"];
        }
    }

    NSString* fixedDateString = [NSString stringWithFormat:@"%@T%@", 
                                 [dateAndTime objectAtIndex:0],
                                 time];
    
    struct tm parsedTime;
    const char* formatString = "%FT%T%z";
    strptime_l([fixedDateString UTF8String], formatString, &parsedTime, NULL);
    time_t since = mktime(&parsedTime);
    
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:since];
    
    return date;
}

@end
