//
//  NSDictionary+MASTAdView.m
//  MRAID2
//
//  Created by Jason Dickert on 9/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSDictionary+MASTAdView.h"

@implementation NSDictionary (MASTAdView)

static NSCharacterSet* quotesCharacterSet = nil;

+ (id)dictionaryWithJavaScriptObject:(NSString*)javaScriptObject
{
    if (quotesCharacterSet == nil)
        quotesCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"\"'"];
    
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    
    NSArray* parts = [javaScriptObject componentsSeparatedByString:@";"];
    for (NSString* part in parts)
    {
        NSString* trimmedPart = [part stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        NSRange sepRange = [trimmedPart rangeOfString:@":"];
        if (sepRange.location != NSNotFound)
        {
            NSString* key = [[trimmedPart substringToIndex:sepRange.location] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            NSString* value = [[[trimmedPart substringFromIndex:sepRange.location + 1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] stringByTrimmingCharactersInSet:quotesCharacterSet];
            
            [dictionary setValue:value forKey:key];
        }
    }
    
    return dictionary;
}


@end
