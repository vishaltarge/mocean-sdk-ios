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

#import "MASTMRAIDOrientationProperties.h"

static NSString* MASTMRAIDOrientationPropertiesAllowOrientationChange = @"allowOrientationChange";
static NSString* MASTMRAIDOrientationPropertiesFOrientation = @"forceOrientation";

static NSString* MASTMRAIDOrientationPropertiesFOrientationPortrait = @"portrait";
static NSString* MASTMRAIDOrientationPropertiesFOrientationLandscape = @"landscape";
static NSString* MASTMRAIDOrientationPropertiesFOrientationNone = @"none";


@implementation MASTMRAIDOrientationProperties

@synthesize allowOrientationChange, forceOrientation;


+ (MASTMRAIDOrientationProperties*)propertiesFromArgs:(NSDictionary*)args
{
    MASTMRAIDOrientationProperties* properties = [MASTMRAIDOrientationProperties new];
    
    // TODO: The boolean checks will be set to false if the value is anything else other than true or unset.
    // Some of them need to default to true if unset so the logic should be updated to check the unset
    // condition or default everything to it's defaults and only set them if set to something.
    
    properties.allowOrientationChange = ![[args valueForKey:MASTMRAIDOrientationPropertiesAllowOrientationChange] isEqualToString:@"false"];
    
    properties.forceOrientation = MASTMRAIDOrientationPropertiesForceOrientationNone;
    NSString* fo = [args valueForKey:MASTMRAIDOrientationPropertiesFOrientation];
    if ([fo isEqualToString:MASTMRAIDOrientationPropertiesFOrientationPortrait])
    {
        properties.forceOrientation = MASTMRAIDOrientationPropertiesForceOrientationPortrait;
    }
    else if ([fo isEqualToString:MASTMRAIDOrientationPropertiesFOrientationLandscape])
    {
        properties.forceOrientation = MASTMRAIDOrientationPropertiesForceOrientationLandscape;
    }
    
    return properties;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.allowOrientationChange = true;
        self.forceOrientation = MASTMRAIDOrientationPropertiesForceOrientationNone;
    }
    return self;
}

- (NSString*)description
{
    NSString* aoc = @"false";
    if (self.allowOrientationChange)
        aoc = @"true";
    
    NSString* fo = nil;
    switch (self.forceOrientation)
    {
        case MASTMRAIDOrientationPropertiesForceOrientationPortrait:
            fo = MASTMRAIDOrientationPropertiesFOrientationPortrait;
            break;
            
        case MASTMRAIDOrientationPropertiesForceOrientationLandscape:
            fo = MASTMRAIDOrientationPropertiesFOrientationLandscape;
            break;
            
        default:
            fo = MASTMRAIDOrientationPropertiesFOrientationNone;
            break;
    }
    
    NSString* desc = [NSString stringWithFormat:@"{allowOrientationChange:%@,forceOrientation:'%@'}", aoc, fo];
    
    return desc;
}

@end
