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

//

#import "MASTMRAIDExpandProperties.h"

static NSString* MASTMRAIDExpandPropertiesWidth = @"width";
static NSString* MASTMRAIDExpandPropertiesHeight = @"height";
static NSString* MASTMRAIDExpandPropertiesUseCustomClose = @"useCustomClose";

@implementation MASTMRAIDExpandProperties

@synthesize width, height, useCustomClose;


+ (MASTMRAIDExpandProperties*)propertiesFromArgs:(NSDictionary*)args
{
    MASTMRAIDExpandProperties* properties = [MASTMRAIDExpandProperties new];
    
    // TODO: The boolean checks will be set to false if the value is anything else other than true or unset.
    // Some of them need to default to true if unset so the logic should be updated to check the unset
    // condition or default everything to it's defaults and only set them if set to something.

    properties.width = [[args valueForKey:MASTMRAIDExpandPropertiesWidth] integerValue];
    properties.height = [[args valueForKey:MASTMRAIDExpandPropertiesHeight] integerValue];
    properties.useCustomClose = [[args valueForKey:MASTMRAIDExpandPropertiesUseCustomClose] isEqualToString:@"true"];

    return properties;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.width = 0;
        self.height = 0;
        self.useCustomClose = false;
    }
    return self;
}

- (id)initWithSize:(CGSize)size
{
    self = [self init];
    if (self)
    {
        self.width = size.width;
        self.height = size.height;
    }
    return self;
}

- (NSString*)description
{
    NSString* ucc = @"false";
    if (self.useCustomClose)
        ucc = @"true";
    
    NSString* desc = [NSString stringWithFormat:@"{width:%d,height:%d,useCustomClose:%@}",
                      (int)self.width, (int)self.height, ucc];
    
    return desc;
}

@end
