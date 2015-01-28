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

#import "MASTMRAIDResizeProperties.h"

static NSString* MASTMRAIDResizePropertiesWidth = @"width";
static NSString* MASTMRAIDResizePropertiesHeight = @"height";
static NSString* MASTMRAIDResizePropertiesCustomClosePosition = @"customClosePosition";
static NSString* MASTMRAIDResizePropertiesOffsetX = @"offsetX";
static NSString* MASTMRAIDResizePropertiesOffsetY = @"offsetY";
static NSString* MASTMRAIDResizePropertiesAllowOffscreen = @"allowOffscreen";

static NSString* MASTMRAIDResizePropertiesCCPositionTopLeft = @"top-left";
static NSString* MASTMRAIDResizePropertiesCCPositionTopCenter = @"top-center";
static NSString* MASTMRAIDResizePropertiesCCPositionTopRight = @"top-right";
static NSString* MASTMRAIDResizePropertiesCCPositionCenter = @"center";
static NSString* MASTMRAIDResizePropertiesCCPositionBottomLeft = @"bottom-left";
static NSString* MASTMRAIDResizePropertiesCCPositionBottomCenter = @"bottom-center";
static NSString* MASTMRAIDResizePropertiesCCPositionBottomRight = @"bottom-right";


@implementation MASTMRAIDResizeProperties

@synthesize width, height, customClosePosition, offsetX, offsetY, allowOffscreen;


+ (MASTMRAIDResizeProperties*)propertiesFromArgs:(NSDictionary*)args
{
    MASTMRAIDResizeProperties* properties = [MASTMRAIDResizeProperties new];
    
    // TODO: The boolean checks will be set to false if the value is anything else other than true or unset.
    // Some of them need to default to true if unset so the logic should be updated to check the unset
    // condition or default everything to it's defaults and only set them if set to something.
    
    properties.width = [[args valueForKey:MASTMRAIDResizePropertiesWidth] integerValue];
    properties.height = [[args valueForKey:MASTMRAIDResizePropertiesHeight] integerValue];
    properties.offsetX = [[args valueForKey:MASTMRAIDResizePropertiesOffsetX] integerValue];
    properties.offsetY = [[args valueForKey:MASTMRAIDResizePropertiesOffsetY] integerValue];
    properties.allowOffscreen = [[args valueForKey:MASTMRAIDResizePropertiesAllowOffscreen] isEqualToString:@"true"];

    NSString* ccp = [args valueForKey:MASTMRAIDResizePropertiesCustomClosePosition];
    if ([ccp isEqualToString:MASTMRAIDResizePropertiesCCPositionTopLeft])
    {
        properties.customClosePosition = MASTMRAIDResizeCustomClosePositionTopLeft;
    }
    else if ([ccp isEqualToString:MASTMRAIDResizePropertiesCCPositionTopCenter])
    {
        properties.customClosePosition = MASTMRAIDResizeCustomClosePositionTopCenter;
    }
    else if ([ccp isEqualToString:MASTMRAIDResizePropertiesCCPositionTopRight])
    {
        properties.customClosePosition = MASTMRAIDResizeCustomClosePositionTopRight;
    }
    else if ([ccp isEqualToString:MASTMRAIDResizePropertiesCCPositionCenter])
    {
        properties.customClosePosition = MASTMRAIDResizeCustomClosePositionCenter;
    }
    else if ([ccp isEqualToString:MASTMRAIDResizePropertiesCCPositionBottomLeft])
    {
        properties.customClosePosition = MASTMRAIDResizeCustomClosePositionBottomLeft;
    }
    else if ([ccp isEqualToString:MASTMRAIDResizePropertiesCCPositionBottomCenter])
    {
        properties.customClosePosition = MASTMRAIDResizeCustomClosePositionBottomCenter;
    }
    else if ([ccp isEqualToString:MASTMRAIDResizePropertiesCCPositionBottomRight])
    {
        properties.customClosePosition = MASTMRAIDResizeCustomClosePositionBottomRight;
    }

    return properties;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        // Defaults
        self.customClosePosition = MASTMRAIDResizeCustomClosePositionTopRight;
    }
    return self;
}

- (NSString*)description
{
    NSString* ccp = nil;
    switch (self.customClosePosition)
    {
        case MASTMRAIDResizeCustomClosePositionTopLeft:
            ccp = MASTMRAIDResizePropertiesCCPositionTopLeft;
            break;
        case MASTMRAIDResizeCustomClosePositionTopCenter:
            ccp = MASTMRAIDResizePropertiesCCPositionTopCenter;
            break;
        case MASTMRAIDResizeCustomClosePositionTopRight:
            ccp = MASTMRAIDResizePropertiesCCPositionTopRight;
            break;
        case MASTMRAIDResizeCustomClosePositionCenter:
            ccp = MASTMRAIDResizePropertiesCCPositionCenter;
            break;
        case MASTMRAIDResizeCustomClosePositionBottomLeft:
            ccp = MASTMRAIDResizePropertiesCCPositionBottomLeft;
            break;
        case MASTMRAIDResizeCustomClosePositionBottomCenter:
            ccp = MASTMRAIDResizePropertiesCCPositionBottomCenter;
            break;
        case MASTMRAIDResizeCustomClosePositionBottomRight:
            ccp = MASTMRAIDResizePropertiesCCPositionBottomRight;
            break;
    }
    
    NSString* ao = @"false";
    if (self.allowOffscreen)
        ao = @"true";
    
    NSString* desc = [NSString stringWithFormat:@"{width:%d,height:%d,customClosePosition:'%@',offsetX:%d,offsetY:%d,allowOffscreen:%@}", (int)self.width, (int)self.height, ccp, (int)self.offsetX, (int)self.offsetY, ao];
    
    return desc;
}

@end
