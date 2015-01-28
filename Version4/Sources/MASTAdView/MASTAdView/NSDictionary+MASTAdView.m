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


#import "NSDictionary+MASTAdView.h"

@implementation NSDictionary (MASTAdView)

+ (id)dictionaryWithJavaScriptObject:(NSString*)javaScriptObject
{
    return [self parseJSONString:javaScriptObject];
}

+ (id)parseJSONString:(NSString*)string
{
    NSScanner* scanner = [[NSScanner alloc] initWithString:string];
    
    id value = [self parseJSONScanner:scanner];
    
    return value;
}

+ (id)parseJSONScanner:(NSScanner*)scanner
{
    id value = nil;
    double* doubleValue = nil;
    
    [scanner scanCharactersFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] intoString:NULL];
        
    if ([scanner scanString:@"\"" intoString:NULL])
    {
        value = [self parseJSONStringValue:scanner];
    }
    else if ([scanner scanString:@"{" intoString:NULL])
    {
        NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
        
        while (true)
        {
            [scanner scanString:@"," intoString:NULL];
            
            [scanner scanString:@"\"" intoString:NULL];
            NSString* key = [self parseJSONStringValue:scanner];
            [scanner scanString:@":" intoString:NULL];
            
            id object = [self parseJSONScanner:scanner];
            
            if (([key length] > 0) && (object != nil))
            {
                [dictionary setObject:object forKey:key];
            }
            
            [scanner scanCharactersFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] intoString:NULL];
            
            if (([scanner.string characterAtIndex:scanner.scanLocation] == '}'))
            {
                break;
            }
        }
        
        [scanner scanString:@"}" intoString:NULL];
        
        value = dictionary;
    }
    else if ([scanner scanString:@"[" intoString:NULL])
    {
        while (true)
        {
            [scanner scanString:@"," intoString:NULL];
            
            // TODO: value = parseArray

            [scanner scanCharactersFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] intoString:NULL];
            if (([scanner.string characterAtIndex:scanner.scanLocation] == ']'))
            {
                break;
            }
        }
    }
    else if ([scanner scanString:@"true" intoString:NULL])
    {
        value = [NSNumber numberWithBool:YES];
    }
    else if ([scanner scanString:@"false" intoString:NULL])
    {
        value = [NSNumber numberWithBool:NO];
    }
    else if ([scanner scanString:@"null" intoString:NULL])
    {
        value = [NSNull null];
    }
    else if ([scanner scanDouble:doubleValue])
    {
        if (doubleValue != nil)
            value = [NSNumber numberWithDouble:*doubleValue];
    }
    
    return value;
}

// assumes scanner is parked on a double quote
+ (NSString*)parseJSONStringValue:(NSScanner*)scanner
{
    NSMutableString* string = [NSMutableString string];
    
    NSString* stringValue = nil;
    while ([scanner scanUpToString:@"\"" intoString:&stringValue])
    {
        [string appendString:stringValue];
        
        // a trailing \ indicates the quote is escaped
        if ([stringValue hasSuffix:@"\\"] == NO)
            break;
        
        // replaces \" with " (unescapes the double quote)
        [string replaceCharactersInRange:NSMakeRange(string.length - 1, 1) withString:@"\""];
        
        // reads past the escaped quote
        [scanner scanString:@"\\\"" intoString:NULL];
    }
    
    // finally reads past the ending double qoute
    [scanner scanString:@"\"" intoString:NULL];

    return string;
}

@end
